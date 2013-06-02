module Handler.Admin where

import Import
import Yesod.Paginator
import Yesod.Auth
import Model.EntryForm
import Model.MakeBrief

getBlogR :: Handler RepHtml
getBlogR = do
  -- Get the list of articles inside the database
  let page = 10
  (articles, widget) <- runDB $ selectPaginated page [] [Desc ArticleId]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  maid <- maybeAuthId
  defaultLayout $ do
    setTitle "Admin Page"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "admin")

postBlogR :: Handler RepHtml
postBlogR = do
  ((res,articleWidget),enctype) <- runFormPost entryForm
  case res of
    FormSuccess article -> do
      articleId <- runDB $ insert article
      renderer <- getUrlRenderParams
      let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                       <p> created
                                       <a href=@{BlogR}>Back Admin</a>|]
      setMessage $ toHtml $ html renderer
      redirect $ ArticleR articleId
    _ -> defaultLayout $ do
            setTitle "Please correct your entry form"
            $(widgetFile "articleAddError")

getNewBlogR :: Handler RepHtml
getNewBlogR = do
  -- Get the list of articles inside the database
  articles <- runDB $ selectList [][Desc ArticleId]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  maid <- maybeAuthId
  defaultLayout $ do
    setTitle "Admin Page"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "new")

postNewBlogR :: Handler RepHtml
postNewBlogR = do
  ((res,articleWidget),enctype) <- runFormPost entryForm
  case res of
    FormSuccess article -> do
      articleId <- runDB $ insert article
      renderer <- getUrlRenderParams
      let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                       <p> created
                                       <a href=@{BlogR}>Back Admin</a>|]
      setMessage $ toHtml $ html renderer
      redirect $ ArticleR articleId
    _ -> defaultLayout $ do
            setTitle "Please correct your entry form"
            $(widgetFile "articleAddError")


getArticleEditR :: ArticleId -> Handler RepHtml
getArticleEditR articleId = do
  post <- runDB $ get404 articleId
  (postWidget, enctype) <- generateFormPost $ postForm $ Just post
  maid <- maybeAuthId
  defaultLayout $ do
    setTitle "Edit Blog"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "edit")

postArticleEditR :: ArticleId -> Handler RepHtml
postArticleEditR articleId = do
  ((res, postWidget), enctype) <- runFormPost $ postForm Nothing
  maid <- maybeAuthId
  case res of
       FormSuccess post -> do 
         runDB $ do 
           _post <- get404 articleId
           update articleId [ ArticleTitle   =. articleTitle post
                            , ArticleContent =. articleContent post]
         renderer <- getUrlRenderParams
         let html = [hamlet|<span .notice><h4>#{articleTitle post}</h4>
                                          <p> updated
                                          <a href=@{ArticleEditR articleId}>Back Edit</a>|]
         setMessage $ toHtml $ html renderer
         redirect $ ArticleR articleId
       _ -> defaultLayout $ do
         setTitle "Please corrrect your entry form"
         $(widgetFile "edit")

getArticleDeleteR :: ArticleId -> Handler RepHtml
getArticleDeleteR articleId = do
  article <- runDB $ get404 articleId
  runDB $ do
    _post <- get404 articleId
    delete articleId
  renderer <- getUrlRenderParams
  let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                   <p> deleted|]
  setMessage $ toHtml $ html renderer
  redirect $ BlogR
