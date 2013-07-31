{-# LANGUAGE OverloadedStrings #-}
module VisitUserTest
    ( visitUserSpecs
    ) where

import TestImport
import HelperDB
import qualified Database.Persist as P
import Data.Time (getCurrentTime)
import Control.Monad.IO.Class (liftIO)

visitUserSpecs :: Specs
visitUserSpecs =
  describe "visit initilal /blog" $ do
    describe "has no contents" $ do 
      it "one can GET /blog" $ do
        get_ "/blog"
        statusIs 200

      it "GET /blog" $ do
          get_ "/blog"
          htmlAllContain "h1" "Article"
          htmlAllContain "h3" "no articles"

    describe "has one contents" $ do
      it "one can GET /blog" $ withDeleteArticleTable $ do
        createTime <- liftIO $ getCurrentTime
        let title       = "test"
            content     = "test post"
            slug        = "testSlug"
            createdTime = createTime

        _ <- runDB $ do
          --when Article has "UserId", then before create User data
          let email = "test@example.com"
              name  = "test user"
          userId <- P.insert $ User {
            userEmail      = email
          , userScreenName = name
          }
          P.insert $ Article {
            articleAuthor    = userId
          , articleTitle     = title
          , articleContent   = content
          , articleSlug      = slug
          , articleCreatedAt = createdTime
          }
        --when blog has article, one can get BlogArticle
        get_ "/blog/post/testSlug"
        statusIs 200
        htmlAllContain "h2" "test"
        htmlAllContain "article" "test post"

    describe "has one content" $ do
      it "when article has no comment" $ withDeleteCommentTable $ do
        createTime <- liftIO $ getCurrentTime
        let title       = "test"
            content     = "test post"
            slug        = "testSlug"
            createdTime = createTime

        _ <- runDB $ do
          --when Article has "UserId", then before create User data
          let email = "test@example.com"
              name  = "test user"
          userId <- P.insert $ User {
            userEmail      = email
          , userScreenName = name
          }
          P.insert $ Article {
            articleAuthor    = userId
          , articleTitle     = title
          , articleContent   = content
          , articleSlug      = slug
          , articleCreatedAt = createdTime
          }
        --when blog has article, one can get BlogArticle
        get_ "/blog/post/testSlug"
        statusIs 200
        htmlAnyContain "h3" "There are no comment in this article"

      it "when article has one comment" $ withDeleteCommentTable $ do
        createTime <- liftIO $ getCurrentTime
        let title       = "test"
            content     = "test post"
            slug        = "testSlug"
            createdTime = createTime

        _ <- runDB $ do
          --when Article has "UserId", then before create User data
          let email = "test@example.com"
              name  = "test user"
          userId <- P.insert $ User {
            userEmail      = email
          , userScreenName = name
          }
          articleId <- P.insert $ Article {
            articleAuthor    = userId
          , articleTitle     = title
          , articleContent   = content
          , articleSlug      = slug
          , articleCreatedAt = createdTime
          }
          let cname    = "Anonymous"
              ccontent = "test comment"
          P.insert $ Comment {
            commentName    = cname
          , commentContent = ccontent
          , commentArticle = articleId
          , commentPosted  = createdTime
          }
        get_ "/blog/post/testSlug"
        statusIs 200
        htmlAnyContain "article" "test comment"

    describe "Blog has rss Feed img" $ do
      it "GET /blog then html has img tag which contains feed-icon" $ do
        get_ "/blog"
        htmlAllContain "img" "feed-icon"

    describe "Blog has search form" $ do
      it "GET /blog then html has .form-search" $ do
        get_ "/blog"
        htmlAllContain "form" "form-search"

      describe "Blog has search path" $ do
        describe "Blog has no contents" $ do
          it "GET /search" $ do
            get_ "/search"
            statusIs 200
            htmlAnyContain "p" "no match"

          it "GET /search?q=test" $ do
            get_ "/search?q=test post"
            statusIs 200
            htmlAnyContain "p" "no match"

        describe "Blog has one contents" $ do
          it "one can get search result" $ withDeleteArticleTable $ do
            createTime <- liftIO $ getCurrentTime
            let title       = "test"
                content     = "test post"
                slug        = "testSlug"
                createdTime = createTime
             
            _ <- runDB $ do
              --when Article has "UserId", then before create User data
              let email = "test@example.com"
                  name  = "test user"
              userId <- P.insert $ User {
                userEmail      = email
              , userScreenName = name
              }
              P.insert $ Article {
                articleAuthor    = userId
              , articleTitle     = title
              , articleContent   = content
              , articleSlug      = slug
              , articleCreatedAt = createdTime
              }
            --when blog has article, one can get BlogArticle
            get_ "/search?q=test post"
            statusIs 200
            htmlAnyContain "p" "test post"

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
