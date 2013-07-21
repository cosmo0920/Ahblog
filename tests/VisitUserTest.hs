{-# LANGUAGE OverloadedStrings #-}
module VisitUserTest
    ( visitUserSpecs
    ) where

import TestImport

visitUserSpecs :: Specs
visitUserSpecs =
  describe "visit /blog" $ do
    describe "initilal Blog has no contents" $ do
      it "one can GET /blog" $ do
        get_ "/blog"
        statusIs 200

      it "GET /blog" $ do
          get_ "/blog"
          htmlAllContain "h1" "Article"
          htmlAllContain "h3" "no articles"

    describe "Blog has rss Feed img" $ do
      it "GET /blog then html has img tag which contains feed-icon" $ do
        get_ "/blog"
        htmlAllContain "img" "feed-icon"

    describe "Blog has search form" $ do
      it "GET /blog then html has .form-search" $ do
        get_ "/blog"
        htmlAllContain "form" "form-search"

    describe "Blog has sidebar" $ do
      it "GET /blog then html has .span3" $ do
        get_ "/blog"
        htmlAllContain "body" "span3"
        htmlAllContain "body" "align=\"right\""

    describe "/blog contains footer" $ do
     it "footer contains Code" $ do
        get_ "/blog"
        let source = "Code"
        htmlAllContain "footer" source

     it "footer contains License" $ do
        get_ "/blog"
        let license = "MIT License"
        htmlAllContain "footer" license