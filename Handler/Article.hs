{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
module Handler.Article where

import Import
import Helper.Form
import Data.Time
import Data.Time.Format.Human

getPermalinkR :: Text -> Handler RepHtml
getPermalinkR slug = do
  now <- liftIO $ getCurrentTime
  Entity articleId Article {articleTitle, articleContent, ..} <- runDB $ getBy404 $ UniqueSlug slug
  comments<- runDB $ map entityVal <$>
                selectList [CommentArticle ==. articleId] [Asc CommentPosted]
  ((_, commentWidget), enctype) <- runFormPost $ commentForm articleId
  defaultLayout $ do
    setTitle $ toHtml $ articleTitle
    addStylesheet $ StaticR css_commentarea_css
    $(widgetFile "permalink")

postPermalinkR :: Text -> Handler RepHtml
postPermalinkR slug = do
  Entity articleId _ <- runDB $ getBy404 $ UniqueSlug slug
  ((res, _), _) <- runFormPost (commentForm articleId)
  case res of
    FormSuccess comment -> do
      _ <- runDB $ insert comment
      setMessage "Your comment was posted"
      redirect $ PermalinkR slug
    _ -> do
      setMessage "Error occurred"
      redirect $ PermalinkR slug

getArchiveR :: Handler RepHtml
getArchiveR = do
  now <- liftIO $ getCurrentTime
  archives <- runDB $ selectList [] [Desc ArticleCreatedAt]
  defaultLayout $ do
    setTitle "Article Archive"
    $(widgetFile "archive")
