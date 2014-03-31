{-# OPTIONS_GHC -fno-warn-orphans #-}
module Helper.ImageForm where
import Data.Time (UTCTime, getCurrentTime)
import Import

uploadDirectory :: FilePath
uploadDirectory = "static"

uploadSubDirectory :: FilePath
uploadSubDirectory = "files"

uploadForm :: Form (FileInfo, Maybe Textarea, UTCTime)
uploadForm = renderBootstrap3 BootstrapBasicForm $ (,,)
    <$> fileAFormReq fsFile
    <*> aopt textareaField fsFileDescr Nothing
    <*> lift (liftIO getCurrentTime)
        where
          fsFile      = (fieldSettingsLabel MsgFormFileUpload)      { fsAttrs = [("class", "col-md-12")]}
          fsFileDescr = (fieldSettingsLabel MsgFormFileDescription) { fsAttrs = [("class", "col-md-12")]}