{-# LANGUAGE OverloadedStrings #-}
module Handler.Home
    ( homeSpecs
    , navbarSpecs
    ) where

import TestImport

homeSpecs :: Spec
homeSpecs =
  ydescribe "/home tests" $ do
    yit "can access /" $ do
      get HomeR
      statusIs 200

    yit "Home html contains class=\"page-header\"" $ do
      get HomeR
      htmlAllContain "body" "div class=\"page-header\""
      htmlCount "h1" 1

    yit "Home html contains hr" $ do
      get HomeR
      htmlCount "hr" 1

navbarSpecs :: Spec
navbarSpecs = do
    yit "Home html contains navbar" $ do
      get HomeR
      htmlAllContain "body" "div class=\"navbar navbar-default navbar-inverse\""
      htmlAllContain "body" "div class=\"navbar-header\""

    yit "Home html has a class=\"navbar-brand\"" $ do
      get HomeR
      htmlAllContain "body" "a class=\"navbar-brand\""
