module Handler.Blog where

import Import
import Yesod.Paginator
-- import Data.Monoid
import Model.EntryForm
import Model.MakeBrief

getBlogR :: Handler RepHtml
getBlogR = do
  -- Get the list of articles inside the database
  let page = 10
  (articles, widget) <- runDB $ selectPaginated page [] [Desc ArticleId]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  defaultLayout $ do
    setTitle "Admin Page"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "admin")

postBlogR :: Handler RepHtml
postBlogR = do
  ((res,articleWidget),enctype) <- runFormPost entryForm
  case res of
    FormSuccess article -> do
      articleId <- runDB $ insert article
      renderer <- getUrlRenderParams
      let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                       <p> created
                                       <a href=@{BlogR}>Back Admin</a>|]
      setMessage $ toHtml $ html renderer
      redirect $ ArticleR articleId
    _ -> defaultLayout $ do
            setTitle "Please correct your entry form"
            $(widgetFile "articleAddError")

getNewBlogR :: Handler RepHtml
getNewBlogR = do
  -- Get the list of articles inside the database
  articles <- runDB $ selectList [][Desc ArticleId]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  (articleWidget, enctype) <- generateFormPost entryForm
  defaultLayout $ do
    setTitle "Admin Page"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "new")

postNewBlogR :: Handler RepHtml
postNewBlogR = do
  ((res,articleWidget),enctype) <- runFormPost entryForm
  case res of
    FormSuccess article -> do
      articleId <- runDB $ insert article
      renderer <- getUrlRenderParams
      let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                       <p> created
                                       <a href=@{BlogR}>Back Admin</a>|]
      setMessage $ toHtml $ html renderer
      redirect $ ArticleR articleId
    _ -> defaultLayout $ do
            setTitle "Please correct your entry form"
            $(widgetFile "articleAddError")

getBlogViewR :: Handler RepHtml
getBlogViewR = do
  -- Get the list of articles inside the database
  let page = 10
  (articles, widget) <- runDB $ selectPaginated page [] [Desc ArticleId]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  defaultLayout $ do
    setTitle "Internal Blog"
    $(widgetFile "view")

getArticleEditR :: ArticleId -> Handler RepHtml
getArticleEditR articleId = do
  post <- runDB $ get404 articleId
  (postWidget, enctype) <- generateFormPost $ postForm $ Just post
  defaultLayout $ do
    setTitle "Edit Blog"
    addStylesheet $ StaticR css_textarea_css
    $(widgetFile "edit")

postArticleEditR :: ArticleId -> Handler RepHtml
postArticleEditR articleId = do
  ((res, postWidget), enctype) <- runFormPost $ postForm Nothing
  case res of
       FormSuccess post -> do 
         runDB $ do 
           _post <- get404 articleId
           update articleId [ ArticleTitle   =. articleTitle post
                            , ArticleContent =. articleContent post]
         renderer <- getUrlRenderParams
         let html = [hamlet|<span .notice><h4>#{articleTitle post}</h4>
                                          <p> updated
                                          <a href=@{ArticleEditR articleId}>Back Edit</a>|]
         setMessage $ toHtml $ html renderer
         redirect $ ArticleR articleId
       _ -> defaultLayout $ do
         setTitle "Please corrrect your entry form"
         $(widgetFile "edit")

getArticleDeleteR :: ArticleId -> Handler RepHtml
getArticleDeleteR articleId = do
  article <- runDB $ get404 articleId
  runDB $ do
    _post <- get404 articleId
    delete articleId
  renderer <- getUrlRenderParams
  let html = [hamlet|<span .notice><h4>#{articleTitle article}</h4>
                                   <p> deleted|]
  setMessage $ toHtml $ html renderer
  redirect $ BlogR

addStyle :: Widget
addStyle = do
    -- Twitter Bootstrap
    addStylesheetRemote "http://netdna.bootstrapcdn.com/twitter-bootstrap/2.1.0/css/bootstrap-combined.min.css"
    -- message style
    toWidget [lucius|.message { padding: 10px 0; background: #ffffed; } |]
    -- jQuery
    addScriptRemote "http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"
    -- delete function
    toWidget [julius|
$(function(){
    function confirmDelete(link) {
        if (confirm("Are you sure you want to delete this image?")) {
            deleteImage(link);
        };
    }
    function deleteImage(link) {
        $.ajax({
            type: "DELETE",
            url: link.attr("data-img-url"),
        }).done(function(msg) {
            var table = link.closest("table");
            link.closest("tr").remove();
            var rowCount = $("td", table).length;
            if (rowCount === 0) {
                table.remove();
            }
        });
    }
    $("a.delete").click(function() {
        confirmDelete($(this));
        return false;
    });
});
|]
