{-# LANGUAGE OverloadedStrings #-}
module Model.InitDB
    ( initDBSpecs
    ) where

import TestImport
import qualified Data.List as L

initDBSpecs :: Spec
initDBSpecs =
  ydescribe "Initial DB should be empty" $ do
    -- user/article/comment/image tables are empty when initial.
    yit "leaves the article table empty" $ do
      articles <- runDB $ selectList ([] :: [Filter Article]) []
      assertEqual "article table empty" 0 $ L.length articles

    yit "leaves the comment table empty" $ do
      comments <- runDB $ selectList ([] :: [Filter Comment]) []
      assertEqual "comment table empty" 0 $ L.length comments

    yit "leaves the image table empty" $ do
      image <- runDB $ selectList ([] :: [Filter Image]) []
      assertEqual "image table empty" 0 $ L.length image

    yit "leaves the tag table empty" $ do
      tag <- runDB $ selectList ([] :: [Filter Tag]) []
      assertEqual "tag table empty" 0 $ L.length tag

    yit "leaves the user table empty" $ do
      users <- runDB $ selectList ([] :: [Filter User]) []
      assertEqual "user table empty" 0 $ L.length users
