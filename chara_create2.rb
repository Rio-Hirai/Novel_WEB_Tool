#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require "sqlite3"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)
cnt = Array.new
c_name = "INSERT INTO " # データベースにデータを追加するためのコマンドの一部
s_name = "SELECT chara FROM " # データベースを検索するためのコマンドの一部

print cgi.header("text/html; charset=utf-8")


begin
  # セッション情報を格納
  id = session["id"]
  name = session["name"]
  sql = c_name + 'c' + id + ' (creator,chara,ruby,age,sex,height,weight,content,relation,pass) VALUES(?,?,?,?,?,?,?,?,?,?)' # データベースにデータを追加するためのコマンドを生成
  db = SQLite3::Database.new("ue.db")
  db.transaction() {
    selectname = s_name + "c" + id + ";" # データベースを検索するためのコマンドを生成
    # 既に同名のキャラクターがあるか判定
    db.execute(selectname) {|line|
      if line == cgi.params["chara"]
        print <<-EOB
        <html><body>
        <p>#{name}には「#{line[0]}」というキャラクターが既に存在します</p>
        EOB
        exit
      end
    }
  }
   # 正規表現でHTMLタグが使用されているか判定
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
    db.transaction() {
      db.execute(sql, creator,chara,ruby,age,sex,height,weight,content,relation,pass) # c○テーブルにデータを追加
    }
  db.close

  print <<-EOB
  <html><body>
  <p>新しいキャラクターを追加しました</p>
  <form method='get' name='form1' action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara.rb">
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
