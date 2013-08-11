{-# LANGUAGE OverloadedStrings #-}
module Factory.Article
    ( insertArticleTable
    , insertArticleTable'
    ) where

import TestImport
import qualified Database.Persist as P
import Data.Time (getCurrentTime, UTCTime)
import Data.Text
import Yesod.Markdown (Markdown)
import Control.Monad.IO.Class (liftIO)

insertArticleTable :: Text -> Example ()
insertArticleTable slug = do
  createTime <- liftIO $ getCurrentTime
  let title       = "test"
      content     = "test post"
      createdTime = createTime
  _ <- runDB $ do
    --when Article has "UserId", then before create User data
    let email = "test@example.com"
        name  = "test user"
    userId <- P.insert $ User {
      userEmail      = email
    , userScreenName = name
    }
    P.insert $ Article {
      articleAuthor    = userId
    , articleTitle     = title
    , articleContent   = content
    , articleSlug      = slug
    , articleDraft     = False
    , articleCreatedAt = createdTime
    }
  return ()

insertArticleTable' :: Text -> Markdown -> Text -> UTCTime -> Example (Key Article)
insertArticleTable' title content slug time = do
  key <- runDB $ do
    --when Article has "UserId", then before create User data
    let email = "test@example.com"
        name  = "test user"
    userId <- P.insert $ User {
      userEmail      = email
    , userScreenName = name
    }
    P.insert $ Article {
      articleAuthor    = userId
    , articleTitle     = title
    , articleContent   = content
    , articleSlug      = slug
    , articleDraft     = False
    , articleCreatedAt = time
    }
  return key