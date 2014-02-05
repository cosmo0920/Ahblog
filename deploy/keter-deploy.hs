{-# LANGUAGE OverloadedStrings #-}
import Shelly
import Data.Text
import Data.Maybe (fromMaybe)
import Prelude hiding (FilePath)

main :: IO ()
main =  shelly $ do
  cabal_configure
  cabal_build
  let executable = "dist/build/Ahblog/Ahblog"
  run_strip [executable]
  let rm_static = "static/tmp"
  rm_rf rm_static
  let from_cp_dir = "bootstrap-select/"
      require_js  = "bootstrap-select.min.js"
      from_cp_js  = filepath from_cp_dir require_js
      to_cp_js    = filepath "static/js/" require_js
  cp from_cp_js to_cp_js
  let require_css = "bootstrap-select.min.css"
      from_cp_css = filepath "bootstrap-select/" require_css
      to_cp_css   = filepath "static/css/" require_css
  cp from_cp_css to_cp_css
  let keter   = "Ahblog.keter"
      dirs    = ["page","config"]
      statics = ["static/css","static/files","static/img","static/js"]
  run_tar "czvf" ([keter, executable] ++ dirs ++ statics)
  return ()

run_cabal :: Text -> [Text] -> Sh Text
run_cabal option args = do
  cabal <- fmap (fromText . fromMaybe "cabal") $ get_env "CABAL"
  run cabal (option:args)

cabal_configure :: Sh Text
cabal_configure = shelly $ do
  run_cabal "configure" []

cabal_build :: Sh Text
cabal_build = shelly $ do
  run_cabal "build" []

run_strip :: [Text] -> Sh Text
run_strip [args] = shelly $ do
  run "strip" [args]

run_tar :: Text -> [Text] -> Sh Text
run_tar option args = do
  run "tar" (option:args)

filepath :: String -> String -> FilePath
filepath p p' = do
  p </> p'

newtype Sudo a = Sudo { sudo :: Sh a }

run_sudo :: Text -> [Text] -> Sudo Text
run_sudo cmd args = Sudo $ run "/usr/bin/sudo" (cmd:args)