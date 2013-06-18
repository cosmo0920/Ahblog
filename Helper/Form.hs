{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Helper.Form where

import Import
-- to use Html into forms
import Yesod.Form.Nic
import Data.Time
import Yesod.Auth

instance YesodNic App
entryForm :: Form Article
entryForm html = do
  Entity userId _ <- lift requireAuth
  flip renderDivs html $ Article
    <$> pure userId
    <*> areq textField "Title" Nothing
    <*> areq nicHtmlField "Content" Nothing
    <*> areq textField "Slug" Nothing
    <*> aformM (liftIO getCurrentTime)

postForm :: Maybe Article -> Form Article
postForm p html = do
  Entity userId _ <- lift requireAuth
  flip renderDivs html $ Article
    <$> pure userId
    <*> areq textField "Title" (articleTitle <$> p)
    <*> areq nicHtmlField "Content" (articleContent <$> p)
    <*> areq textField "Slug" (articleSlug <$> p)
    <*> aformM (liftIO getCurrentTime)

commentForm :: ArticleId -> Html -> MForm App App (FormResult Comment, Widget)
commentForm articleId = renderDivs $ Comment
  <$> areq textField "Name" Nothing
  <*> (unTextarea <$> areq textareaField "Content" Nothing)
  <*> pure articleId
  <*> aformM (liftIO getCurrentTime)
