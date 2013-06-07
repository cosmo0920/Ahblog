module Handler.Blog where

import Import
import Yesod.Paginator
import Helper.MakeBrief

getBlogViewR :: Handler RepHtml
getBlogViewR = do
  -- Get the list of articles inside the database
  let page = 10
  (articles, widget) <- runDB $ selectPaginated page [] [Desc ArticleCreatedAt]
  articleArchives <- runDB $ selectList [] [Desc ArticleCreatedAt, LimitTo 10]
  -- We'll need the two "objects": articleWidget and enctype
  -- to construct the form (see templates/articles.hamlet).
  defaultLayout $ do
    setTitle "Internal Blog"
    $(widgetFile "view")

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
