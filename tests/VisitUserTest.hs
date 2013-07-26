{-# LANGUAGE OverloadedStrings #-}
module VisitUserTest
    ( visitUserSpecs
    ) where

import TestImport

visitUserSpecs :: Spec
visitUserSpecs =
  ydescribe "visit initilal /blog" $ do
    ydescribe "has no contents" $ do
      yit "one can GET /blog" $ do
        get BlogViewR
        statusIs 200

      yit "GET /blog" $ do
        get BlogViewR
        htmlAllContain "h1" "Article"
        htmlAllContain "h3" "no articles"

    ydescribe "Blog has rss Feed img" $ do
      yit "GET /blog then html has img tag which contains feed-icon" $ do
        get BlogViewR
	htmlAllContain "img" "feed-icon"

    ydescribe "Blog has search form" $ do
      yit "GET /blog then html has .form-search" $ do
        get BlogViewR
        htmlAllContain "form" "form-search"

    ydescribe "Blog has sidebar" $ do
      yit "GET /blog then html has .span3" $ do
        get BlogViewR
        htmlAllContain "body" "span3"
        htmlAllContain "body" "align=\"right\""

    ydescribe "/blog contains footer" $ do
      yit "footer contains Code" $ do
        get BlogViewR
        let source = "Code"
        htmlAllContain "footer" source

      yit "footer contains License" $ do
        get BlogViewR
        let license = "MIT License"
        htmlAllContain "footer" license
