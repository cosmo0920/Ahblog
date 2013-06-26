module Handler.Blog where

import Import
import Yesod.Paginator
import Data.Time.Format.Human
import Data.Time
import Data.Maybe
import Data.List (head, sortBy)
import Data.Function
import Control.Monad
import qualified Data.Text as T (concat)
import Database.Persist.GenericSql
import Yesod.Feed
import Helper.Sidebar
import Helper.ArticleInfo

getBlogFeedR :: Handler RepAtomRss
getBlogFeedR = do
  articles <- runDB $ selectList [][Desc ArticleCreatedAt, LimitTo 10]
  let entries = flip map articles $ \(Entity _ article) ->
        FeedEntry {
            feedEntryLink = PermalinkR $ articleSlug article
          , feedEntryUpdated = articleCreatedAt article
          , feedEntryTitle = articleTitle article
          , feedEntryContent = toHtml $ articleContent article
          }
  let feed = Feed {
          feedTitle = "Blog - InternalBlog"
        , feedLinkSelf = BlogFeedR
        , feedLinkHome = BlogViewR
        , feedAuthor = "cosmo__"
        , feedDescription = "http://cosmo0920.github.com/Ahblog"
        , feedLanguage = "ja"
        , feedUpdated = articleCreatedAt $ entityVal $ head articles
        , feedEntries = entries
        }
  case articles of
   [] -> notFound
   _  -> newsFeed feed

getBlogViewR :: Handler RepHtml
getBlogViewR = do
  -- Get the list of articles inside the database
  let page = 10
  (articles, widget) <- runDB $ selectPaginated page [] [Desc ArticleCreatedAt]
  articleArchives <- runDB $ selectList [] [Desc ArticleCreatedAt, LimitTo 10]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  defaultLayout $ do
    setTitle "Internal Blog"
    $(widgetFile "view")

getSearchR :: Handler RepHtml
getSearchR = do
    searchString <- runInputGet $ fromMaybe "" <$> iopt (searchField True) "q"
    articles <-
       if searchString /= ""
       then selectArticles searchString
       else return (mempty)

    --articles <- selectArticles searchString
    now <- liftIO $ getCurrentTime
    defaultLayout $ do
      $(widgetFile "search")
  where
    selectArticles :: Text -> Handler [Entity Article]
    selectArticles t = runDB $ rawSql s [toPersistValue $ T.concat ["%", t, "%"]]
      where s = "SELECT ?? FROM article WHERE content LIKE ? ORDER BY created_at DESC"

getTagR :: Text -> Handler RepHtml
getTagR tag = do
  articles <- runDB $ do
    mapM (get404 . tagArticle . entityVal) =<< selectList [TagName ==. tag] []
  when (null articles) notFound
  defaultLayout $ do
    setTitle $ "Tagged Article"
    $(widgetFile "inline/tag")