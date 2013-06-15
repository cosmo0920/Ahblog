module Handler.Blog where

import Import
import Yesod.Paginator
import Helper.MakeBrief
import Data.Time.Format.Human
import Data.Time

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
