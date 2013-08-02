module Handler.User where

import Import
import Yesod.Auth
import Helper.UserForm

getUserSettingR :: Handler RepHtml
getUserSettingR = do
  Entity key user <- requireAuth
  (widget, enctype) <- generateFormPost userForm
  defaultLayout $ do
    setTitleI MsgUserSetting
    $(widgetFile "user-setting")

postUserSettingR :: Handler RepHtml
postUserSettingR = do
  Entity key _ <- requireAuth
  ((result, _), _) <- runFormPost userForm
  liftIO $ print result
  case result of
    FormSuccess newUser -> do
         runDB $ replace key newUser
         redirect UserSettingR
    _ -> permissionDenied "You have not permission."