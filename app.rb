# -- coding: utf-8

require "json"
require "net/http"
require "rubygems"
require "bundler/setup"
Bundler.require

use Rack::Parser, :content_types => {
  "application/json" => proc {|body| JSON.parse(body) }
}

BRIDGE = JSON.parse(IO.read("bridge.json"))

set :port, BRIDGE["rack_port"]

get "/" do
  erb :index
end

get "/control" do
  erb :control
end

get "/widget" do
   "hello"
end

post "/control" do
  Net::HTTP.start('10.1.10.11', BRIDGE["node_port"]) do |http|
    http.post("/", "triumph=false");
  end
  headers "Location" => "http://10.1.10.11:#{BRIDGE["rack_port"]}/control"
  status 302
end


__END__
@@ layout
<!DOCTYPE html> 
<html> 
<head> 
<title></title> 
<script src="http://10.1.10.11:1865/js/jquery-2.0.3.min.js" type="text/javascript" charset="utf-8"></script>
</head> 
<body><%= yield %></body></html> 

@@ index
<div id="received"></div>
<script src="http://10.1.10.11:<%= BRIDGE["stream_port"] %>/socket.io/socket.io.js"></script>
<script>
  var socket = io.connect('http://10.1.10.11:<%= BRIDGE["stream_port"] %>');
  var board = document.querySelector('#received');
  socket.on('news', function (data) {
    board.innerHTML = data.message;
  });
  socket.on('test', function (data) {
    $("#as_widget_sidebar").load("http://10.1.10.11:1865/weather");
  });
</script>

@@ control
<form action="/control" method="post">
post to Sinatra:
  <input type="submit" value="make it fail" />
</form>

websocket emit to Node:
<input type="button" id="huge_success" value="HUGE SUCCESS" />
<input type="button" id="sidebar_load" value="test" />

<pre id="received"></pre>
<script src="http://10.1.10.11:<%= BRIDGE["stream_port"] %>/socket.io/socket.io.js"></script>
<script>
  var socket = io.connect('http://10.1.10.11:<%= BRIDGE["stream_port"] %>');
  document.querySelector('#huge_success').addEventListener('click', function(){
    socket.emit('huge success');
  });
  document.querySelector('#sidebar_load').addEventListener('click', function(){
    socket.emit('sidebar');
  });
</script>
