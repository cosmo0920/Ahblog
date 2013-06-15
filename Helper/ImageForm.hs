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
uploadSubDirectory = "upload"

uploadForm :: Html -> MForm App App (FormResult (FileInfo, Maybe Textarea, UTCTime), Widget)
uploadForm = renderDivs $ (,,)
    <$> fileAFormReq "Image file"
    <*> aopt textareaField "Image description" Nothing
    <*> aformM (liftIO getCurrentTime)