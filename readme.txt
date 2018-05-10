server is a minimalist low level server written in Ruby v2.4.1. It is based on this tutorial:

https://practicingruby.com/articles/implementing-an-http-file-servera

That tutorial runs out steam real fast though. I referenced this tutorial kind of often as well

https://code.likeagirl.io/socket-programming-in-ruby-f714131336fd

I undertook this project in order to learn more about networking. The only true goal of this project is to serve a file from one computer on a local area network, to another computer on that same local area network. The picture I chose is the "speechless.png" picture because it was smallish, quickly available, and it's my favorite picture on the internet.

Instead of using classic ruby coding sugar, like the shovel operator

```
ary = [1,2,3]
ary << 4
puts ary.to_s
#=> [1,2,3,4]
```

I tried to use more explicit method calls that I think would be recognized by people who are less familiar with ruby.

```
ary = [1,2,3]
ary.push(4)
puts ary.to_s
#=> [1,2,3,4]
```

Ruby is full of idiomatic little shortcuts like this, they make coding fun, allowing the programmer to insert little flourishes, but raise questions in people unfamiliar with ruby.
