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
