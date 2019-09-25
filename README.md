# RubyExpress
RubyExpress is a minimal and flexible Ruby sample web application framework that provides a set of basic features for developing web applications.

# Why?
Just for fun. A little toy project that I use to teach myself and explore Ruby.

# How to use it?
It's quite easy really (it mimicks ExpressJS):

```
require_relative 'app'

app = App.new(8080)

app.get('/api/v1/test', lambda { |ctx|
    ctx.send("Test route reached")
})

app.post('/api/v1/test', lambda { |ctx|
    body = ctx.request.body
    ctx.send("Test POST route reached. This is your body #{body}")
})

app.post('/api/v1/denied',
    lambda { |ctx|
        body = ctx.request.body
        ctx.send("Test POST route reached. This is your body #{body}")
    },
    lambda { |ctx|
        puts "My permissions check does something here!"
        return false
    }
)

app.run()

```
