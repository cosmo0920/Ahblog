module Handler.About where

import Import
import Yesod.Markdown
import System.FilePath

getAboutR :: Handler RepHtml
getAboutR = do
  fileData <- liftIO $ markdownFromFile aboutPage
  defaultLayout $ do
    setTitleI MsgAboutTitle
    [whamlet|$newline never
     #{fileData}
     |]

aboutPage :: String
aboutPage = "page" </> "about.md"