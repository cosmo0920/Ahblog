{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
module RunDBInsertTest
    ( persistUserSpecs
    , persistImageSpecs
    , persistArticleSpecs
    ) where

import TestImport
import qualified Database.Persist as P
import Control.Exception.Lifted (bracket_)
import Data.Time (getCurrentTime)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.State.Lazy

--WIP
--Yesod Test 1.2 type?
--withDeleteUserTable :: Spec Connection a -> Spec Connection a
withDeleteUserTable = bracket_ setUpUserTable tearDownUserTable
  where
    setUpUserTable = deleteUserTable
    tearDownUserTable = deleteUserTable
    deleteUserTable = runDB $ P.deleteWhere ([] :: [P.Filter User])

--withDeleteImageTable :: Spec Connection a -> Spec Connection a
withDeleteImageTable = bracket_ setUpImageTable tearDownImageTable
  where
    setUpImageTable = deleteImageTable
    tearDownImageTable = deleteImageTable
    deleteImageTable = runDB $ P.deleteWhere ([] :: [P.Filter Image])

--withDeleteArticleTable :: Spec Connection a -> Spec Connection a
withDeleteArticleTable = bracket_ setUpArticleTable tearDownArticleTable
  where
    setUpArticleTable = deleteArticleTable
    tearDownArticleTable = deleteArticleTable
    deleteArticleTable = runDB $ do
      P.deleteWhere ([] :: [P.Filter Article])
      P.deleteWhere ([] :: [P.Filter User])

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
