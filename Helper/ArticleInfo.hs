module Helper.ArticleInfo where

import Import
import Data.Time
import Data.Time.Format.Human

articleInfo :: Article -> Widget
articleInfo article = do
  now <- liftIO $ getCurrentTime
  (author, tags) <- handlerToWidget $ runDB $ do
    Entity key Article {articleAuthor, ..} <- getBy404 $ UniqueSlug (articleSlug article)
    author <- get404 articleAuthor
    tags <- map (tagName . entityVal) <$> selectList [TagArticle ==. key] []
    return (author, tags)
  let screenAuthor = userScreenName author
  $(widgetFile "inline/articleInfo")
