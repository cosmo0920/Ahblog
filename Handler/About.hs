module Handler.About where

import Import

getAboutR :: Handler RepHtml
getAboutR = do
  defaultLayout $ do
    addStylesheet $ StaticR css_padding_css
    $(widgetFile "about")
