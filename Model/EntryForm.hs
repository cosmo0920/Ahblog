module Model.EntryForm where

import Import
-- to use Html into forms
import Yesod.Form.Nic
instance YesodNic App
entryForm :: Form Article
entryForm = renderDivs $ Article
  <$> areq textField "Title" Nothing
  <*> areq nicHtmlField "Content" Nothing

postForm :: Maybe Article -> Form Article
postForm p = renderDivs $ Article 
  <$> areq textField "Title" (articleTitle <$> p)
  <*> areq nicHtmlField "Content" (articleContent <$> p)
