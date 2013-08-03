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
            -- DONE: check if image already exists
            -- use "insertBy" function and add UniqueImage filename constraint to config/models
            -- save to image directory
            filename <- writeToServer file
            success <- runDB $ insertBy $ Image filename info date
            case success of
              Right _key -> do
                setMessageI MsgFileSaved
                redirect ImagesR
              Left _ -> do
                setMessageI MsgCannotRegisterImage
                redirect ImagesR
        _ -> do
            setMessageI MsgSomethingWentWrong
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
        False -> do
            setMessageI MsgCannotRegisterImage
            redirect ImagesR
        True  -> do
            runDB $ delete imageId
            setMessageI MsgFileDeleted
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