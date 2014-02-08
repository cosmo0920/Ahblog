{-# LANGUAGE OverloadedStrings #-}
module Feature.UserProfile
    ( userProfileSpecs
    ) where

import TestImport

userProfileSpecs :: Spec
userProfileSpecs =
  ydescribe "not logged in user GET /setting/user" $ do
    yit "should be redirect" $ do
      get UserSettingR
      statusIs 302
