module Handler.Blog where

import Import
import Yesod.Paginator
import Data.Time.Format.Human
import Data.Time
import Data.Maybe
import Data.List (head, sortBy)
import Data.Function
import Control.Monad
import qualified Data.Text as T (concat, append)
import Text.Shakespeare.Text (st)
import Database.Persist.Sql
import Yesod.RssFeed
import Helper.Sidebar
import Helper.ArticleInfo
import Helper.MakeBrief

getBlogFeedR :: Handler RepRss
getBlogFeedR = do
  articles <- runDB $ selectList [ArticleDraft !=. True][Desc ArticleCreatedAt, LimitTo 10]
  title <- getBlogTitle
  let entries = flip map articles $ \(Entity _ article) ->
        FeedEntry {
            feedEntryLink = PermalinkR $ articleSlug article
          , feedEntryUpdated = articleCreatedAt article
          , feedEntryTitle = articleTitle article
          , feedEntryContent = toHtml $ makeBrief 500 $ markdownToText $ articleContent article
          }
  let feed = Feed {
          feedTitle = "Blog - " `T.append` title
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
   _  -> rssFeed feed

getBlogViewR :: Handler Html
getBlogViewR = do
  -- Get the list of articles inside the database
  let page = 10
  (articles, widget, articleArchives) <- runDB $ do
    (articles, widget) <- selectPaginated page [ArticleDraft !=. True] [Desc ArticleCreatedAt]
    articleArchives    <- selectList [ArticleDraft !=. True] [Desc ArticleCreatedAt, LimitTo 10]
    return (articles, widget, articleArchives)
  title <- getBlogTitle
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  defaultLayout $ do
    setTitle $ toHtml title
    $(widgetFile "view")

getSearchR :: Handler Html
getSearchR = do
    searchString <- runInputGet $ fromMaybe "" <$> iopt (searchField True) "q"
    articles <-
       if searchString /= ""
       then selectArticles searchString
       else return (mempty)

    now <- liftIO $ getCurrentTime
    defaultLayout $ do
      $(widgetFile "search")
  where
    selectArticles :: Text -> Handler [Entity Article]
    selectArticles t =
      runDB $ rawSql [st| SELECT ?? FROM article
                          WHERE content LIKE ?
                          OR title LIKE ?
                          ORDER BY created_at DESC|] [toPersistValue $ T.concat ["%", t, "%"],toPersistValue $ T.concat ["%", t, "%"]]

getTagR :: Text -> Handler Html
getTagR tag = do
  articles <- runDB $ do
    mapM (get404 . tagArticle . entityVal) =<< selectList [TagName ==. tag] []
  when (null articles) notFound
  defaultLayout $ do
    setTitleI MsgTaggedArticle
    $(widgetFile "inline/tag")
