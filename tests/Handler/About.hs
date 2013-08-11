{-# LANGUAGE OverloadedStrings #-}
module Handler.About
    ( aboutSpecs
    ) where

import TestImport

aboutSpecs :: Spec
aboutSpecs =
  ydescribe "/about tests" $ do
    yit "loads the index and checks it looks right at About" $ do
      get AboutR
      statusIs 200
      htmlAllContain "h1" "About"

    yit "about.md contain img" $ do
      get AboutR
      statusIs 200
      htmlAllContain "img" "gravatar.com"

    ydescribe "/about contains footer" $ do
      yit "footer contains Code" $ do
        get AboutR
        statusIs 200
        let source = "Code"
        htmlAllContain "footer" source

      yit "footer contains License" $ do
        get AboutR
        statusIs 200
        let license = "MIT License"
        htmlAllContain "footer" license