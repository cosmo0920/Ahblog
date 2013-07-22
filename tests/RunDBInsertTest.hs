{-# LANGUAGE OverloadedStrings #-}
module RunDBInsertTest
    ( persistUserSpecs
    ) where

import TestImport
import Database.Persist.GenericSql (Connection)
import qualified Database.Persist as P
import Control.Exception.Lifted (bracket_)

withDeleteUserTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteUserTable = bracket_ setUpUserTable tearDownUserTable
  where
    setUpUserTable = deleteUserTable
    tearDownUserTable = deleteUserTable
    deleteUserTable = runDB $ P.deleteWhere ([] :: [P.Filter User])

persistUserSpecs :: Specs
persistUserSpecs = do
  describe "User Persist Spec" $ do
    it "User table can insert and seup/teardown" $ withDeleteUserTable $ do
      key <- runDB $ P.insert $ User {
        userEmail = "test@example.com", userScreenName = "test user"
      }
      user <- runDB $ P.get key
      assertEqual "userScreenName" (user >>= return . userScreenName) (Just "test user")
      assertEqual "user Email" (user >>= return . userEmail) (Just "test@example.com")
