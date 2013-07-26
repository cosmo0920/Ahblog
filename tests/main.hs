{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import Import
import Yesod.Default.Config
import Yesod.Test
import Test.Hspec (hspec)
import Application (makeFoundation)

import HomeTest
import AboutTest
import InitDBTest
import AdminTest
import UserProfileTest
import RssTest
import VisitUserTest
import RunDBInsertTest

main :: IO ()
main = yesodTest

yesodTest :: IO ()
yesodTest = do
    conf <- Yesod.Default.Config.loadConfig $ (configSettings Testing)
	            { csParseExtra = parseExtra
                }
    foundation <- makeFoundation conf
    hspec $ do
      yesodSpec foundation $ do
        initDBSpecs
        homeSpecs
        navbarSpecs
        aboutSpecs
        adminSpecs
        admintoolsSpecs
        userProfileSpecs
        rssSpecs
        visitUserSpecs
        persistUserSpecs
        persistImageSpecs
        persistArticleSpecs
