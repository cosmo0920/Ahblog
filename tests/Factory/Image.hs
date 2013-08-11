{-# LANGUAGE OverloadedStrings #-}
module Factory.Image
    ( insertImageTable'
    ) where

import TestImport
import qualified Database.Persist as P
import Data.Time (UTCTime)

insertImageTable' :: String -> UTCTime -> Example (Key Image)
insertImageTable' filename time = do
  key <- runDB $ P.insert $ Image {
    imageFilename    = filename
  , imageDescription = Nothing -- #=> Maybe Textarea
  , imageDate        = time
  }
  return key