require "socket"

# You can use print statements as follows for debugging, they'll be visible when running tests.
print("Logs from your program will appear here!")

# Uncomment this to pass the first stage
#
server = TCPServer.new("localhost", 4221)
client_socket, client_address = server.accept
#client_socket.puts "HTTP/1.1 200 OK\r\n\r\n"

if client_socket.gets = "GET /index.html HTTP/1.1\r\nHost: localhost:4221\r\nUser-Agent: curl/7.64.1\r\nAccept: */*\r\n\r\n"
client_socket.puts "HTTP/1.1 200 OK\r\n\r\n"
else 
  client_socket.puts "HTTP/1.1 404 Not Found\r\n\r\n"
end
