require "socket"

print("Logs from your program will appear here!")


server = TCPServer.new("localhost", 4221)


loop do

    Thread.start(server.accept) do |client_socket|
    request = client_socket.gets
    method, path, version = request.split

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

    elsif path.start_with? '/files' 
      directory = ARGV[1]
      filename = path.split('/').last.strip
      full_path = "#{directory}/#{filename}"
      if File.exist?(full_path)
        file = File.open(full_path, "r")
        file_content = file.read
        client.puts("HTTP/1.1 200 OK\r\nContent-Type: application/octet-stream\r\nContent-Length: #{file_content.length}\r\n\r\n#{file_content}")
      else
        client.puts("HTTP/1.1 404 Not Found\r\n\r\n")
      end    
    else
      client_socket.puts "HTTP/1.1 404 Not Found\r\n\r\n"

    end 
    client.close

  end

end


