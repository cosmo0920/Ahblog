{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    ) where

import TestImport
import qualified Data.List as L

homeSpecs :: Specs
homeSpecs =
  describe "These are some example tests" $ do

    it "loads the index and checks it looks right" $ do
      get_ "/"
      statusIs 200
      htmlAllContain "h1" "Internal Blog"

    -- user/article/comment/image tables are empty when initial.
    it "leaves the user table empty" $ do
      get_ "/"
      statusIs 200
      users <- runDB $ selectList ([] :: [Filter User]) []
      assertEqual "user table empty" 0 $ L.length users

    it "leaves the article table empty" $ do
      get_ "/"
      statusIs 200
      articles <- runDB $ selectList ([] :: [Filter Article]) []
      assertEqual "article table empty" 0 $ L.length articles

    it "leaves the comment table empty" $ do
      get_ "/"
      statusIs 200
      comments <- runDB $ selectList ([] :: [Filter Image]) []
      assertEqual "article table empty" 0 $ L.length comments

    it "leaves the image table empty" $ do
      get_ "/"
      statusIs 200
      images <- runDB $ selectList ([] :: [Filter Image]) []
      assertEqual "article table empty" 0 $ L.length images