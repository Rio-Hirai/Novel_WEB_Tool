#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require "sqlite3"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)
choices = Array.new
chara = Array.new
cnt = 0;
sql = ""
urlw = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara.rb' # キャラクター一覧ページへのリンク
urle = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara_edit.rb' # キャラクター編集ページへのリンク
ex = "<h1><p>akak</p></h1>"

print cgi.header("text/html; charset=utf-8")

begin
  cid = cgi["cid"]
  # セッション情報を格納
  id = session["id"]
  name = session["name"]
  db = SQLite3::Database.new("ue.db")
  db.transaction() {
    w_name = "c" + id # テーブル名を生成
    sql = "SELECT * FROM " + w_name + " WHERE cid = ?" # データベースを検索するためのコマンドを生成
    chara = db.execute(sql, cid) # 検索したデータベースの情報を格納
  }
  db.close

  print <<EOB
  <html>
  <head><title>#{name}のキャラクター：#{chara[0][1]}</title></head>
  <body>
  <h1>#{chara[0][2]} (#{chara[0][3]})</h1>
  <h3><p style="text-align: right">作成者 #{chara[0][1]}</p></h3>
  <hr><h4>
  <p>年齢：#{chara[0][4]}歳</p>
  <p>性別：#{chara[0][5]}</p>
  <p>身長：#{chara[0][6]}cm</p>
  <p>体重：#{chara[0][7]}kg</p>
  </h4>
  <h3>
  <br></br>
  <p>#{chara[0][8].gsub(/\n/, '</br>')}</p><!-- 正規表現によって改行文字「\n」を「</br>」に置換する -->
  </h3>
  <form method='get' name='form3' action=#{urle}>
  <input type='hidden' name='cid' value=#{chara[0][0]}>
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
