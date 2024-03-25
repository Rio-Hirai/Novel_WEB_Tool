#!/usr/bin/env ruby
# encoding: utf-8
require "cgi"
require 'cgi/session'
cgi = CGI.new
session = CGI::Session.new(cgi)

print cgi.header("text/html; charset=utf-8")

begin
  print <<EOB
  <html><body>
  <h1>新しい世界をつくる</h1>
  <h2>
  <form action="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/world_create2.rb" method="get">
  <p>名前<input type="text" name="wname"></p>
  <p>作成者<input type="text" name="creator"></p>
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
