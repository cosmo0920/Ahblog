module Foundation where

import Prelude
import Yesod
import Yesod.Static
import Yesod.Auth
import Yesod.Auth.OpenId (authOpenId, IdentifierType (Claimed))
import Yesod.Auth.GoogleEmail2
import Yesod.Auth.Message (AuthMessage (InvalidLogin))
import Yesod.Default.Config
import Yesod.Default.Util (addStaticContentExternal)
import Network.HTTP.Conduit (Manager)
import qualified Settings
import Settings.Development (development)
import qualified Database.Persist
import Settings.StaticFiles
import Database.Persist.Sql (ConnectionPool, SqlBackend, runSqlPool)
import Settings (widgetFile, Extra (..), GoogleLoginKeys (..))
import Model
import Text.Jasmine (minifym)
import Web.ClientSession (getKey)
import Text.Hamlet (hamletFile)
import Yesod.Core.Types (Logger)
import Data.Text
import Data.Maybe (isNothing)
import Control.Applicative

-- | The site argument for your application. This can be a good place to
-- keep settings and values requiring initialization before your application
-- starts running, such as database connections. Every handler will have
-- access to the data present here.
data App = App
    { settings :: AppConfig DefaultEnv Extra
    , getStatic :: Static -- ^ Settings for static file serving.
    , appConnPool :: ConnectionPool -- ^ Database connection pool.
    , httpManager :: Manager
    , persistConfig :: Settings.PersistConf
    , appLogger :: Logger
    , googleLoginKeys :: GoogleLoginKeys
    }

-- Set up i18n messages. See the message folder.
mkMessage "App" "messages" "en"

-- This is where we define all of the routes in our application. For a full
-- explanation of the syntax, please see:
-- http://www.yesodweb.com/book/handler
--
-- This function does three things:
--
-- * Creates the route datatype AppRoute. Every valid URL in your
--   application can be represented as a value of this type.
-- * Creates the associated type:
--       type instance Route App = AppRoute
-- * Creates the value resourcesApp which contains information on the
--   resources declared below. This is used in Handler.hs by the call to
--   mkYesodDispatch
--
-- What this function does *not* do is create a YesodSite instance for
-- App. Creating that instance requires all of the handler functions
-- for our application to be in scope. However, the handler functions
-- usually require access to the AppRoute datatype. Therefore, we
-- split these actions into two functions and place them in separate files.
mkYesodData "App" $(parseRoutesFile "config/routes")

type Form x = Html -> MForm Handler (FormResult x, Widget)
-- Please see the documentation for the Yesod typeclass. There are a number
-- of settings which can be configured by overriding methods here.
instance Yesod App where
    approot = ApprootMaster $ appRoot . settings

    -- Store session data on the client in encrypted cookies,
    -- default session idle timeout is 120 minutes
    makeSessionBackend _ = do
        key <- getKey "config/client_session_key.aes"
        let timeout = 60 * 60 * 24 * 7 -- 1 week
        (getCachedDate, _closeDateCache) <- clientSessionDateCacher timeout
        return . Just $ clientSessionBackend key getCachedDate

    defaultLayout widget = do
        master <- getYesod
        mmsg <- getMessage
        blogTitle <- getBlogTitle

        -- We break up the default layout into two components:
        -- default-layout is the contents of the body tag, and
        -- default-layout-wrapper is the entire page. Since the final
        -- value passed to hamletToRepHtml cannot be a widget, this allows
        -- you to use normal widget features in default-layout.
        maid <- maybeAuthId
        muser <- maybeAuth
        admin <- maybe (return False) (isAdmin' . entityVal) muser
        pc <- widgetToPageContent $ do
            addScript $ StaticR js_jquery_min_js
            addStylesheet $ StaticR css_bootstrap_min_css
            addStylesheet $ StaticR css_bootstrap_select_min_css
            addStylesheet $ StaticR css_radius_button_css
            addStylesheet $ StaticR css_desert_css
            addStylesheet $ StaticR css_markdown_css
            $(widgetFile "default-layout")
            $(widgetFile "normalize")
        giveUrlRenderer $(hamletFile "templates/default-layout-wrapper.hamlet")

    -- This is done to provide an optimization for serving static files from
    -- a separate domain. Please see the staticRoot setting in Settings.hs
    urlRenderOverride y (StaticR s) =
        Just $ uncurry (joinPath y (Settings.staticRoot $ settings y)) $ renderRoute s
    urlRenderOverride _ _ = Nothing

    -- The page to be redirected to when authentication is required.
    authRoute _ = Just $ AuthR LoginR

    -- This function creates static content files in the static folder
    -- and names them based on a hash of their content. This allows
    -- expiration dates to be set far in the future without worry of
    -- users receiving stale content.
    addStaticContent =
        addStaticContentExternal minifym genFileName Settings.staticDir (StaticR . flip StaticRoute [])
      where
        -- Generate a unique filename based on the content itself
        genFileName lbs
            | development = "autogen-" ++ base64md5 lbs
            | otherwise   = base64md5 lbs

    -- Place Javascript at bottom of the body tag so the rest of the page loads first
    jsLoader _ = BottomOfBody

    -- What messages should be logged. The following includes all messages when
    -- in development, and warnings and errors in production.
    shouldLog _ _source level =
        development || level == LevelWarn || level == LevelError

    makeLogger                         = return . appLogger

    isAuthorized AdminR _             = isAdmin
    isAuthorized NewBlogR _           = isAdmin
    isAuthorized (ArticleDeleteR _) _ = isAdmin
    isAuthorized (ArticleEditR _) _   = isAdmin
    isAuthorized (ArticleR _) _       = isAdmin
    isAuthorized (CommentDeleteR _) _ = isAdmin
    isAuthorized (ImageR _) _         = isAdmin
    isAuthorized ImagesR _            = isAdmin
    isAuthorized (UserDeleteR _) _    = isAdmin
    isAuthorized UserSettingR _       = isAuthenticated
    isAuthorized _ _                  = return Authorized

-- How to run database actions.
instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance YesodPersistRunner App where
    getDBRunner = defaultGetDBRunner appConnPool

instance YesodAuth App where
    type AuthId App = UserId

    -- Where to send a user after successful login
    loginDest _ = UserSettingR
    -- Where to send a user after logout
    logoutDest _ = HomeR
    -- Override the above two destinations when a Referer: header is present
    redirectToReferer _ = True

    authenticate creds = runDB $ do
      x <- getBy $ UniqueUser $ credsIdent creds
      case x of
        Just (Entity uid _) -> return $ Authenticated uid
        Nothing -> Authenticated <$> insert User
                   { userIdent = credsIdent creds
                   , userScreenName = ""
                   }

    -- You can add other plugins like Google Email, email or OAuth here
    authPlugins m = [authOpenId Claimed []] ++ [authGoogleEmail (googleLoginClientId $ googleLoginKeys m)  (googleLoginClientSecret $ googleLoginKeys m)]

    authHttpManager = httpManager

instance YesodAuthPersist App where
    type AuthEntity App = User

-- This instance is required to use forms. You can modify renderMessage to
-- achieve customized and internationalized form validation messages.
instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

-- | Get the 'Extra' value, used to hold data from the settings.yml file.
getExtra :: Handler Extra
getExtra = fmap (appExtra . settings) getYesod

getBlogTitle :: Handler Text
getBlogTitle = extraBlogTitle . appExtra . settings <$> getYesod

-- is administrator? return AuthResult ver.
isAdmin :: Handler AuthResult
isAdmin = do
  extra <- getExtra
  mauth <- maybeAuth
  case mauth of
    Nothing -> return AuthenticationRequired
    Just (Entity _ user)
      | userIdent user `elem` extraAdmins extra -> return Authorized
      | otherwise -> unauthorizedI MsgNotAnAdmin

-- is administrator? return Bool ver.
isAdmin' :: User -> Handler Bool
isAdmin' user = do
  adminUser <- extraAdmins . appExtra . settings <$> getYesod
  return $ userIdent user `elem` adminUser

isAuthenticated :: YesodAuth master => HandlerT master IO AuthResult
isAuthenticated = do
    maid <- maybeAuthId
    if isNothing maid
      then return AuthenticationRequired
      else return Authorized

-- Note: previous versions of the scaffolding included a deliver function to
-- send emails. Unfortunately, there are too many different options for us to
-- give a reasonable default. Instead, the information is available on the
-- wiki:
--
-- https://github.com/yesodweb/yesod/wiki/Sending-email
