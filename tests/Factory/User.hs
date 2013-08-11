{-# LANGUAGE OverloadedStrings #-}
module Factory.User
    ( insertUserTable'
    ) where

import TestImport
import qualified Database.Persist as P
import Data.Text

insertUserTable' :: Text -> Text -> Example (Key User)
insertUserTable' email name = do
  key <- runDB $ P.insert $ User {
    userEmail      = email
  , userScreenName = name
  }
  user <- runDB $ P.get key
  return key