{-# LANGUAGE OverloadedStrings #-}
module UserProfileTest
    ( userProfileSpecs
    ) where

import TestImport

userProfileSpecs :: Specs
userProfileSpecs =
  describe "not logged in user GET /setting/user" $ do
    it "should be redirect" $ do
      get_ "/setting/user"
      statusIs 303
