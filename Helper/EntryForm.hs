{-# OPTIONS_GHC -fno-warn-orphans #-}
module Helper.EntryForm where

import Import
-- to use Html into forms
import Yesod.Form.Nic
import Data.Time
instance YesodNic App
entryForm :: Form Article
entryForm = renderDivs $ Article
  <$> areq textField "Title" Nothing
  <*> areq nicHtmlField "Content" Nothing
  <*> areq textField "Slug" Nothing  
  <*> aformM (liftIO getCurrentTime)

postForm :: Maybe Article -> Form Article
postForm p = renderDivs $ Article 
  <$> areq textField "Title" (articleTitle <$> p)
  <*> areq nicHtmlField "Content" (articleContent <$> p)
  <*> areq textField "Slug" (articleSlug <$> p)
  <*> aformM (liftIO getCurrentTime)

