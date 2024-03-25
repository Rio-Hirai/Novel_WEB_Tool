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
urlw = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/words.rb' # 用語一覧のリンク先
urlc = 'http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/chara.rb' # キャラクター一覧のリンク先
name = ""

print cgi.header("text/html; charset=utf-8")

begin
  if cgi["id"].empty?
  else # universe_editor.rbからidとnameが渡されたら、セッション情報を更新する
    name = cgi["name"]
    id = cgi["id"]
    session['name'] = name
    session['id'] = id
  end
  # セッション情報を読み込む
  name = session['name']
  id = session['id']
  print <<EOB
  <html>
  <head><title>#{name}</title></head>
  <body>
  <h1>#{name}</h1>
  <hr><h2><ul>
  <li><form method='get' name='form1' action=#{urlw}>
  <a href='javascript:form1[0].submit()'>用語</a>
  </form></li>
  <li><form method='get' name='form1' action=#{urlc}>
  <a href='javascript:form1[1].submit()'>キャラクター</a>
  </form></li>
  </ul></h2>
  <a href="http://cgi.u.tsukuba.ac.jp/~s1711466/local_only/wp/universe_editor.rb">戻る</a>
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
