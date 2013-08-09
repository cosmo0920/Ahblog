{-# LANGUAGE OverloadedStrings #-}
module RssTest
    ( rssSpecs
    ) where

import TestImport
import HelperDB
import qualified Database.Persist as P
import Data.Time (getCurrentTime)
import Control.Monad.IO.Class (liftIO)

rssSpecs :: Spec
rssSpecs =
  ydescribe "GET /blog/feed" $ do
    ydescribe "feed empty" $ do
      yit "should be notFound" $ do
        get BlogFeedR
        statusIs 404
    ydescribe "feed can read when article is not Draft" $ do
      yit "should be Found" $ withDeleteArticleTable $ do
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
          , articleDraft     = False
          , articleCreatedAt = createdTime
          }
        --when blog has article, one can get BlogFeedR
        get BlogFeedR
        statusIs 200
