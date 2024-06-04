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
  content = path.split('/echo/').last
  puts content
  puts $body
  if path.start_with? '/echo/'
    client_socket.send "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content.length}\r\n\r\n#{content}", 0
  elsif path == '/'
    client_socket.send "HTTP/1.1 200 OK\r\n\r\n", 0
  else
    client_socket.puts "HTTP/1.1 404 Not Found\r\n\r\n"
  end 
  client.close
end

