{-# LANGUAGE OverloadedStrings #-}
module RssTest
    ( rssSpecs
    ) where

import TestImport

rssSpecs :: Specs
rssSpecs =
  describe "GET /blog/feed" $ do
    describe "feed empty" $ do
      it "should be notFound" $ do
        get_ "/blog/feed"
        statusIs 404
    -- describe "feed can read" $ do
    --   it "should be ...?" $ do
    --     pending