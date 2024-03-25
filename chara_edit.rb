#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require "sqlite3"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)
pass = Array.new

print cgi.header("text/html; charset=utf-8")

begin
  # セッション情報を格納
  id = session["id"]
  name = session["name"]
  cid = cgi["cid"]
  passsen = "SELECT pass FROM " + "c" + id + " WHERE cid = ?;" # その用語に設けられたパスワードを検索するためのコマンドを生成
  db = SQLite3::Database.new("ue.db")
  db.transaction() {
     # パスワードを検索し、格納
    db.execute(passsen,cid) {|line|
      pass = line
    }
  }
  db.close
  print <<EOB
  <html>
  <head><title>キャラクター編集</title></head>
  <body>
  <script type="text/javascript">
  function gate(pass){
    var str = pass; // 引数にして取得したpassを格納
    // strの長さが0でない（＝パスワードがある）ならパスワード入力を要求する
    if(str.length != 0) {
      var UserInput = prompt("パスワードを入力して下さい:","");
      if(UserInput == pass) {return true;}
      if(UserInput == null) {return false;}
      alert("パスワードが違います");
      return false;
    }
  }
  </script>
  <h1>キャラクターを編集する</h1>
  <h2>
  <form action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara_edit2.rb" method="get" onSubmit="return gate('#{pass[0]}')">
  <p>作成者<input type="text" name="creator"></p>
  <p>キャラクター名<input type="text" name="chara"></p>
  <p>読み<input type="text" name="ruby"></p>
  <p>年齢<input type="text" name="age"> 歳</p>
  <p>性別<input type="text" name="sex"></p>
  <p>身長<input type="text" name="height"> cm</p>
  <p>体重<input type="text" name="weight"> kg</p>
  <p>概要<br><textarea name="content" cols="30" rows="5"></textarea></p>
  <p>pass<input type="text" name="pass"></p>
  </h2>
  <input type='hidden' name='cid' value=#{cid}>
  <input type="submit" value="変更">
  <input type="reset" value="クリア">
  <input type="submit" name='delete' value="削除">
  <input type="button" value="戻る" onclick="history.back()">
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
