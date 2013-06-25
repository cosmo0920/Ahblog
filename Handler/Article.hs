{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
module Handler.Article where

import Import
import Helper.Form
import Helper.Sidebar
import Data.Time
import Data.List (sort, nub)
import Data.Time.Format.Human
import Yesod.Auth

getPermalinkR :: Text -> Handler RepHtml
getPermalinkR slug = do
  now <- liftIO $ getCurrentTime
  maid <- maybeAuthId
  Entity articleId Article {articleTitle, articleContent, articleAuthor, ..} <- runDB $ getBy404 $ UniqueSlug slug
  tags <- sort . nub . map (tagName . entityVal) <$> runDB (selectList [TagArticle ==. articleId] [])
  (comments, author) <- runDB $ do
    comments <- map entityVal <$>
                selectList [CommentArticle ==. articleId] [Asc CommentPosted]
    author <- get404 articleAuthor
    return (comments, author)
  let screenAuthor = userScreenName author
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
