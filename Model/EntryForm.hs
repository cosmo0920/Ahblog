module Model.EntryForm where

import Import
-- to use Html into forms
import Yesod.Form.Nic
import Data.Time
instance YesodNic App
entryForm :: Form Article
entryForm = renderDivs $ Article
  <$> areq textField "Title" Nothing
  <*> areq nicHtmlField "Content" Nothing
  <*> aformM (liftIO getCurrentTime)

postForm :: Maybe Article -> Form Article
postForm p = renderDivs $ Article 
  <$> areq textField "Title" (articleTitle <$> p)
  <*> areq nicHtmlField "Content" (articleContent <$> p)
  <*> aformM (liftIO getCurrentTime)
