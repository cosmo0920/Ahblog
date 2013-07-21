{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    , navbarSpecs
    ) where

import TestImport

homeSpecs :: Specs
homeSpecs =
  describe "/home tests" $ do
    it "can access /" $ do
      get_ "/"
      statusIs 200

    it "loads the index and checks it looks right at Home" $ do
      get_ "/"
      htmlAllContain "h1" "Internal Blog"

    it "Home html contains hr" $ do
      get_ "/"
      htmlCount "hr" 1

navbarSpecs :: Specs
navbarSpecs = do
    it "Home html contains navbar" $ do
      get_ "/"
      htmlAllContain "body" "div class=\"navbar navbar-inverse\""
      htmlAllContain "body" "div class=\"navbar-inner\""

    it "Home html has a class=\"brand\"" $ do
      get_ "/"
      htmlAllContain "body" "a class=\"brand\""