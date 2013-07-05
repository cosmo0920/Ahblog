module Helper.MakeBrief where

import Import
import qualified Data.Text as T
import Yesod.Markdown

makeBrief :: Int -> Text -> Text
makeBrief len t | T.length t <= len = t
                | otherwise         = T.take len t `T.append` "..."

markdownToText :: Markdown -> Text
markdownToText (Markdown s) = s

fromString :: String -> T.Text
fromString = T.pack