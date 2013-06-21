module Handler.About where

import Import
import Yesod.Markdown
import System.FilePath

getAboutR :: Handler RepHtml
getAboutR = do
  fileData <- liftIO $ markdownFromFile aboutPage
  defaultLayout $ do
    setTitle "About"
    [whamlet|$newline never
     #{fileData}
     |]

aboutPage :: String
aboutPage = "about" </> "page.md"