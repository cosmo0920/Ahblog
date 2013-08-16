{-# LANGUAGE OverloadedStrings #-}
module Feature.Rss
    ( rssSpecs
    ) where

import TestImport
import Helper.DB.SetupTeardown
import Factory.Article

rssSpecs :: Spec
rssSpecs =
  ydescribe "GET /blog/feed" $ do
    ydescribe "feed empty" $ do
      yit "should be notFound" $ do
        get BlogFeedR
        statusIs 404
    ydescribe "blog has only draft article" $ do
      yit "should be notFound" $ withDeleteArticleTable $ do
        let slug = "draftSlug"
        insertDraftArticleTable slug
        get BlogFeedR
        statusIs 404
    ydescribe "feed can read when article is not Draft" $ do
      yit "should be Found" $ withDeleteArticleTable $ do
        let slug = "testSlug"
        insertArticleTable slug
        --when blog has article, one can get BlogFeedR
        get BlogFeedR
        statusIs 200
