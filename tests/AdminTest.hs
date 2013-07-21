{-# LANGUAGE OverloadedStrings #-}
module AdminTest
    ( adminSpecs,
      admintoolsSpecs
    ) where

import TestImport

adminSpecs :: Specs
adminSpecs =
  describe "website has auth page" $ do
    it "GET /auth/login" $ do
      get_ "/auth/login"
      statusIs 200
    
    it "GET /auth/logout" $ do
      get_ "/auth/logout"
      statusIs 200

admintoolsSpecs :: Specs
admintoolsSpecs =
  describe "not admin user GET /admin" $ do
    it "/manage should redirect" $ do
      get_ "/admin/manage"
      statusIs 303