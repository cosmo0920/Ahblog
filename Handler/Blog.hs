module Handler.Blog where

import Import
-- import Data.Monoid
import Model.EntryForm

getBlogR :: Handler RepHtml
getBlogR = do
  -- Get the list of articles inside the database
  articles <- runDB $ selectList [][Desc ArticleTitle]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  defaultLayout $ do
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "articles")

postBlogR :: Handler RepHtml
postBlogR = do
  ((res,articleWidget),enctype) <- runFormPost entryForm
  case res of
    FormSuccess article -> do
      articleId <- runDB $ insert article
      setMessage $ toHtml $ (articleTitle article) <> " created"
      redirect $ ArticleR articleId
    _ -> defaultLayout $ do
            setTitle "Please correct your entry form"
            $(widgetFile "articleAddError")

getBlogViewR :: Handler RepHtml
getBlogViewR = do
  -- Get the list of articles inside the database
  articles <- runDB $ selectList [][Desc ArticleTitle]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  defaultLayout $ do
    addStylesheet $ StaticR css_padding_css
    $(widgetFile "view")

getArticleEditR :: ArticleId -> Handler RepHtml
getArticleEditR articleId = do
  post <- runDB $ get404 articleId
  (postWidget, enctype) <- generateFormPost $ postForm $ Just post
  defaultLayout $ do
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "edit")

postArticleEditR :: ArticleId -> Handler RepHtml
postArticleEditR articleId = do
  ((res, postWidget), enctype) <- runFormPost $ postForm Nothing
  case res of
       FormSuccess post -> do 
         runDB $ do 
           _post <- get404 articleId
           update articleId [ ArticleTitle   =. articleTitle post
                            , ArticleContent =. articleContent post]
         setMessage $ toHtml $ (articleTitle post) <> "updated"
         redirect $ ArticleR articleId
       _ -> defaultLayout $ do
         setTitle "Please corrrect your entry form"
         $(widgetFile "edit")

getArticleDeleteR :: ArticleId -> Handler RepHtml
getArticleDeleteR articleId = do
  runDB $ do
    _post <- get404 articleId
    delete articleId
  redirect $ BlogR
