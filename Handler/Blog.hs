module Handler.Blog where

import Import
import Yesod.Paginator
import Helper.MakeBrief
import Data.Time.Format.Human
import Data.Time
import qualified Data.Text as T (concat)
import Database.Persist.GenericSql

getBlogViewR :: Handler RepHtml
getBlogViewR = do
  -- Get the list of articles inside the database
  let page = 10
  now <- liftIO $ getCurrentTime
  (articles, widget) <- runDB $ selectPaginated page [] [Desc ArticleCreatedAt]
  articleArchives <- runDB $ selectList [] [Desc ArticleCreatedAt, LimitTo 10]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  defaultLayout $ do
    setTitle "Internal Blog"
    $(widgetFile "view")

getSearchR :: Text -> Handler RepHtml
getSearchR searchString = do
    articles <- selectArticles searchString
    defaultLayout $ do
      $(widgetFile "search")
  where
    selectArticles :: Text -> Handler [Entity Article]
    selectArticles t = runDB $ rawSql s [toPersistValue $ T.concat ["%", t, "%"]]
      where s = "SELECT ?? FROM article WHERE content LIKE ?"
