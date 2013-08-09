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
import Factory.User
import Factory.Image
import Factory.Article
import Factory.Comment
import Factory.Tag
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

      key <- insertUserTable' email name
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

      key <- insertImageTable' imageName imageDateAt
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

      key <- insertArticleTable' title content slug createTime
      article <- runDB $ P.get key
      assertEqual "article" (article >>= return . articleTitle) (Just title)
      assertEqual "article" (article >>= return . articleContent) (Just content)
      assertEqual "article" (article >>= return . articleSlug) (Just slug)
      assertEqual "article" (article >>= return . articleCreatedAt) (Just createTime)

persistCommentSpecs :: Spec
persistCommentSpecs = do
  ydescribe "Comment Persist Spec" $ do
    yit "Comment table can insert and setup/teardown" $ withDeleteCommentTable $ do
      let name           = "Anonymous"
          writtenContent = "test comment"

      key <- insertCommentTable' name writtenContent
      comment <- runDB $ P.get key
      assertEqual "comment" (comment >>= return . commentName) (Just name)
      assertEqual "comment" (comment >>= return . commentContent) (Just writtenContent)

persistTagSpecs :: Spec
persistTagSpecs = do
  ydescribe "Tag Persist Spec" $ do
    yit "Tag table can insert and setup/teardown" $ withDeleteTagTable $ do
      let name           = "testTag"

      key <- insertTagTable' name
      tag <- runDB $ P.get key
      assertEqual "tag" (tag >>= return . tagName) (Just name)
