{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import Import
import Yesod.Default.Config
import Yesod.Test
import Application (makeFoundation)

import HomeTest
import AboutTest
import InitDBTest
import AdminTest
import UserProfileTest
import RssTest
import VisitUserTest

main :: IO ()
main = do
    conf <- loadConfig $ (configSettings Testing) { csParseExtra = parseExtra }
    foundation <- makeFoundation conf
    app <- toWaiAppPlain foundation
    runTests app (connPool foundation) $ do
      initDBSpecs
      homeSpecs
      navbarSpecs
      aboutSpecs
      adminSpecs
      admintoolsSpecs
      userProfileSpecs
      rssSpecs
      visitUserSpecs
