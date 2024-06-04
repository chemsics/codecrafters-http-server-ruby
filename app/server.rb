require "socket"

# You can use print statements as follows for debugging, they'll be visible when running tests.
print("Logs from your program will appear here!")

# Uncomment this to pass the first stage
#
server = TCPServer.new("localhost", 4221)
#client_socket, client_address = server.accept
#client_socket.puts "HTTP/1.1 200 OK\r\n\r\n"

loop do
  client_socket, client_address = server.accept
  request = client_socket.gets
#method, path and version must be in this order
  method, path, version = request.split
  $body = path
  $length = "#$body".length - 6
  if path == "#$body"
    client_socket.puts "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #$length\r\n\r\n#$body"
  else
    client_socket.puts "HTTP/1.1 404 Not Found\r\n\r\n"
  end 
  client.close
end

