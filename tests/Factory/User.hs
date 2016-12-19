{-# LANGUAGE OverloadedStrings #-}
module Factory.User
    ( insertUserTable'
    ) where

import TestImport
import qualified Database.Persist as P
import Data.Text

insertUserTable' :: Text -> Text -> Example (Key User)
insertUserTable' ident name = do
  key <- runDB $ P.insert $ User {
    userIdent      = ident
  , userScreenName = name
  }
  user <- runDB $ P.get key
  return key
