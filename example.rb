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
