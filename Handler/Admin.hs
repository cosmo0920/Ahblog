module Handler.Admin where

import Import
import Yesod.Paginator
import Yesod.Auth
-- import Control.Monad (forM)
-- import Data.Maybe (fromMaybe)
import Model.EntryForm
import Model.MakeBrief

getBlogR :: Handler RepHtml
getBlogR = do
  -- Get the list of articles inside the database
  let page = 10
  (Entity userId user) <- requireAuth
  let username = userIdent user
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
  (Entity userId user) <- requireAuth
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
  (Entity _ user) <- requireAuth
  let username = userIdent user
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

getArticleR :: ArticleId -> Handler RepHtml
getArticleR articleId = do
    article <- runDB $ get404 articleId
    defaultLayout $ do
        setTitle $ toHtml $ articleTitle article
        $(widgetFile "article")

postNewBlogR :: Handler RepHtml
postNewBlogR = do
  (Entity _ user) <- requireAuth
  let username = userIdent user
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
  (Entity _ user) <- requireAuth
  let username = userIdent user
  maid <- maybeAuthId
  post <- runDB $ get404 articleId
  (postWidget, enctype) <- generateFormPost $ postForm $ Just post
  defaultLayout $ do
    setTitle "Edit Blog"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "edit")

postArticleEditR :: ArticleId -> Handler RepHtml
postArticleEditR articleId = do 
  maid <- maybeAuthId
  (Entity _ user) <- requireAuth
  let username = userIdent user
  ((res, postWidget), enctype) <- runFormPost $ postForm Nothing
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
