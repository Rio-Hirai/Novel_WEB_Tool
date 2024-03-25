#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require "sqlite3"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)
choices = Array.new
word = Array.new
cnt = 0;
sql = ""
urlw = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/words.rb' # 用語一覧ページへのリンク
urle = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/words_edit.rb' # 用語編集ページへのリンク

print cgi.header("text/html; charset=utf-8")

begin
  wid = cgi["wid"]
  # セッション情報を格納
  id = session["id"]
  name = session["name"]
  db = SQLite3::Database.new("ue.db")
  db.transaction() {
    w_name = "w" + id # テーブル名を生成
    sql = "SELECT * FROM " + w_name + " WHERE wid = ?" # データベースを検索するためのコマンドを生成
    word = db.execute(sql, wid) # 検索したデータベースの情報を格納
  }
  db.close

  print <<EOB
  <html>
  <head><title>#{name}の用語：#{word[0][2]}</title></head>
  <body>
  <h1>#{word[0][2]} (#{word[0][3]})</h1>
  <h3><p style="text-align: right">作成者 #{word[0][1]}</p></h3>
  <hr><h3>
  <p>#{word[0][4].gsub(/\n/, '</br>')}</p><!-- 正規表現によって改行文字「\n」を「</br>」に置換する -->
  </h3>
  <form method='get' name='form3' action=#{urle}>
  <input type='hidden' name='wid' value=#{word[0][0]}>
  <a href='javascript:form3.submit()'>内容を編集する</a>
  </form>
  <form method='get' name='form4' action=#{urlw}>
  <a href='javascript:form4.submit()'>戻る</a>
  </form>
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
