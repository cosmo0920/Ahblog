{-# LANGUAGE OverloadedStrings #-}
module RssTest
    ( rssSpecs
    ) where

import TestImport
import HelperDB
import qualified Database.Persist as P
import Data.Time (getCurrentTime)
import Control.Monad.IO.Class (liftIO)

rssSpecs :: Specs
rssSpecs =
  describe "GET /blog/feed" $ do
    describe "feed empty" $ do
      it "should be notFound" $ do
        get_ "/blog/feed"
        statusIs 404
    describe "feed can read" $ do
      it "should be Found" $ withDeleteArticleTable $ do
        createTime <- liftIO $ getCurrentTime
        let title = "test"
            content = "test post"
            slug = "testSlug"
            createdTime = createTime
        
        _ <- runDB $ do
          --when Article has "UserId", then before create User data
          let email = "test@example.com"
              name = "test user"
          userId <- P.insert $ User {
            userEmail = email
          , userScreenName = name
          }
          P.insert $ Article {
            articleAuthor = userId
          , articleTitle = title
          , articleContent = content
          , articleSlug = slug
          , articleCreatedAt = createdTime
          }
        --when blog has article, one can get BlogFeedR
        get_ "/blog/feed"
        statusIs 200
