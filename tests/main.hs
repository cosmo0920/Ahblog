{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import Import
import Yesod.Default.Config
import Yesod.Test
import Test.Hspec (hspec)
import Application (makeFoundation)

import Handler.Home
import Handler.About
import Handler.Admin
import Feature.UserProfile
import Feature.Rss
import Feature.Blog
import Model.DBInsert
import Model.InitDB

main :: IO ()
main = yesodTest

handlerSpec :: YesodSpec App
handlerSpec = do
  homeSpecs
  navbarSpecs
  aboutSpecs
  adminSpecs
  admintoolsSpecs

featureSpec :: YesodSpec App
featureSpec = do
  userProfileSpecs
  rssSpecs
  visitUserSpecs

modelSpec :: YesodSpec App
modelSpec = do
  initDBSpecs
  persistUserSpecs
  persistImageSpecs
  persistArticleSpecs
  persistCommentSpecs
  persistTagSpecs

yesodTest :: IO ()
yesodTest = do
    conf <- Yesod.Default.Config.loadConfig $ (configSettings Testing)
　              { csParseExtra = parseExtra
                }
    foundation <- makeFoundation conf
    hspec $ do
      yesodSpec foundation $ do
        handlerSpec
        featureSpec
        modelSpec