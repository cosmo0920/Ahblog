module Handler.Mirror where

import Import
import qualified Data.Text as T

getMirrorR :: Handler RepHtml
getMirrorR = defaultLayout $(widgetFile "mirror")

postMirrorR :: Handler RepHtml
postMirrorR = do
  postedText <- runInputPost $ ireq textField "content"
  defaultLayout $(widgetFile "posted")
