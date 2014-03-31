module Helper.UserForm where

import Import
import Yesod.Auth

userForm :: Form User
userForm html = do
  Entity _ user <- lift requireAuth
  let email      = userEmail user
      screenName = userScreenName user
  flip (renderBootstrap3 BootstrapBasicForm) html $ User
    <$> pure email
    <*> areq textField (fieldSettingsLabel MsgFormUserName) (Just screenName)
