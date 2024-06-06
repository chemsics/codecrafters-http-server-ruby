require "socket"

print("Logs from your program will appear here!")


server = TCPServer.new("localhost", 4221)


loop do

    Thread.start(server.accept) do |client_socket|
    request = client_socket.gets
    method, path, version = request.split
    socket = server.accept

    if path.start_with? '/user-agent'
      client_socket.gets
      agent = client_socket.gets.split("User-Agent: ").last.strip
      puts agent
      client_socket.send "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{agent.length}\r\n\r\n#{agent}", 0

    elsif path.start_with? '/echo/'
      content = path.split('/echo/').last
      client_socket.send "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{content.length}\r\n\r\n#{content}", 0

    elsif path == '/'
      client_socket.send "HTTP/1.1 200 OK\r\n\r\n", 0

    elsif path.start_with? '/files/' 
      directory = ARGV[1] 
      filename = path.split('/files/').last
      begin
        content = File.read "#{directory}#{filename}"
        client_socket.send "HTTP/1.1 200 OK\r\nContent-Type: application/octet-stream\r\nContent-Length: #{content.length}\r\n\r\n#{content}",
                           0
      rescue Errno::ENOENT
        client_socket.send "HTTP/1.1 404 Not Found\r\n\r\n", 0
      end

    else
      client_socket.puts "HTTP/1.1 404 Not Found\r\n\r\n"

    end 
    client.close

  end

end


