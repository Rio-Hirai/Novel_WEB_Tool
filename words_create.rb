#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)

print cgi.header("text/html; charset=utf-8")


begin
  # セッション情報を格納
  id = session["id"]
  name = session["name"]
  print <<EOB
  <html><head><title>用語追加</title></head>
  <body>
  <h1>新しい用語を追加する</h>
  <h2>
  <form action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/words_create2.rb" method="get">
  <p>作成者<input type="text" name="creator"></p>
  <p>項目名<input type="text" name="word"></p>
  <p>読み<input type="text" name="ruby"></p>
  <p>概要<br><textarea name="content" cols="30" rows="5"></textarea></p>
  <p>pass<input type="text" name="pass"></p>
  </h2>
  <input type="submit" value="作成">
  <input type="reset" value="クリア">
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
