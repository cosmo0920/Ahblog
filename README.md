Ahblog
======

Haskellしたいがために作った執筆者が主に一人の場合のブログエンジン。

* 一応管理者権限は複数人に与えらるようには作っています。 

```bash
mv config/settings-dummy.yml config/settings.yml
```
とし、adminsに管理者権限を与えたいメールアドレスの文字列を配列として指定します。

すると、指定したメールアドレスを使ったログイン後に
/blog/admin以下の認証がかかったURLへのアクセスができるようになります。

###yesodのパッケージの他以下のものを使用しています。依存関係に注意。

* yesod-paginator
* friendly-time
* yesod-newsfeed
* yesod-markdown 

###記事はHTMLまたはMarkdownで書くことができます。

<pre>
```haskell
imageFilePath :: String -> FilePath
imageFilePath f = uploadDirectory </> uploadSubDirectory </> f
```
</pre>
のようにコードを埋め込むこともできます。

コードを埋め込む方法はgoogle-code-prettifyも使ってるのでその形式でも埋め込むことができます。

また、Bootstrapを用いているので、codeタグも扱えます。

コメントにはMarkdownを許可していません、あしからず。

他、ファイルをアップロードできたり、RSSフィードをサポートしていたり、URLによる検索もサポートしていたりもします。

AboutページはMarkdownで記述でき、自由に差し替えられます。