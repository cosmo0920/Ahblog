{-# LANGUAGE OverloadedStrings #-}
module RssTest
    ( rssSpecs
    ) where

import TestImport

rssSpecs :: Spec
rssSpecs =
  ydescribe "GET /blog/feed" $ do
    ydescribe "feed empty" $ do
      yit "should be notFound" $ do
        get BlogFeedR
        statusIs 404
    -- describe "feed can read" $ do
    --   it "should be ...?" $ do
    --     pending