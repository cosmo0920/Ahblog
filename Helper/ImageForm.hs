{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Helper.ImageForm where
import Data.Time (UTCTime, getCurrentTime)
import Import

uploadDirectory :: FilePath
uploadDirectory = "static"

uploadSubDirectory :: FilePath
uploadSubDirectory = "files"

uploadForm :: Form (FileInfo, Maybe Textarea, UTCTime)
uploadForm = renderDivs $ (,,)
    <$> fileAFormReq "Upload file"
    <*> aopt textareaField "file description" Nothing
    <*> aformM (liftIO getCurrentTime)