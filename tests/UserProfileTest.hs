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

    describe "/about contains footer" $ do
     it "footer contains Code" $ do
        get_ "/about"
        statusIs 200
        let source = "Code"
        htmlAllContain "footer" source

     it "footer contains License" $ do
        get_ "/about"
        statusIs 200
        let license = "MIT License"
        htmlAllContain "footer" license