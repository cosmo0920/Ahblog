{-# OPTIONS_GHC -fno-warn-orphans #-}
module Helper.ImageForm where
import Data.Time (UTCTime, getCurrentTime)
import Import

uploadDirectory :: FilePath
uploadDirectory = "static"

uploadSubDirectory :: FilePath
uploadSubDirectory = "files"

uploadForm :: Form (FileInfo, Maybe Textarea, UTCTime)
uploadForm = renderBootstrap $ (,,)
    <$> fileAFormReq fsFile
    <*> aopt textareaField fsFileDescr Nothing
    <*> lift (liftIO getCurrentTime)
        where
          fsFile      = "Upload file"      { fsAttrs = [("class", "span5")]}
          fsFileDescr = "file description" { fsAttrs = [("class", "span5")]}