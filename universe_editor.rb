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
url = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/world.rb' # リンク先のURL

print cgi.header("text/html; charset=utf-8")

begin
  db = SQLite3::Database.new("ue.db")
  db.transaction() {
    # 登録されている世界を全て検索し、それのデータをworld.rbに渡すリンクを作成する
    db.execute("SELECT * FROM world;") {|line|
    pass = line[4] # パスワードを格納
    if pass.empty? # パスワードがないなら
      choices.push("<li><form method='get' name='form1' action=#{url}><input type='hidden' name='id' value=#{line[0]}><input type='hidden' name='name' value=#{line[1]}><a href='javascript:form1[#{cnt}].submit()'>#{line[1]}</a>   作成者：#{line[2]}</form></li>")
    else # パスワードがあるなら
      choices.push("<li><form method='get' name='form1' action=#{url} onclick='return gate(\"#{line[4]}\")'><input type='hidden' name='id' value=#{line[0]}><input type='hidden' name='name' value=#{line[1]}><a href='javascript:form1[#{cnt}].submit()'>#{line[1]}</a>   作成者：#{line[2]}</form></li>")
    end
    cnt += 1
    }
  }
  db.close

  print <<EOB
  <html>
  <head><title>ユニバース・エディタ</title></head>
  <body>
  <script type="text/javascript">
  // パスワード入力ウィンドウ
  function gate(pass){
    var UserInput = prompt("パスワードを入力して下さい:","");
    if(UserInput == pass) {return true;}
    if(UserInput == null) {return false;}
    alert("パスワードが違います");
    return false;
  }
  </script>
  <h1>世界一覧</h1>
  <hr><h2><ul>
  #{choices.join("\n")}
  </ul></h2>
  <a href="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/world_create.rb">新しい世界をつくる</a>
  </body>
  </html>
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
