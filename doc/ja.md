Haskellしたいがために作った執筆者が主に一人の場合のブログエンジン。

* 一応管理者権限は複数人に与えられるようには作っています。

最初に[README.md](../README.md)の[Try It](../README.md#try-it)手順を完了させておいてください。

config/settings./ymlのadminsに管理者権限を与えたいメールアドレスの文字列を
例えば、

```
admins: ["default@example.com"]
```

のようにして指定します。

すると、指定したメールアドレスを使ったログイン後に
/admin以下の認証がかかったURLへのアクセスができるようになります。

### yesodのパッケージの他以下のものを使用しています。依存関係に注意。

* yesod-paginator
* friendly-time
* yesod-newsfeed
* yesod-markdown

### 記事はHTMLまたはMarkdownで書くことができます。

```haskell
imageFilePath :: String -> FilePath
imageFilePath f = uploadDirectory </> uploadSubDirectory </> f
```

のようにコードを埋め込むこともできます。Github記法と同じです。

Blogのタイトルはyamlのtitle:に指定します。

コードを埋め込む方法はgoogle-code-prettifyも使ってるのでその形式でも埋め込むことができます。

また、Bootstrapを用いているので、codeタグも扱えます。

コメントにはMarkdownを許可していません、あしからず。

他、ファイルをアップロードできたり、RSSフィードをサポートしていたり、検索フォームによる検索もサポートしていたりもします。

AboutページはMarkdownで記述でき、自由に差し替えられます。

### Yesod.Testを用いた自動テストについて

このYesod製Webアプリの認証は外部サービスを用いているのでtests/以下のテストカバレッジは高くありません。
認証をしていないユーザーの行動に対するテストを中心に記述して有ります。
