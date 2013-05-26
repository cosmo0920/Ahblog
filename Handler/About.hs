module Handler.About where

import Import

getAboutR :: Handler RepHtml
getAboutR = do
  defaultLayout $ do
    $(widgetFile "about")
