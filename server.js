var fs = require("fs");
var env = JSON.parse(fs.readFileSync("bridge.json").toString());
var io = require("socket.io").listen(env.stream_port, "0.0.0.0");
var http = require("http");
var server = http.createServer();
 


io.sockets.on('connection', function(sock) {
  console.log('new client connected');

  sock.on('disconnect', function(){
    console.log('disconnect');
  });

  sock.on('huge success', function(){
    msg = '<style type="text/css" media="screen"> .as_widget_sidebar { overflow: hidden; width:486px; height:805px; position: absolute; top: 138px; left: 1434px;  border: 1px solid #000; } </style><div id="as_widget_sidebar" class="as_widget_sidebar"></div>';
    io.sockets.emit('content', {message: msg});
  });
  
  sock.on('sidebar_style', function(){
    msg = '"width":"1920px","height":"805px","top":"0px","left":"0px"';
    io.sockets.emit('sidebar_style', {message: msg});
  });

  sock.on('sidebar_load', function(){
    msg = '';
    io.sockets.emit('sidebar_load', {message: msg});
  });
    
});

// setInterval(function(){
//   io.sockets.emit('content', {message: msg});
// }, 1000);
