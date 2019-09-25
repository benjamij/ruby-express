require 'socket'
require_relative 'http/context'
require_relative 'http/request'

class App
    def initialize(port)
        @server = TCPServer.new port
        @routes = {}
        puts "Server listening on #{port}"
    end

    def run()
        while socket = @server.accept
            puts "Incoming connection accepted."
            request = Request.new socket
            if @routes.key? request.route then
                Thread.new() {
                    @routes[request.route].call Context.new socket, request
                }
            else
                puts "#{request.route} not found"
            end
        end
    end

    def get(route, callback, permission_check=lambda{|ctx| true})
        set_route("GET", route, callback, permission_check)
    end

    def post(route, callback, permission_check=lambda{|ctx| true})
        set_route("POST", route, callback, permission_check)
    end

    private
    def set_route(method, route, callback, permission_check)
        @routes["#{method} #{route}"] = lambda {|ctx|
            permission_check.call ctx
            if permission_check.call ctx then
                callback.call ctx
            else
                ctx.send("Permission denied", code=400)
            end
        }
    end
end
