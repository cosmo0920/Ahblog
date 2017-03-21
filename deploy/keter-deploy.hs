import Shelly
import Data.Text hiding (concat)
import Data.Maybe (fromMaybe)
import Prelude hiding (FilePath)

main :: IO ()
main =  shelly $ do
  stack_build
  let lts_ver = "lts-8.5"
  let ghc_ver = "8.0.2"
  let arch = "x86_64-linux"
  let stack_dir = concat $ [".stack-work/install/", arch, "/", lts_ver, "/", ghc_ver, "/"]
  let orig_executable = filepath stack_dir "bin/Ahblog"
  let dist_dir = filepath "dist/build/Ahblog/" "."
  mkdir_p dist_dir
  let executable_path = filepath "dist/build/Ahblog/" "Ahblog"
  let executable = "dist/build/Ahblog/Ahblog"
  cp orig_executable executable_path
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
      statics = ["static/css","static/files","static/img","static/js","static/fonts"]
      dotenv = [".env"]
  run_tar "czvf" ([keter, executable] ++ dirs ++ statics ++ dotenv)
  return ()

run_stack :: Text -> [Text] -> Sh Text
run_stack option args = do
  stack <- fmap (fromText . fromMaybe "stack") $ get_env "STACK"
  run stack (option:args)

stack_build :: Sh Text
stack_build = shelly $ do
  run_stack "build" []

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
