{-# LANGUAGE OverloadedStrings #-}
module Handler.Admin
    ( adminSpecs,
      admintoolsSpecs
    ) where

import TestImport
import Yesod.Auth

adminSpecs :: Spec
adminSpecs =
  ydescribe "website has auth page" $ do
    yit "GET /auth/login" $ do
      get $ AuthR LoginR
      statusIs 200

    yit "GET /auth/logout" $ do
      get $ AuthR LogoutR
      statusIs 200

admintoolsSpecs :: Spec
admintoolsSpecs =
  ydescribe "not admin user" $ do
    yit "GET /admin/manage should redirect" $ do
      get AdminR
      statusIs 303

    yit "GET /admin/new should redirect" $ do
      get NewBlogR
      statusIs 303

    yit "GET /file should redirect" $ do
      get ImagesR
      statusIs 303
