{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
module RunDBInsertTest
    ( persistUserSpecs
    , persistImageSpecs
    , persistArticleSpecs
    , persistCommentSpecs
    , persistTagSpecs
    ) where

import TestImport
import qualified Database.Persist as P
import Data.Time (getCurrentTime)
import Control.Monad.IO.Class (liftIO)
import HelperDB

persistUserSpecs :: Spec
persistUserSpecs = do
  ydescribe "User Persist Spec" $ do
    yit "User table can insert and setup/teardown" $ withDeleteUserTable $ do
      let email = "test@example.com"
          name  = "test user"
      key <- runDB $ P.insert $ User {
        userEmail      = email 
      , userScreenName = name
      }
      user <- runDB $ P.get key
      assertEqual "userScreenName" (user >>= return . userScreenName) (Just name)
      assertEqual "userEmail" (user >>= return . userEmail) (Just email)

persistImageSpecs :: Spec
persistImageSpecs = do
  ydescribe "Image Persist Spec" $ do
    yit "Image table can insert and setup/teardown" $ withDeleteImageTable $ do
      createTime <- liftIO $ getCurrentTime
      let imageDateAt = createTime
          imageName   = "test.png"
      key <- runDB $ P.insert $ Image {
        imageFilename    = imageName
      , imageDescription = Nothing -- #=> Maybe Textarea
      , imageDate        = imageDateAt
      }
      image <- runDB $ P.get key
      assertEqual "image" (image >>= return . imageFilename) (Just imageName)
      assertEqual "image" (image >>= return . imageDate) (Just imageDateAt)

persistArticleSpecs :: Spec
persistArticleSpecs = do
  ydescribe "Article Persist Spec" $ do
    yit "Article table can insert and setup/teardown" $ withDeleteArticleTable $ do
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
        P.insert $ Article {
          articleAuthor    = userId
        , articleTitle     = title
        , articleContent   = content
        , articleSlug      = slug
        , articleCreatedAt = createdTime
        }
      article <- runDB $ P.get key
      assertEqual "article" (article >>= return . articleTitle) (Just title)
      assertEqual "article" (article >>= return . articleContent) (Just content)
      assertEqual "article" (article >>= return . articleSlug) (Just slug)
      assertEqual "article" (article >>= return . articleCreatedAt) (Just createTime)

persistCommentSpecs :: Spec
persistCommentSpecs = do
  ydescribe "Comment Persist Spec" $ do
    yit "Comment table can insert and setup/teardown" $ withDeleteCommentTable $ do
      createTime <- liftIO $ getCurrentTime
      let name           = "Anonymous"
          writtenContent = "test comment"
          createdTime    = createTime
      key <- runDB $ do
        --when Article has "UserId", then before create User data
        let email = "test@example.com"
            userDisplayname  = "test user"
        userId <- P.insert $ User {
          userEmail      = email
        , userScreenName = userDisplayname
        }
        let title              = "test"
            content            = "test post"
            slug               = "testSlug"  
            articleCreatedTime = createdTime    
        articleId <- P.insert $ Article {
          articleAuthor    = userId
        , articleTitle     = title
        , articleContent   = content
        , articleSlug      = slug
        , articleCreatedAt = articleCreatedTime
        }
        P.insert $ Comment {
          commentName    = name
        , commentContent = writtenContent
        , commentArticle = articleId
        , commentPosted  = createdTime
        }
      comment <- runDB $ P.get key
      assertEqual "comment" (comment >>= return . commentName) (Just name)
      assertEqual "comment" (comment >>= return . commentContent) (Just writtenContent)

persistTagSpecs :: Spec
persistTagSpecs = do
  ydescribe "Tag Persist Spec" $ do
    yit "Tag table can insert and setup/teardown" $ withDeleteTagTable $ do
      createTime <- liftIO $ getCurrentTime
      let name           = "testTag"
          createdTime    = createTime
      key <- runDB $ do
        --when Article has "UserId", then before create User data
        let email = "test@example.com"
            userDisplayname  = "test user"
        userId <- P.insert $ User {
          userEmail      = email
        , userScreenName = userDisplayname
        }
        let title              = "test"
            content            = "test post"
            slug               = "testSlug"  
            articleCreatedTime = createdTime    
        articleId <- P.insert $ Article {
          articleAuthor    = userId
        , articleTitle     = title
        , articleContent   = content
        , articleSlug      = slug
        , articleCreatedAt = articleCreatedTime
        }
        P.insert $ Tag {
          tagName    = name
        , tagArticle = articleId
        }
      tag <- runDB $ P.get key
      assertEqual "tag" (tag >>= return . tagName) (Just name)
