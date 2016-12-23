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

### Prepare Google Login

This application uses GoogleEmail2 Yesod authentication plugin.
So, he/she wants to use this application try the following procedure to get client id and client secret for Google Login system:

> In order to use this plugin:

>    Create an application on the Google Developer Console https://console.developers.google.com/
>    Create OAuth credentials. The redirect URI will be http://yourdomain/auth/page/googleemail2/complete. (If you have your authentication subsite at a different root than /auth/, please adjust accordingly.)
>    Enable the Google+ API.

ref: https://hackage.haskell.org/package/yesod-auth-1.4.15/docs/Yesod-Auth-GoogleEmail2.html#g:2

And then fill the following variables in `.env`.
(Please replace `YOUR_CLIENT_ID` and `YOUR_CLIENT_SECRET` with your obtained client id and secret and save as `.env`):

```bash
GOOGLE_LOGIN_CLIENT_ID=YOUR_CLIENT_ID
GOOGLE_LOGIN_CLIENT_SECRET=YOUR_CLIENT_SECRET
```

### Install dependent libraries and build application with stack

```bash
$ cp config/settings-dummy.yml config/settings.yml
$ stack build
$ stack exec Ahblog Development -- --port 3000
```

* * * *

This code is provided under the MIT LICENSE. see: [LICENSE](LICENSE)
