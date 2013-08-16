Ahblog
======

[![Build Status](https://travis-ci.org/cosmo0920/Ahblog.png?branch=master)](https://travis-ci.org/cosmo0920/Ahblog)

Haskellしたいがために作った執筆者が主に一人の場合のブログエンジン。

* 一応管理者権限は複数人に与えられるようには作っています。

```bash
cp config/settings-dummy.yml config/settings.yml
```
とし、adminsに管理者権限を与えたいメールアドレスの文字列を例えばconfig/settings.yamlへ
admins: ["default@example.com"]
のようにして指定します。

すると、指定したメールアドレスを使ったログイン後に
/admin以下の認証がかかったURLへのアクセスができるようになります。

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

Blogのタイトルはyamlのtitle:に指定します。

コードを埋め込む方法はgoogle-code-prettifyも使ってるのでその形式でも埋め込むことができます。

また、Bootstrapを用いているので、codeタグも扱えます。

コメントにはMarkdownを許可していません、あしからず。

他、ファイルをアップロードできたり、RSSフィードをサポートしていたり、検索フォームによる検索もサポートしていたりもします。

AboutページはMarkdownで記述でき、自由に差し替えられます。

## Try it

If you install cabal packages, __strongly recommended__ use cabal-dev.

### prepare git submodule

```bash
$ git clone https://github.com/cosmo0920/Ahblog.git
$ cd Ahblog
$ git submodule update --init --recursive
$ cd static/css && cp ../../bootstrap-select/bootstrap-select.min.css .
$ cd ../js && cp ../../bootstrap-select/bootstrap-select.min.js .
$ cd ../../
```

### Install dependent libraries

when you use __Debian and related distributions...__

```bash
$ cabal update
$ cabal install happy [or $ sudo apt-get install happy]
$ cabal install cabal-dev
$ ~/.cabal/bin/cabal-dev install --dry-run --only-dependencies #prevent dependency hell
$ ~/.cabal/bin/cabal-dev install --only-dependencies
```

### build application

```bash
$ mv config/settings-dummy.yml config/settings.yml
$ ~/.cabal/bin/cabal-dev configure
$ ~/.cabal/bin/cabal-dev build
```

or

```bash
$ mv config/settings-dummy.yml config/settings.yml
$ ~/.cabal/bin/cabal-dev install yesod-bin
$ ~/.cabal/bin/cabal-dev --dev devel
```

* * * *

ライセンスはMITライセンスとします。see : [LICENSE file](LICENSE)
