module Handler.Article where

import Import
--import Database.Persist.GenericSql
-- import Database.Persist.Store
getArticleR :: ArticleId -> Handler RepHtml
getArticleR articleId = do
    article <- runDB $ get404 articleId
    defaultLayout $ do
        setTitle $ toHtml $ articleTitle article
        $(widgetFile "article")

-- getSearchR :: Text -> Handler RepHtml
-- getSearchR pattern = do
--     articles <- selectArticleContent pattern
--     defaultLayout $ do
--        setTitle "search result"
--        $(widgetFile "search")
--   where
--     selectArticleContent :: Text -> Handler [Entity Article]
--     selectArticleContent t = runDB $ selectList [Filter Article (Left $ PersistText "%Michael%") (BackendSpecificFilter "LIKE")] []
