Hello: Hello
## Handler
#Foundation.hs
NotAnAdmin: You have not permission to access this page.
#Image.hs
FileSaved: File saved
FileDeleted: File has been deleted.
CannotRegisterImage: You cannot register same filename image!!
SomethingWentWrong: Something went wrong
#Admin.hs
AdminPageTitle: Admin Page
PostArticleFailure: Please correct your entry form
PostArticleCommentSuccess: Your comment was posted
PostArticleCommentFailure: Error occurred
ArticleSomethingWentWrong: Something went wrong
ArticleDelete: Delete
DeleteOneselfError: You cannot delete yourself!!
ArticleEdit: Edit Article
#Article.hs
ArticleCommentPost: Your comment was posted
ArticleErrorOccurred: Error occurred
ArticleArchive: Article Archive
#Blog.hs
TaggedArticle: Tagged Article
#User.hs
UserSetting: Settings
#About.hs
AboutTitle: About
## Helper
#Form.hs
FormArticleTitle: Title
FormArticleContent: Content
FormArticleSlug: Slug
FormArticleTag: Tag
FormArticleDraft: Draft
FormCommentName: Name
FormCommentContent: Comment
#Image.hs
FormFileUpload: Upload file
FormFileDescription: file description
#UserForm.hs
FormUserName: Screen Name
UserHaveNotPermission: You have not permission.
## template
Login: Login
Logout: Logout
NoArticle: There are no articles in the blog
NoComment: There are no comment in the blog
Profile: Profile
AuthorizationRequired: Authorization required
#admin/delete.hamlet
ArticleDeleteConfirm: Delete Article?
#admin/edit.hamlet
AdminEditArticlePageTitle: Edit Blog Page
AdminArticleUpdate: Update Post
#admin/index.hamlet
AdminCurrentLoginUser user@Text: You are logged in as #{user}.
AdminContent: Admin
AdminTitle: Blog Admin
AdminArticle: Admin Article
AdminComment: Admin Comment
AdminSimplePost: Simple Post
AdminNewPost: New Post
AdminFile: Admin Files
AdminUser: User
AdminName: Name
AdminEmail: Email address
AdminScreenName: Screen name
AdminAbstract: Abstract
AdminIndex: Index article
AdminIndexComment: Index comment
AdminEdit: Edit
AdminDelete: Delete
#admin/image.hamlet
AdminUploadNewFile: Upload new file
AdminFileUpload: Upload
AdminFileName: Filename
AdminFileDescription: Decription
AdminFileUploaded: Uploaded
AdminFileAction: Action
AdminBackTo: ← Back Admin
#admin/new.hamlet
AdminNewPostArticle: Post New Article
AdminPostUserName: Your username
AdminRecentFile: Recent Files
AdminArticlePreview: Preview
#admin/articleAddError.hamlet
ArticleAddErrorTitle: Error occurred! Correct Following entry form:
#inline/articleInfo.hs
PostedTime time@String: Posted at #{time}
PostedAuthor author@Text: Posted by #{author}
#inline/tag.hamlet
TaggedArticlePageTitle: Tagged Article
TaggedArticleTitle: Title
TaggedArticlePosted: Posted
#inline/sidebar.hamlet
SearchPlaceHolder: Search
#archive.hamlet
ArchiveTitle: Title
ArchivePosted: Posted
#home.hamlet
HomeH1: Home
HomeMessage: This is the homepage for the
#view.hamlet
Article: Article
Permalink: Permalink
Comment: Comment
#permalink.hamlet
ArticleNoComment: There are no comment in this article
AddComment: Add Comment
ArticleCommentPostButton: Post Comment
MustBeLoggedIn: You must be logged in to post a comment.
BackToRecentPost: Back Recent Post
#user-setting.hamlet
UpdateUserSetting: User Setting
UpdateScreenName: Update Screen Name
UpdateUserInfo: Update User Information
SwitchLanguage: Switch Langauge
Switch: Switch
BackHome: Back Home
GoBlog: Go Blog
LangEn: English
LangJa: Japanese
#search.hamlet
SearchResult: Search Result
ArticleSearchTitle: Title
ArticleSearchPosted: Posted
ArticleSearchResult msg@Text: Search result for [#{msg}] in this blog articles as follows:
ArticleSearchNoResult msg@Text: There is no match [#{msg}] in this blog articles.
#sidebar.hamlet
RecentPosts: Recent Posts
PostArchive: Archive
PostSearch: Search