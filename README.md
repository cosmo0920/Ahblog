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
