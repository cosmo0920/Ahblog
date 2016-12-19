Ahblog
======

**Notice:** Authorized as admin feature is effectively working with `Yesod.Auth.GoogleEmail2`.

[![Build Status](https://travis-ci.org/cosmo0920/Ahblog.svg?branch=master)](https://travis-ci.org/cosmo0920/Ahblog)

The source code for my internal web app which is powered by the Yesod framework, written in haskell.

Simple responsive design web app using twitter bootstrap v3.1.x. Markdown-driven, comments, post administration and search articles/titles.

More information, please see Japanese manual: [説明書](doc/ja.md)

## Try it

If you try this application, __strongly recommended__ to use [stack](https://github.com/commercialhaskell/stack).

### git clone and prepare git submodule

```bash
$ git clone https://github.com/cosmo0920/Ahblog.git
$ cd Ahblog
$ git submodule update --init --recursive
$ cd static/css && cp ../../bootstrap-select/bootstrap-select.min.css .
$ cd ../js && cp ../../bootstrap-select/bootstrap-select.min.js .
$ cd ../../
```

### Install dependent libraries and build application with stack

```bash
$ cp config/settings-dummy.yml config/settings.yml
$ stack build
$ stack exec Ahblog Development --port 3000
```

* * * *

This code is provided under the MIT LICENSE. see: [LICENSE](LICENSE)
