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
  cid = cgi["cid"]
  sql = w_name + 'c' + id + ' set' # データベースのデータを更新するコマンドを生成

  db = SQLite3::Database.new("ue.db")
   # chara_editで削除ボタンが押されていたら用語を削除する
  dflag = cgi["delete"]
  if cgi["delete"].empty?
  else
    d = d_name + "c" + id + " WHERE cid = ?;" # データベースのデータを削除するコマンドを生成
    db.transaction() {db.execute(d, cid)} # キャラクターのデータを削除
    print <<-EOB
    <html><body>
    <p>キャラクターを削除しました</p>
    <form method='get' name='form1' action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara.rb">
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
    chara = cgi.params["chara"]
    if (/<.*>/ !~ chara[0]) == false
      raise "HTMLのタグは使用できません。"
    end
    ruby = cgi.params["ruby"]
    if (/<.*>/ !~ ruby[0]) == false
      raise "HTMLのタグは使用できません。"
    end
    age = cgi.params["age"]
    if (/<.*>/ !~ age.to_s) == false
      raise "HTMLのタグは使用できません。"
    end
    sex = cgi.params["sex"]
    if (/<.*>/ !~ sex[0]) == false
      raise "HTMLのタグは使用できません。"
    end
    height = cgi.params["height"]
    if (/<.*>/ !~ height.to_s) == false
      raise "HTMLのタグは使用できません。"
    end
    weight = cgi.params["weight"]
    if (/<.*>/ !~ weight.to_s) == false
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
  # chara_editで入力があった項目を更新
  if cgi["creator"].empty?
  else
    n = sql + ' creator = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["creator"], cid)}
  end
  if cgi["ruby"].empty?
  else
    n = sql + ' ruby = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["ruby"], cid)}
  end
  if cgi["age"].empty?
  else
    n = sql + ' age = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["age"], cid)}
  end
  if cgi["sex"].empty?
  else
    n = sql + ' sex = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["sex"], cid)}
  end
  if cgi["height"].empty?
  else
    n = sql + ' height = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["height"], cid)}
  end
  if cgi["weight"].empty?
  else
    n = sql + ' weight = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["weight"], cid)}
  end
  if cgi["content"].empty?
  else
    n = sql + ' content = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["content"], cid)}
  end
  if cgi["pass"].empty?
  else
    n = sql + ' pass = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["pass"], cid)}
  end
  if cgi["chara"].empty?
  else
    n = sql + ' chara = ? where cid = ?;'
    db.transaction() {db.execute(n, cgi["chara"], cid)}
  end
  db.close

  print <<-EOB
  <html><body>
  <p>キャラクターの情報を編集しました</p>
  <form method='get' name='form1' action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara_page.rb">
  <input type='hidden' name='cid' value=#{cid}>
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
