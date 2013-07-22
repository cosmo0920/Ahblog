{-# LANGUAGE OverloadedStrings #-}
module RunDBInsertTest
    ( persistUserSpecs
    , persistImageSpecs
    ) where

import TestImport
import Database.Persist.GenericSql (Connection)
import qualified Database.Persist as P
import Control.Exception.Lifted (bracket_)
import Data.Time (UTCTime)

withDeleteUserTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteUserTable = bracket_ setUpUserTable tearDownUserTable
  where
    setUpUserTable = deleteUserTable
    tearDownUserTable = deleteUserTable
    deleteUserTable = runDB $ P.deleteWhere ([] :: [P.Filter User])

withDeleteImageTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteImageTable = bracket_ setUpImageTable tearDownImageTable
  where
    setUpImageTable = deleteImageTable
    tearDownImageTable = deleteImageTable
    deleteImageTable = runDB $ P.deleteWhere ([] :: [P.Filter Image])

persistUserSpecs :: Specs
persistUserSpecs = do
  describe "User Persist Spec" $ do
    it "User table can insert and setup/teardown" $ withDeleteUserTable $ do
      key <- runDB $ P.insert $ User {
        userEmail = "test@example.com", userScreenName = "test user"
      }
      user <- runDB $ P.get key
      assertEqual "userScreenName" (user >>= return . userScreenName) (Just "test user")
      assertEqual "userEmail" (user >>= return . userEmail) (Just "test@example.com")

persistImageSpecs :: Specs
persistImageSpecs = do
  describe "Image Persist Spec" $ do
    it "Image table can insert and setup/teardown" $ withDeleteImageTable $ do
      let imageDateAt = (read "2013-06-23 07:24:26.539965 UTC")::UTCTime
          imageName   = "test.png"
      key <- runDB $ P.insert $ Image {
          imageFilename    = imageName
        , imageDescription = Nothing -- #=> Maybe Textarea
        , imageDate        = imageDateAt
      }
      image <- runDB $ P.get key
      assertEqual "image" (image >>= return . imageFilename) (Just imageName)
      assertEqual "image" (image >>= return . imageDate) (Just imageDateAt)