{-# LANGUAGE OverloadedStrings #-}
module InitDBTest
    ( initDBSpecs
    ) where

import TestImport
import qualified Data.List as L

initDBSpecs :: Specs
initDBSpecs =
  describe "Initial DB should be empty" $ do
    -- user/article/comment/image tables are empty when initial.
    it "leaves the article table empty" $ do
      articles <- runDB $ selectList ([] :: [Filter Article]) []
      assertEqual "article table empty" 0 $ L.length articles

    it "leaves the comment table empty" $ do
      comments <- runDB $ selectList ([] :: [Filter Comment]) []
      assertEqual "comment table empty" 0 $ L.length comments

    it "leaves the image table empty" $ do
      image <- runDB $ selectList ([] :: [Filter Image]) []
      assertEqual "image table empty" 0 $ L.length image

    it "leaves the tag table empty" $ do
      tag <- runDB $ selectList ([] :: [Filter Tag]) []
      assertEqual "tag table empty" 0 $ L.length tag

    it "leaves the user table empty" $ do
      users <- runDB $ selectList ([] :: [Filter User]) []
      assertEqual "user table empty" 0 $ L.length users
