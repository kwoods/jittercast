var fs = require("fs");
var env = JSON.parse(fs.readFileSync("bridge.json").toString());
var io = require("socket.io").listen(env.stream_port, "0.0.0.0");
var http = require("http");
var server = http.createServer();
 


var msg = "the cake is a lie!";

server.on('request', function(req, res){
  if(req.method == "POST" && req.url == "/") {
    msg = "the cake is a lie!";
  }
  res.writeHead(204);
  res.end();
}).listen(env.node_port, "0.0.0.0");

io.sockets.on('connection', function(sock) {
  console.log('new client connected');

  sock.on('disconnect', function(){
    console.log('disconnect');
  });

  sock.on('huge success', function(){
    msg = '<style type="text/css" media="screen"> .as_widget_sidebar { width:486px; height:805px; position: absolute; top: 138px; left: 1434px; background-color: purple; border: none; } </style><div id="as_widget_sidebar" class="as_widget_sidebar"></div>';
    io.sockets.emit('content', {message: msg});
  });
  
  sock.on('sidebar', function(){
    msg = '';
    io.sockets.emit('test', {message: msg});
  });
    
});

// setInterval(function(){
//   io.sockets.emit('content', {message: msg});
// }, 1000);
