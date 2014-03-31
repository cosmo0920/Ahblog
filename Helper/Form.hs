{-# OPTIONS_GHC -fno-warn-orphans #-}
module Helper.Form where

import Import
-- to use Html into forms
import Data.Time
import Yesod.Markdown
import Yesod.Auth
import Data.Maybe
import qualified Data.Text as T

entryForm :: Form (Article, [Text])
entryForm html = postForm Nothing Nothing html

modifyForm :: Article -> [Text] -> Form (Article, [Text])
modifyForm art oldTags = postForm (Just art) (Just oldTags)

postForm :: Maybe Article -> Maybe [Text] -> Form (Article, [Text])
postForm mart mtags html = do
  Entity userId _ <- lift requireAuth
  (r,widget) <- flip (renderBootstrap3 BootstrapBasicForm)  html $
    let art = Article <$> pure userId
                      <*> areq textField     fsTitle   (articleTitle   <$> mart)
                      <*> areq markdownField fsContent (articleContent <$> mart)
                      <*> areq textField     fsSlug    (articleSlug    <$> mart)
                      <*> areq checkBoxField fsDraft   (articleDraft   <$> mart)
                      <*> lift (liftIO getCurrentTime)
        tags = T.words . fromMaybe "" <$> aopt textField fsTag (Just . T.unwords <$> mtags)
    in (,) <$> art <*> tags
  return (r,widget)
      where
        fsTitle   = (fieldSettingsLabel MsgFormArticleTitle)   { fsAttrs = [("class", "col-md-12")] }
        fsContent = (fieldSettingsLabel MsgFormArticleContent) { fsAttrs = [("class", "col-md-12")] }
        fsSlug    = (fieldSettingsLabel MsgFormArticleSlug)    { fsAttrs = [("class", "col-md-12")] }
        fsTag     = (fieldSettingsLabel MsgFormArticleTag)     { fsAttrs = [("class", "col-md-12")] }
        fsDraft   = (fieldSettingsLabel MsgFormArticleDraft)   { fsAttrs = [("class", "col-md-12")] }

commentForm :: ArticleId -> Form Comment
commentForm articleId extra = do
  muser <- lift maybeAuth
  let mname = case muser of
        Just entity -> userScreenName $ entityVal entity
        Nothing -> "Anonymous"
  renderBootstrap3 BootstrapBasicForm (commentAForm mname) extra
  where commentAForm mname = Comment
          <$> areq textField fsName (Just mname)
          <*> (unTextarea <$> areq textareaField fsContent Nothing)
          <*> pure articleId
          <*> lift (liftIO getCurrentTime)
            where
              fsName    = (fieldSettingsLabel MsgFormCommentName)    { fsAttrs = [("class", "col-md-12")] }
              fsContent = (fieldSettingsLabel MsgFormCommentContent) { fsAttrs = [("class", "col-md-12")] }