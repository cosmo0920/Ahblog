{-# LANGUAGE OverloadedStrings #-}
module Factory.Comment
    ( insertCommentTable
    , insertCommentTable'
    ) where

import TestImport
import qualified Database.Persist as P
import Data.Time (getCurrentTime)
import Data.Text
import Control.Monad.IO.Class (liftIO)

insertCommentTable :: Text -> Example ()
insertCommentTable slug = do
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
    articleId <- P.insert $ Article {
      articleAuthor    = userId
    , articleTitle     = title
    , articleContent   = content
    , articleSlug      = slug
    , articleDraft     = False
    , articleCreatedAt = createdTime
    }
    let cname    = "Anonymous"
        ccontent = "test comment"
    P.insert $ Comment {
      commentName    = cname
    , commentContent = ccontent
    , commentArticle = articleId
    , commentPosted  = createdTime
    }
  return ()

insertCommentTable' :: Text -> Text -> Example (Key Comment)
insertCommentTable' cname ccontent = do
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

    P.insert $ Comment {
      commentName    = cname
    , commentContent = ccontent
    , commentArticle = articleId
    , commentPosted  = createdTime
    }
  return key