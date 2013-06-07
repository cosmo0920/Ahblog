module Helper.MakeBrief where

import Import
import qualified Data.Text as T

makeBrief :: Int -> Text -> Text
makeBrief len t | T.length t <= len = t
                  | otherwise         = T.take len t `T.append` "..."
