{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
module HelperDB
    ( withDeleteUserTable
    , withDeleteImageTable
    , withDeleteArticleTable
    , withDeleteCommentTable
    , withDeleteTagTable
    ) where

import TestImport
import Database.Persist.GenericSql (Connection)
import qualified Database.Persist as P
import Control.Exception.Lifted (bracket_)

withDeleteUserTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteUserTable = bracket_ setUpUserTable tearDownUserTable
  where
    setUpUserTable = deleteUserTable
    tearDownUserTable = deleteUserTable
    deleteUserTable = runDB $ P.deleteWhere ([] :: [P.Filter User])

withDeleteImageTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteImageTable = bracket_ setUpImageTable tearDownImageTable
  where
    setUpImageTable = deleteImageTable
    tearDownImageTable = deleteImageTable
    deleteImageTable = runDB $ P.deleteWhere ([] :: [P.Filter Image])

withDeleteArticleTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteArticleTable = bracket_ setUpArticleTable tearDownArticleTable
  where
    setUpArticleTable = deleteArticleTable
    tearDownArticleTable = deleteArticleTable
    deleteArticleTable = runDB $ do
      P.deleteWhere ([] :: [P.Filter Article])
      P.deleteWhere ([] :: [P.Filter User])

withDeleteCommentTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteCommentTable = bracket_ setUpCommentTable tearDownCommentTable
  where
    setUpCommentTable = deleteCommentTable
    tearDownCommentTable = deleteCommentTable
    deleteCommentTable = runDB $ do
      P.deleteWhere ([] :: [P.Filter Comment])
      P.deleteWhere ([] :: [P.Filter Article])
      P.deleteWhere ([] :: [P.Filter User])

withDeleteTagTable :: OneSpec Connection a -> OneSpec Connection a
withDeleteTagTable = bracket_ setUpTagTable tearDownTagTable
  where
   setUpTagTable = deleteTagTable
   tearDownTagTable = deleteTagTable
   deleteTagTable = runDB $ do
     P.deleteWhere ([] :: [P.Filter Tag])
     P.deleteWhere ([] :: [P.Filter Article])
     P.deleteWhere ([] :: [P.Filter User]) 