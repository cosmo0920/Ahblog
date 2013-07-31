{-# LANGUAGE OverloadedStrings #-}
module VisitUserTest
    ( visitUserSpecs
    ) where

import TestImport
import HelperDB
import qualified Database.Persist as P
import Data.Time (getCurrentTime)
import Control.Monad.IO.Class (liftIO)

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
        get $ PermalinkR slug
        statusIs 200
        htmlAllContain "h2" "test"
        htmlAllContain "article" "test post"

    ydescribe "has one content" $ do
      yit "when article has no comment" $ withDeleteCommentTable $ do
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
        get $ PermalinkR slug
        statusIs 200
        htmlAnyContain "h3" "There are no comment in this article"

      yit "when article has one comment" $ withDeleteCommentTable $ do
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
            request $ do
              setMethod "GET"
              setUrl SearchR
              addGetParam "q" "test post"
 
            statusIs 200
            htmlAnyContain "p" "test post"

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
