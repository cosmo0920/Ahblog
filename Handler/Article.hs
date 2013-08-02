module Handler.Article where

import Import
import Helper.Form
import Helper.Sidebar
import Data.Time
import Data.List (sort, nub)
import Data.Time.Format.Human
import Yesod.Auth

getPermalinkR :: Text -> Handler RepHtml
getPermalinkR slug = do
  maid <- maybeAuthId
  Entity articleId Article {articleTitle, articleContent, articleAuthor, ..} <- runDB $ getBy404 $ UniqueSlug slug
  tags <- sort . nub . map (tagName . entityVal) <$> runDB (selectList [TagArticle ==. articleId] [])
  (comments, author) <- runDB $ do
    comments' <- map entityVal <$>
                selectList [CommentArticle ==. articleId] [Asc CommentPosted]
    author' <- get404 articleAuthor
    return (comments', author')
  published <- liftIO $ humanReadableTime $ articleCreatedAt
  let screenAuthor = userScreenName author
  ((_, commentWidget), enctype) <- runFormPost $ commentForm articleId
  defaultLayout $ do
    setTitle $ toHtml $ articleTitle
    $(widgetFile "permalink")

postPermalinkR :: Text -> Handler RepHtml
postPermalinkR slug = do
  Entity articleId _ <- runDB $ getBy404 $ UniqueSlug slug
  ((res, _), _) <- runFormPost (commentForm articleId)
  case res of
    FormSuccess comment -> do
      _ <- runDB $ insert comment
      setMessageI MsgArticleCommentPost
      redirect $ PermalinkR slug
    _ -> do
      setMessageI MsgArticleErrorOccurred
      redirect $ PermalinkR slug

getArchiveR :: Handler RepHtml
getArchiveR = do
  now <- liftIO $ getCurrentTime
  archives <- runDB $ selectList [] [Desc ArticleCreatedAt]
  defaultLayout $ do
    setTitleI MsgArticleArchive
    $(widgetFile "archive")
