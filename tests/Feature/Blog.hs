{-# LANGUAGE OverloadedStrings #-}
module Feature.Blog
    ( visitUserSpecs
    ) where

import TestImport
import Helper.DB.SetupTeardown
import Factory.Tag
import Factory.Article
import Factory.Comment

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

    ydescribe "has one contents" $ do
      yit "one can GET /blog" $ withDeleteArticleTable $ do
        let slug = "testSlug"
        insertArticleTable slug
        --when blog has article, one can get BlogArticle
        get $ PermalinkR slug
        statusIs 200
        htmlAllContain "h2" "test"
        htmlAllContain "article" "test post"

    ydescribe "has one content" $ do
      yit "when article has no comment" $ withDeleteCommentTable $ do
        let slug = "testSlug"
        insertArticleTable slug
        --when blog has article, one can get BlogArticle
        get $ PermalinkR slug
        statusIs 200
        htmlAnyContain "h3" "There are no comment in this article"

      yit "when article has one comment" $ withDeleteCommentTable $ do
        let slug = "testSlug"
        insertCommentTable slug
        get $ PermalinkR slug
        statusIs 200
        htmlAnyContain "article" "test comment"

    ydescribe "Blog has rss Feed img" $ do
      yit "GET /blog then html has img tag which contains feed-icon" $ do
        get BlogViewR
        htmlAllContain "img" "feed-icon"

    ydescribe "Blog has search form" $ do
      yit "GET /blog then html has .form-search" $ do
        get BlogViewR
        htmlAllContain "form" "form-search"

      ydescribe "Blog has search path" $ do
        ydescribe "Blog has no contents" $ do
          yit "GET /search" $ do
            get SearchR
            statusIs 200
            htmlAnyContain "p" "no match"

          yit "GET /search?q=test" $ do
            request $ do
              setMethod "GET"
              setUrl SearchR
              addGetParam "q" "test post"

            statusIs 200
            htmlAnyContain "p" "no match"

        ydescribe "Blog has one contents" $ do
          yit "one can get search result" $ withDeleteArticleTable $ do
            let slug = "testSlug"
            insertArticleTable slug
            --when blog has article, one can get BlogArticle
            request $ do
              setMethod "GET"
              setUrl SearchR
              addGetParam "q" "test post"

            statusIs 200
            htmlAnyContain "p" "test post"

    ydescribe "Article has tag" $ do
      yit "GET TagR 'tag'" $ withDeleteTagTable $ do
        insertTagTable
        get $ TagR "tag"
        statusIs 200

    ydescribe "Blog has sidebar" $ do
      yit "GET /blog then html has .span3" $ do
        get BlogViewR
        htmlAllContain "body" "col-md-3"
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
