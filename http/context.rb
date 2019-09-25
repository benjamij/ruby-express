require_relative 'http_writer'
class Context
    attr_reader :request
    def initialize(socket, request)
        @socket = socket
        @request = request
    end

    def send(data, code=200, content_type="text/plain")
        HttpWriter.write(@socket, data, code, content_type)
    end
end
