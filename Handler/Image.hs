module Handler.Image where

import Import
import System.FilePath
import Data.Text (unpack)
import System.Directory (removeFile, doesFileExist)
import Data.Time
import Data.Time.Format.Human
import Helper.ImageForm

getImagesR :: Handler RepHtml
getImagesR = do
    ((_, widget), enctype) <- runFormPost uploadForm
    images <- runDB $ selectList [ImageFilename !=. ""] [Desc ImageDate]
    mmsg <- getMessage
    now <- liftIO $ getCurrentTime
    defaultLayout $ do
      $(widgetFile "admin/image")

postImagesR :: Handler RepHtml
postImagesR = do
    ((result, _), _) <- runFormPost uploadForm
    case result of
        FormSuccess (file, info, date) -> do
            -- TODO: check if image already exists
            -- save to image directory
            filename <- writeToServer file
            _ <- runDB $ insert (Image filename info date)
            setMessage "Image saved"
            redirect ImagesR
        _ -> do
            setMessage "Something went wrong"
            redirect ImagesR

deleteImageR :: ImageId -> Handler ()
deleteImageR imageId = do
    image <- runDB $ get404 imageId
    let filename = imageFilename image
        path = imageFilePath filename
    liftIO $ removeFile path
    -- only delete from database if file has been removed from server
    stillExists <- liftIO $ doesFileExist path

    case (not stillExists) of 
        False  -> redirect ImagesR
        True -> do
            runDB $ delete imageId
            setMessage "Image has been deleted."
            redirect ImagesR

writeToServer :: FileInfo -> Handler FilePath
writeToServer file = do
    let filename = unpack $ fileName file
        path = imageFilePath filename
    liftIO $ fileMove file path
    return filename

imageFilePath :: String -> FilePath
imageFilePath f = uploadDirectory </> uploadSubDirectory </> f

imageFilePath' :: String -> FilePath
imageFilePath' f = "/" </> uploadDirectory </> uploadSubDirectory </> f