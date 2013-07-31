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

when you use __Debian and related distributions...__

Install dependent libraries

```bash
$ git clone https://github.com/cosmo0920/Ahblog.git
$ cd Ahblog
$ cabal update
$ cabal install happy [or $ sudo apt-get install happy]
$ cabal install cabal-dev
$ ~/.cabal/bin/cabal-dev install --dry-run --only-dependencies #prevent dependency hell
$ ~/.cabal/bin/cabal-dev install --only-dependencies
```

build application

```bash
$ ~/.cabal/bin/cabal-dev configure
$ ~/.cabal/bin/cabal-dev build
```

or

```bash
$ ~/.cabal/bin/cabal-dev install yesod-bin
$ ~/.cabal/bin/cabal-dev --dev devel
```

* * * *

ライセンスはMITライセンスとします。

The MIT License (MIT)

Copyright (c) 2013 cosmo0920

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
