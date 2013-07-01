{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
module Handler.Admin where

import Import
import Yesod.Paginator
import Yesod.Auth
import Data.Time
import Data.Time.Format.Human
import Control.Monad
import Helper.Form
import Helper.MakeBrief
import Helper.Sidebar
import Handler.Image

getAdminR :: Handler RepHtml
getAdminR = do
  -- Get the list of articles inside the database
  let page = 10
  username <- userScreenName . entityVal <$> requireAuth
  users <- runDB $ selectList [] [Desc UserScreenName]
  (articles, widget) <- runDB $ selectPaginated page [] [Desc ArticleCreatedAt]
  comments <- runDB $ selectList [] [Desc CommentPosted]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  maid <- maybeAuthId
  defaultLayout $ do
    setTitle "Admin Page"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "admin/index")

postAdminR :: Handler RepHtml
postAdminR = do
  ((res,articleWidget),enctype) <- runFormPost entryForm
  case res of
    FormSuccess (article, tags) -> do
      articleId <- runDB $ insert article
      forM_ tags $ \tag -> runDB $ insert $ Tag tag articleId
      renderer <- getUrlRenderParams
      let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                       <p> created
                                       <a href=@{AdminR}>Back Admin</a>|]
      setMessage $ toHtml $ html renderer
      redirect $ ArticleR articleId
    _ -> defaultLayout $ do
            setTitle "Please correct your entry form"
            $(widgetFile "admin/articleAddError")

getNewBlogR :: Handler RepHtml
getNewBlogR = do
  username <- userScreenName . entityVal <$> requireAuth
  -- Get the list of articles inside the database
  articles <- runDB $ selectList [][Desc ArticleCreatedAt]
  images <- runDB $ selectList [ImageFilename !=. ""] [Desc ImageDate]
  now <- liftIO $ getCurrentTime
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  maid <- maybeAuthId
  defaultLayout $ do
    setTitle "Admin Page"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "admin/new")

getArticleR :: ArticleId -> Handler RepHtml
getArticleR articleId = do
  now <- liftIO $ getCurrentTime
  (comments, article, author, tags) <- runDB $ do
    comments <- map entityVal <$>
                selectList [CommentArticle ==. articleId] [Asc CommentPosted]
    article  <- get404 articleId
    Entity key Article {articleAuthor, ..} <- getBy404 $ UniqueSlug (articleSlug article)
    author <- get404 articleAuthor
    tags <- map (tagName . entityVal) <$> selectList [TagArticle ==. key] []
    return (comments, article, author, tags)
  let screenAuthor = userScreenName author
  ((_, commentWidget), enctype) <- runFormPost $ commentForm articleId
  defaultLayout $ do
    setTitle $ toHtml $ articleTitle article
    addStylesheet $ StaticR css_commentarea_css
    $(widgetFile "admin/article")

postArticleR :: ArticleId -> Handler RepHtml
postArticleR articleId = do
  ((res,_), _) <- runFormPost $ commentForm articleId
  case res of
    FormSuccess comment -> do
      _ <- runDB $ insert comment
      setMessage "Your comment was posted"
      redirect $ ArticleR articleId
    _ -> do
      setMessage "Error occurred"
      redirect $ ArticleR articleId

postNewBlogR :: Handler RepHtml
postNewBlogR = do
  (Entity _ user) <- requireAuth
  let username = userScreenName user
  ((res,articleWidget),enctype) <- runFormPost entryForm
  case res of
    FormSuccess (article, tags) -> do
      articleId <- runDB $ insert article
      forM_ tags $ \tag -> runDB $ insert $ Tag tag articleId
      renderer <- getUrlRenderParams
      let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                       <p> created
                                       <a href=@{AdminR}>Back Admin</a>|]
      setMessage $ toHtml $ html renderer
      redirect $ ArticleR articleId
    _ -> defaultLayout $ do
            setTitle "Please correct your entry form"
            $(widgetFile "admin/articleAddError")

getArticleEditR :: ArticleId -> Handler RepHtml
getArticleEditR articleId = do
  (Entity _ user) <- requireAuth
  oldTags <- map (\(Entity _ t) -> tagName t)
                 <$> (runDB $ selectList [TagArticle ==. articleId] [])
  let username = userScreenName user
  maid <- maybeAuthId
  post <- runDB $ get404 articleId
  (postWidget, enctype) <- generateFormPost $ (postForm (Just post) (Just oldTags))
  defaultLayout $ do
    setTitle "Edit Blog"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "admin/edit")

postArticleEditR :: ArticleId -> Handler RepHtml
postArticleEditR articleId = do 
  maid <- maybeAuthId
  (Entity _ user) <- requireAuth
  let username = userScreenName user
  ((res, postWidget), enctype) <- runFormPost entryForm
  case res of
       FormSuccess (post, tags) -> do 
         runDB $ do 
           update articleId [ ArticleTitle =. articleTitle post
                            , ArticleContent =. articleContent post
                            , ArticleSlug =. articleSlug post]
           deleteWhere [TagArticle ==. articleId]
           forM_ tags $ \tag -> insert $ Tag tag articleId
         renderer <- getUrlRenderParams
         let html = [hamlet|<span .notice><h4>#{articleTitle post}</h4>
                                          <p> updated
                                          <a href=@{ArticleEditR articleId}>Back Edit</a>|]
         setMessage $ toHtml $ html renderer
         redirect $ ArticleR articleId
       _ -> defaultLayout $ do
         setTitle "Please corrrect your entry form"
         $(widgetFile "admin/edit")

getArticleDeleteR :: ArticleId -> Handler RepHtml
getArticleDeleteR articleId = do
  article <- runDB $ get404 articleId
  oldTags <- map (\(Entity _ t) -> tagName t)
                 <$> (runDB $ selectList [TagArticle ==. articleId] [])
  (postWidget, enctype) <- generateFormPost $ (postForm (Just article) (Just oldTags))
  defaultLayout $ do
    setTitle "Delete"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "admin/delete")

postArticleDeleteR :: ArticleId -> Handler RepHtml
postArticleDeleteR articleId = do
  article <- runDB $ get404 articleId
  runDB $ do
    _post <- get404 articleId
    delete articleId
    deleteWhere [CommentArticle ==. articleId]
    deleteWhere [TagArticle ==. articleId]
  renderer <- getUrlRenderParams
  let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                   <p> deleted|]
  setMessage $ toHtml $ html renderer
  redirect $ AdminR

getCommentDeleteR :: CommentId -> Handler RepHtml
getCommentDeleteR commentId = do
  comment <- runDB $ get404 commentId
  runDB $ do
    _post <- get404 commentId
    delete commentId
  renderer <- getUrlRenderParams
  let html = [hamlet|<span .notice><h4>#{commentName comment}</h4>
                                   <p> deleted|]
  setMessage $ toHtml $ html renderer
  redirect $ AdminR

getUserDeleteR :: UserId -> Handler RepHtml
getUserDeleteR userId = do
  user <- runDB $ get404 userId
  runDB $ do
    _user <- get404 userId
    delete userId
  renderer <- getUrlRenderParams
  let html = [hamlet|<span .notice><h4>#{userScreenName user}</h4>
                                   <p> deleted|]
  setMessage $ toHtml $ html renderer
  redirect $ AdminR