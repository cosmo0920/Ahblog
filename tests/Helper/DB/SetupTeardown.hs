{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
module Helper.DB.SetupTeardown
    ( withDeleteUserTable
    , withDeleteImageTable
    , withDeleteArticleTable
    , withDeleteCommentTable
    , withDeleteTagTable
    ) where

import TestImport
import qualified Database.Persist as P
import Control.Exception.Lifted (bracket_)

withDeleteUserTable :: YesodExample App a -> YesodExample App a
withDeleteUserTable = bracket_ setUpUserTable tearDownUserTable
  where
    setUpUserTable = deleteUserTable
    tearDownUserTable = deleteUserTable
    deleteUserTable = runDB $ P.deleteWhere ([] :: [P.Filter User])

withDeleteImageTable :: YesodExample App a -> YesodExample App a
withDeleteImageTable = bracket_ setUpImageTable tearDownImageTable
  where
    setUpImageTable = deleteImageTable
    tearDownImageTable = deleteImageTable
    deleteImageTable = runDB $ P.deleteWhere ([] :: [P.Filter Image])

withDeleteArticleTable :: YesodExample App a -> YesodExample App a
withDeleteArticleTable = bracket_ setUpArticleTable tearDownArticleTable
  where
    setUpArticleTable = deleteArticleTable
    tearDownArticleTable = deleteArticleTable
    deleteArticleTable = runDB $ do
      P.deleteWhere ([] :: [P.Filter Article])
      P.deleteWhere ([] :: [P.Filter User])

withDeleteCommentTable :: YesodExample App a -> YesodExample App a
withDeleteCommentTable = bracket_ setUpCommentTable tearDownCommentTable
  where
    setUpCommentTable = deleteCommentTable
    tearDownCommentTable = deleteCommentTable
    deleteCommentTable = runDB $ do
      P.deleteWhere ([] :: [P.Filter Comment])
      P.deleteWhere ([] :: [P.Filter Article])
      P.deleteWhere ([] :: [P.Filter User])

withDeleteTagTable :: YesodExample App a -> YesodExample App a
withDeleteTagTable = bracket_ setUpTagTable tearDownTagTable
  where
   setUpTagTable = deleteTagTable
   tearDownTagTable = deleteTagTable
   deleteTagTable = runDB $ do
     P.deleteWhere ([] :: [P.Filter Tag])
     P.deleteWhere ([] :: [P.Filter Article])
     P.deleteWhere ([] :: [P.Filter User])
