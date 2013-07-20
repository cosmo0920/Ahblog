{-# LANGUAGE OverloadedStrings #-}
module AdminTest
    ( adminSpecs,
      admintoolsSpecs
    ) where

import TestImport

adminSpecs :: Specs
adminSpecs =
  describe "GET /auth" $ do
    it "/login" $ do
      get_ "/auth/login"
      statusIs 200
    
    it "/logout" $ do
      get_ "/auth/logout"
      statusIs 200

admintoolsSpecs :: Specs
admintoolsSpecs =
  describe "not admin user GET /admin" $ do
    it "/manage should redirect" $ do
      get_ "/admin/manage"
      statusIs 303
