require "socket"

print("Logs from your program will appear here!")


server = TCPServer.new("localhost", 4221)


loop do

    Thread.start(server.accept) do |client_socket|
    request = client_socket.gets
    method, path, version = request.split(" ")

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

    elsif method == 'GET' 
        directory = ARGV[1]
        filename = path.split('/').last.strip
        full_path = "#{directory}/#{filename}"
        if File.exist?(full_path)
          file = File.open(full_path, "r")
          file_content = file.read
          client_socket.puts("HTTP/1.1 200 OK\r\nContent-Type: application/octet-stream\r\nContent-Length: #{file_content.length}\r\n\r\n#{file_content}")

        else
          client_socket.puts("HTTP/1.1 404 Not Found\r\n\r\n")
        end    

    elsif method == 'POST'
       headers = {}
             while line = client_socket.gets
        break if line == "\r\n"
        
        parts = line.split(': ', 2)
        if parts.length == 2
          headers[parts[0]] = parts[1].strip
        end
      end
      content_length = headers["Content-Length"].to_i
      body = client_socket.read(content_length)
      directory = ARGV[1]
      filename = path.split('/').last.strip
      full_path = "#{directory}/#{filename}"
      File.open(full_path, "w") do |file|
        file.write(body)
      end
      client_socket.puts("HTTP/1.1 201 Created\r\n\r\n")

    else
      client_socket.puts "HTTP/1.1 404 Not Found\r\n\r\n"

    end 
    client_socket.close

  end

end


