{-# LANGUAGE OverloadedStrings #-}
module VisitUserTest
    ( visitUserSpecs
    ) where

import TestImport

visitUserSpecs :: Specs
visitUserSpecs =
  describe "initilal Blog has no contents" $ do
    describe "visit /blog top then html has h# tags" $ do
      it "GET /blog" $ do
        get_ "/blog"
        statusIs 200
        htmlAllContain "h1" "Article"
        htmlAllContain "h3" "no articles"

    describe "Blog has rss Feed img" $ do
      it "GET /blog then html has img tag which contains feed-icon" $ do
        get_ "/blog"
        statusIs 200
        htmlAllContain "img" "feed-icon"

    describe "Blog has search form" $ do
      it "GET /blog then html has .form-search" $ do
        get_ "/blog"
        statusIs 200
        htmlAllContain "form" "form-search"
