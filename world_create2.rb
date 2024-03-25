#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require "sqlite3"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)
cnt = Array.new
w_name = ""
c_name = ""
sqlp = "CREATE TABLE "
sqlw = " (wid INTEGER PRIMARY KEY,creator TEXT NOT NULL,word TEXT NOT NULL,ruby TEXT NOT NULL,content TEXT NOT NULL,relation TEXT,pass TEXT);" # w○を作成するときのコマンドの一部
sqlc = " (cid INTEGER PRIMARY KEY,creator TEXT NOT NULL,chara TEXT NOT NULL,ruby TEXT NOT NULL,age INTEGER NOT NULL,sex TEXT NOT NULL,height INTEGER NOT NULL,weight INTEGER NOT NULL,content TEXT NOT NULL,relation TEXT,pass TEXT);" # c○を作成するときのコマンドの一部

print cgi.header("text/html; charset=utf-8")

begin
  db = SQLite3::Database.new("ue.db")
  db.transaction() {
    # 既に同名の世界があるか判定
    db.execute("SELECT name FROM world;") {|line|
      if line == cgi.params["wname"]
        print <<-EOB
        <html><body>
        <p>#{line[0]}という世界は既に存在します</p>
        <meta http-equiv="refresh" content="1;URL=http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/world_create.rb">
        EOB
        exit
      end
    }
  }
    creator = cgi.params["creator"]
    wname = cgi.params["wname"]
    summary = 'test'
    pass = cgi.params["pass"]
    # 入力漏れがあるか確認
    if creator[0].empty? or wname[0].empty? # パスワードは任意なので見ない
      raise "入力漏れがあります"
    end
    # データベースの処理
    db.transaction() {
      db.execute("INSERT INTO world(name,creator,summary,pass) VALUES(?,?,?,?)", wname,creator,summary,pass) # worldテーブルにデータを追加
      cnt = db.execute("SELECT * FROM world WHERE name = ?;", cgi.params["wname"]) # 追加したデータ（の自動生成されたid）を取得
      w_name = sqlp + "w" + cnt[0][0].to_s + sqlw # w○テーブルを作成するためのコマンドを生成
      c_name = sqlp + "c" + cnt[0][0].to_s + sqlc # c○テーブルを作成するためのコマンドを生成
      db.execute(w_name) # w○テーブルを作成
      db.execute(c_name) # c○テーブルを作成
    }
  db.close

  print <<-EOB
  <html><body>
  <p>新しい世界を作成しました</p>
  <p><a href="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/universe_editor.rb">戻る</a></p>
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
