{-# LANGUAGE OverloadedStrings #-}
module AboutTest
    ( aboutSpecs
    ) where

import TestImport

aboutSpecs :: Specs
aboutSpecs =
  describe "/about tests" $ do
    it "loads the index and checks it looks right at About" $ do
      get_ "/about"
      statusIs 200
      htmlAllContain "h1" "About"

    it "about.md contain img" $ do
      get_ "/about"
      statusIs 200
      htmlAllContain "img" "gravatar.com"
    
    describe "/about contains footer" $ do
      it "footer contains Code" $ do
        get_ "/about"
        statusIs 200
        let source = "Code"
        htmlAllContain "footer" source

      it "footer contains License" $ do
        get_ "/about"
        statusIs 200
        let license = "MIT License"
        htmlAllContain "footer" license