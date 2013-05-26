module Handler.Article where

import Import

getArticleR :: ArticleId -> Handler RepHtml
getArticleR articleId = do
    article <- runDB $ get404 articleId
    defaultLayout $ do
        setTitle $ toHtml $ articleTitle article
        addStylesheet $ StaticR css_padding_css
        $(widgetFile "article")
