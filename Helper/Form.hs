{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Helper.Form where

import Import
-- to use Html into forms
import Data.Time
import Yesod.Markdown
import Yesod.Auth

entryForm :: Form Article
entryForm html = postForm Nothing html

postForm :: Maybe Article -> Form Article
postForm p html = do
  Entity userId _ <- lift requireAuth
  flip renderDivs html $ Article
    <$> pure userId
    <*> areq textField "Title" (articleTitle <$> p)
    <*> areq markdownField "Content" (articleContent <$> p)
    <*> areq textField "Slug" (articleSlug <$> p)
    <*> aformM (liftIO getCurrentTime)

commentForm :: ArticleId -> Html -> MForm App App (FormResult Comment, Widget)
commentForm articleId extra = do
  muser <- lift maybeAuth
  let mname = case muser of
        Just entity -> userScreenName $ entityVal entity
        Nothing -> "Anonymous"
  renderDivs (commentAForm mname) extra
  where commentAForm mname = Comment
          <$> areq textField "Name" (Just mname)
          <*> (unTextarea <$> areq textareaField "Content" Nothing)
          <*> pure articleId
          <*> aformM (liftIO getCurrentTime)