Ahblog
======

[![Build Status](https://travis-ci.org/cosmo0920/Ahblog.png?branch=master)](https://travis-ci.org/cosmo0920/Ahblog)

The source code for my internal web app which is powered by the Yesod framework, written in haskell.

Simple responsive design web app using twitter bootstrap. Markdown-driven, comments, post administration and search articles/titles.

More information, see Japanese manual: [説明書](doc/ja.md)

## Try it

If you install cabal packages, __strongly recommended__ use cabal-dev.

### git clone and prepare git submodule

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
$ cp config/settings-dummy.yml config/settings.yml
$ ~/.cabal/bin/cabal-dev configure
$ ~/.cabal/bin/cabal-dev build
```

or

```bash
$ cp config/settings-dummy.yml config/settings.yml
$ ~/.cabal/bin/cabal-dev install yesod-bin
$ ~/.cabal/bin/cabal-dev --dev devel
```

* * * *

This code is provided under the MIT LICENSE. see: [LICENSE file](LICENSE)
