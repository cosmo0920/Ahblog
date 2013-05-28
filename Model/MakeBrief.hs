module Model.MakeBrief where

import Import
import qualified Data.Text as T

makeSnippet :: Int -> Text -> Text
makeSnippet len t | T.length t <= len = t
                  | otherwise         = T.take len t `T.append` "..."
