{-# LANGUAGE OverloadedStrings #-}
module Factory.Tag
    ( insertTagTable
    , insertTagTable'
    ) where

import TestImport
import qualified Database.Persist as P
import Data.Time (getCurrentTime)
import Data.Text
import Control.Monad.IO.Class (liftIO)

insertTagTable :: Example ()
insertTagTable = do
  createTime <- liftIO $ getCurrentTime
  let title       = "test"
      content     = "test post"
      slug        = "testSlug"
      createdTime = createTime
  _ <- runDB $ do
    --when Article has "UserId", then before create User data
    let email = "test@example.com"
        name  = "test user"
    userId <- P.insert $ User {
      userEmail      = email
    , userScreenName = name
    }
    articleId <- P.insert $ Article {
      articleAuthor    = userId
    , articleTitle     = title
    , articleContent   = content
    , articleSlug      = slug
    , articleDraft     = False
    , articleCreatedAt = createdTime
    }
    P.insert $ Tag {
      tagName = "tag"
    , tagArticle = articleId
    }
  return ()

insertTagTable' :: Text -> Example (Key Tag)
insertTagTable' tname = do
  createTime <- liftIO $ getCurrentTime
  let title       = "test"
      content     = "test post"
      slug        = "testSlug"
      createdTime = createTime
  key <- runDB $ do
    --when Article has "UserId", then before create User data
    let email = "test@example.com"
        name  = "test user"
    userId <- P.insert $ User {
      userEmail      = email
    , userScreenName = name
    }
    articleId <- P.insert $ Article {
      articleAuthor    = userId
    , articleTitle     = title
    , articleContent   = content
    , articleSlug      = slug
    , articleDraft     = False
    , articleCreatedAt = createdTime
    }
    P.insert $ Tag {
      tagName = tname
    , tagArticle = articleId
    }
  return key