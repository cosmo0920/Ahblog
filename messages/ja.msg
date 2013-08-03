Hello: Hello
## Handler
#Foundation.hs
NotAnAdmin: アクセス権限がありません
#Image.hs
FileSaved: ファイルを保存しました
FileDeleted: ファイルを消去しました
CannotRegisterImage: 同名のファイルは保存できません
SomethingWentWrong: おや？何かがおかしいです
#Admin.hs
AdminPageTitle: 管理ページ
PostArticleFailure: フォームの内容が正しいか確認してください
PostArticleCommentSuccess: コメントが投稿されました
PostArticleCommentFailure: エラーです
ArticleSomethingWentWrong: おや？何かがおかしいです
ArticleDelete: 消去
DeleteOneselfError: 自分で自分自身のアカウントの削除はできません
ArticleEdit: 記事を編集する
#Article.hs
ArticleCommentPost: コメントが投稿されました
ArticleErrorOccurred: エラーです
ArticleArchive: 記事アーカイブ
#Blog.hs
TaggedArticle: タグ付けされた記事
#User.hs
UserSetting: ユーザー設定
#About.hs
AboutTitle: 概要
## Helper
#Form.hs
FormArticleTitle: タイトル
FormArticleContent: 内容
FormArticleSlug: スラグ
FormArticleTag: タグ
FormCommentName: 名前
FormCommentContent: コメント
#Image.hs
FormFileUpload: アップロード
FormFileDescription: ファイルの説明
#UserForm.hs
FormUserName: 表示名
UserHaveNotPermission: 権限がありません
## template
Login: ログイン
Logout: ログアウト
NoComment: コメントはありません
Profile: プロフィール
AuthorizationRequired: 認証が必要です
#admin/index.hamlet
AdminLoginUser: 現在ログインしているユーザー
AdminContent: 管理
AdminTitle: ブログ管理
AdminArticle: 記事管理
AdminComment: コメント管理
AdminSimplePost: シンプル投稿
AdminNewPost: 新しい投稿
AdminFile: ファイル管理
AdminUser: ユーザー
AdminName: 名前
AdminEmail: メールアドレス
AdminScreenName: 表示名
AdminAbstract: 概要
AdminIndex: 記事一覧
AdminIndexComment: コメント一覧
AdminEdit: 編集
AdminDelete: 消去
#admin/delete.hamlet
ArticleDeleteConfirm: この記事を消去しますか？
#admin/edit.hamlet
AdminEditArticlePageTitle: ブログ記事の編集
AdminArticleUpdate: 記事を更新
#admin/image.hamlet
AdminUploadNewFile: 新しいファイルのアップロード
AdminFileName: ファイル名
AdminFileUpload: アップロード
AdminFileDescription: 説明
AdminFileUploaded: アップロード時間
AdminFileAction: アクション
AdminBackTo: ← 管理ページに戻る
#admin/new.hamlet
AdminNewPostArticle: 新しい記事を投稿する
AdminPostUserName: ユーザー名
AdminRecentFile: 最近アップロードしたファイル
AdminArticlePreview: プレビュー
#admin/articleAddError.hamlet
ArticleAddErrorTitle: エラーです。以下のフォームを正しく入力してください。
#inline/tag.hamlet
TaggedArticlePageTitle: とタグ付けされた記事
TaggedArticleTitle: タイトル
TaggedArticlePosted: 投稿時間
#inline/sidebar.hamlet
SearchPlaceHolder: 検索
#archive.hamlet
ArchiveTitle: タイトル
ArchivePosted: 投稿時間
#home.hamlet
HomeH1: ホーム
HomeMessage: ここはホームページです。メインコンテンツ:
#view.hamlet
Article: 記事
NoArticle: 記事はありません
Permalink: パーマリンク
Comment: コメント
#permalink.hamlet/article.hamlet
ArticleNoComment: コメントはありません
AddComment: コメントする
ArticleCommentPostButton: コメントを投稿
MustBeLoggedIn: コメントするにはログインする必要があります。
BackToRecentPost: 最近の投稿に戻る
#user-setting.hamlet
UpdateUserSetting: ユーザー設定
UpdateScreenName: 表示名を更新
UpdateUserInfo: ユーザー情報を更新
SwitchLanguage: 言語を切り替える
Switch: 切り替え
BackHome: ホームに戻る
GoBlog: ブログへ進む
#search.hamlet
SearchResult: 検索結果
ArticleSearchTitle: タイトル
ArticleSearchPosted: 投稿時間