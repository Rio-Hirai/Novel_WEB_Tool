#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require "sqlite3"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)
cnt = Array.new
w_name = "update " # データベースのデータを更新するコマンドの一部
d_name = "DELETE FROM " # データベースのデータを削除するコマンドの一部

print cgi.header("text/html; charset=utf-8")

begin
  # セッション情報を格納
  id = session["id"]
  name = session["name"]
  wid = cgi["wid"]
  sql = w_name + 'w' + id + ' set' # データベースのデータを更新するコマンドを生成

  db = SQLite3::Database.new("ue.db")
   # words_editで削除ボタンが押されていたら用語を削除する
  dflag = cgi["delete"]
  if cgi["delete"].empty?
  else
    d = d_name + "w" + id + " WHERE wid = ?;" # データベースのデータを削除するコマンドを生成
    db.transaction() {db.execute(d, wid)} # 用語のデータを削除
    print <<-EOB
    <html><body>
    <p>用語を削除しました</p>
    <form method='get' name='form1' action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/words.rb">
    <a href='javascript:form1.submit()'>戻る</a>
    </body></html>
    EOB
    db.close
    exit
  end
   # 正規表現でHTMLのタグが使用されているか判定
    creator = cgi.params["creator"]
    if (/<.*>/ !~ creator[0]) == false
      raise "HTMLのタグは使用できません。"
    end
    word = cgi.params["word"]
    if (/<.*>/ !~ word[0]) == false
      raise "HTMLのタグは使用できません。"
    end
    ruby = cgi.params["ruby"]
    if (/<.*>/ !~ ruby[0]) == false
      raise "HTMLのタグは使用できません。"
    end
    content = cgi.params["content"]
    if (/<.*>/ !~ content[0]) == false
      raise "HTMLのタグは使用できません。"
    end
    relation = ''
    pass = cgi.params["pass"]
    if (/<.*>/ !~ pass[0]) == false
      raise "HTMLのタグは使用できません。"
    end
  # words_editで入力があった項目を更新
  if cgi["creator"].empty?
  else
    n = sql + ' creator = ? where wid = ?;'
    db.transaction() {db.execute(n, cgi["creator"], wid)}
  end
  if cgi["ruby"].empty?
  else
    n = sql + ' ruby = ? where wid = ?;'
    db.transaction() {db.execute(n, cgi["ruby"], wid)}
  end
  if cgi["content"].empty?
  else
    n = sql + ' content = ? where wid = ?;'
    db.transaction() {db.execute(n, cgi["content"], wid)}
  end
  if cgi["pass"].empty?
  else
    n = sql + ' pass = ? where wid = ?;'
    db.transaction() {db.execute(n, cgi["pass"], wid)}
  end
  if cgi["word"].empty?
  else
    n = sql + ' word = ? where wid = ?;'
    db.transaction() {db.execute(n, cgi["word"], wid)}
  end
  db.close

  print <<-EOB
  <html><body>
  <p>用語の情報を編集しました</p>
  <form method='get' name='form1' action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/words_page.rb">
  <input type='hidden' name='wid' value=#{wid}>
  <a href='javascript:form1.submit()'>戻る</a>
  </body></html>
  EOB
  session.close
rescue => ex
  print <<-EOB
  <html><body>
  <pre>#{ex.message}</pre>
  <pre>#{ex.backtrace}</pre>
  EOB
end
