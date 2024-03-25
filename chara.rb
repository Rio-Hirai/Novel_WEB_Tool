#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require "sqlite3"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)
choices = Array.new
world = Array.new
cnt = 0;
url = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara_page.rb' # 個別（詳細）ページへのリンク
urlc = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara_create.rb' # キャラクター追加ページへのリンク
urlw = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/world.rb' # 前ページへのリンク

print cgi.header("text/html; charset=utf-8")

begin
  # セッション情報を格納
  id = session["id"]
  name = session["name"]
  db = SQLite3::Database.new("ue.db")
  db.transaction() {
    c_name = "c" + id　# テーブル名を生成
    sql = "SELECT * FROM " + c_name　# テーブルのデータを読み込むためのコマンドを生成
    # 用語ごとに個別ページのリンクを生成
    db.execute(sql) {|line|
    choices.push("<li><form method='get' name='form1' action=#{url}><input type='hidden' name='cid' value=#{line[0]}><a href='javascript:form1[#{cnt}].submit()'>#{line[2]}</a></form></li>")
    cnt += 1
    }
  }
  db.close

  print <<EOB
  <html>
  <head><title>#{name}のキャラクター</title></head>
  <body>
  <h1>キャラクター一覧</h>
  <hr><h2><ul>
  #{choices.join("\n")}
  </ul></h2>
  <form method='get' name='form2' action=#{urlc}>
  <a href='javascript:form2.submit()'>新しいキャラクターを追加する</a>
  </form>
  <form method='get' name='form3' action=#{urlw}>
  <a href='javascript:form3.submit()'>戻る</a>
  </form>
  <hr>
  <a href="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/universe_editor.rb">ホーム画面に戻る</a>
  </body></html>
EOB
session.close
rescue => ex
  print <<-EOB
  <html><body>
  <p>#{ex.message}</p>
  <p>#{ex.backtrace}</p>
  </body></html>
  EOB
end
