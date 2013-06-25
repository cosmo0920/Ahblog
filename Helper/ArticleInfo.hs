{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}
module Helper.ArticleInfo where

import Import

articleInfo :: Article -> Widget
articleInfo article = do 
  (author, tags) <- lift $ runDB $ do
    Entity key Article {articleAuthor, ..} <- getBy404 $ UniqueSlug (articleSlug article)
    author <- get404 articleAuthor
    tags <- map (tagName . entityVal) <$> selectList [TagArticle ==. key] []
    return (author, tags)
  let screenAuthor = userScreenName author
  $(widgetFile "articleInfo")