{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
module Handler.Article where

import Import
import Data.Time
import Data.Time.Format.Human
--import Database.Persist.GenericSql
-- import Database.Persist.Store

getPermalinkR :: Text -> Handler RepHtml
getPermalinkR slug = do
  now <- liftIO $ getCurrentTime
  Entity _ Article {articleTitle, articleContent, ..} <- runDB $ getBy404 $ UniqueSlug slug
  defaultLayout $ do
    setTitle $ toHtml $ articleTitle
    $(widgetFile "permalink")

getArchiveR :: Handler RepHtml
getArchiveR = do
  now <- liftIO $ getCurrentTime
  archives <- runDB $ selectList [] [Desc ArticleCreatedAt]
  defaultLayout $ do
    setTitle "Article Archive"
    $(widgetFile "archive")

-- getSearchR :: Text -> Handler RepHtml
-- getSearchR pattern = do
--     articles <- selectArticleContent pattern
--     defaultLayout $ do
--        setTitle "search result"
--        $(widgetFile "search")
--   where
--     selectArticleContent :: Text -> Handler [Entity Article]
--     selectArticleContent t = runDB $ selectList [Filter Article (Left $ PersistText "%Michael%") (BackendSpecificFilter "LIKE")] []
