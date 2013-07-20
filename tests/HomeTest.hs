{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    ) where

import TestImport

homeSpecs :: Specs
homeSpecs =
  describe "/home tests" $ do

    it "loads the index and checks it looks right at Home" $ do
      get_ "/"
      statusIs 200
      htmlAllContain "h1" "Internal Blog"
