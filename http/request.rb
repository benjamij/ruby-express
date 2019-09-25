class Request
    attr_reader :header, :route, :params, :body
 
    def initialize(socket)
        @header, @route, @params = parse_header(socket)
        if has_body() then
            @body = parse_body(socket, header)
        end
    end

    private
    def parse_header(socket)
        header, params, route = {}, {}, ""
        while line = socket.gets
            if is_method_field(line) then
                uri = line.split(' ')
                header['method'] = uri[0]
                params = parse_params(uri)
                route = "#{uri[0]} #{uri[1].to_s.split('?')[0]}"
                next
            end 
            key, value = line.split(":")
            header[key.downcase] = value.to_s.strip!
            if line == "\r\n" then
                return header, route
            end
        end
        return header, route, params
    end

    private
    def parse_body(socket, header)
        socket.gets.split("\r\n")[0]
    end

    private
    def has_body()
        return @header['method'] == "POST" || @header['method'] == "PUT" || @header['method'] == "UPDATE"
    end

    private
    def parse_params(uri)
        params = {}
        if !uri.include? '?' then
            return params
        end
        param_str = uri[1].split('?')[1]
        for param in param_str.split('&')
            key, value = param.split('=')
            params[key] = value
        end
        params
    end

    private def is_method_field(line)
        line.to_s.start_with?("POST") || 
            line.start_with?("GET") ||
            line.start_with?("DELETE") ||
            line.start_with?("PATCH") ||
            line.start_with?("OPTIONS") ||
            line.start_with?("CONNECT") ||
            line.start_with?("HEAD")
    end
end
