# BIHMA server

## Summary
BIHMA server is a minimalist file server written in Ruby v2.4.1. It is based on this tutorial:

https://practicingruby.com/articles/implementing-an-http-file-servera


## What is does
BIHMA server listens on port 9001 for an HTTP request. When a request comes in, BIHMA server creates a new thread so it can continue receiving requests. Requests that aren't gotten in 10 seconds time out to prevent threads from persisting.

The path is extracted from the request and stored in a payload called package. Package is passed to several functions which add components of the response to package.

If the path is a directory, BIHMA server automatically generates an HTML page called "index" with a list of downloadable files within that directory. The elements are click to download.

Other users on the same network as BIHMA server can send a request to the IP address of the host with the port number.

## Features

### Multiple Threads
Whenever BIHMA server receives a request it creates a new thread. It does this so it can receive a new request before a previous one has finished resolving.

### Custom Paths

BIHMA server defaults to an included folder called "samples" but users can pass a directory string to BIHMA server when running BIHMA from the command line.

```
ruby server.rb ~/Pictures
```

or

```
ruby server.rb /Pictures
```

either will work, serving the directory found in the users home directory. If the directory doesn't exist in the user's home directory, BIHMA server throws an error.


### Dynamically generated HTML
Sort of. It's not exactly ruby on rails, but there are no html documents in BIHMA server. Instead there is a function which returns a string containing a HTML code with a helper function that will list all files in the directory.

### Color Coded Feedback
BIHMA server automatically sends a message to STDOUT to indicate that it has established a connection, received a get request, sent a response, and closed the connection. It also informs the user of any exceptions that were thrown without crashing the server.

feedback lines are structures as follows:

The four digit thread id of the current thread, followed by a slash, the number of active threads, followed by a colon, and then the message.

```
0004/2: opening socket connection with client from 192.168.1.170
0004/2: received request line:
0004/2: GET / HTTP/1.1
	Host: 192.168.1.170:9001
	User-Agent: curl/7.54.0
	Accept: */*
0004/2: responded with:
0004/2: HTTP/1.1 200 OK
	Content-Type: text/html
	Content-Length: 443
	Connection: close
0004/2: closing socket connection with client
```

Users can pass -feedback at runtime to get more information.
```
0002/2: _____________________________________
0002/2: opening socket connection with client from 192.168.1.170
0002/2: preparing to receive request line...
0002/2: received request line:
0002/2: GET / HTTP/1.1
	Host: 192.168.1.170:9001
	User-Agent: curl/7.54.0
	Accept: */*
0002/2: rendering response...
0002/2: response body rendered
0002/2: rendering response header...
0002/2: response header rendered
0002/2: sending response
0002/2: responded with:
0002/2: HTTP/1.1 200 OK
	Content-Type: text/html
	Content-Length: 443
	Connection: close
0002/2: closing socket connection with client
0002/2: _____________________________________
0002/2: *************************************
```
This feedback is color coded. Red text is an error, yellow text means the server has to do something, and green text means the server completed a task and is ready to move on to the next line.


## Notes

### Classes

For this project, I didn't write any ruby classes, electing for a more functional approach. Part of the reason I did this is because it was in line with the original tutorial that BIHMA server is based on. ( https://practicingruby.com/articles/implementing-an-http-file-servera ). But ultimately I decided that none of the functions were doing anything sophisticated enough to warrant an entire class. I did write one static class in order to handle options passed at run time. I only did this because I didn't want anybody thinking I was a ruby developer from another dimension who had no idea what classes are.  


### Motivation

I undertook this project in order to learn more about networking. The only true "goal" of this server is to serve files from one computer on a local area network to another computer on that same local area network. Basically from my desktop to my laptop. But my driving desire was to learn about sockets.

I didn't intend to learn about threading, but it proved to be necessary when I was receiving too many simultaneous requests from my browser. I use chrome, I had the same problem in firefox and safari. While I haven't solved that issue yet, the index.html will still load, and the files will still be downloadable. Just don't expect a favicon at this time.


The picture I chose for the sample is "speechless.png" because it was smallish, quickly available, and it's my favorite picture on the internet.

### Syntax

Instead of using classic ruby sugar, like the shovel operator

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

## Future Directions
BIHMA server currently only parses GET requests, not HEAD, which means BIHMA doesn't conform to spec. I would like the server to return HTML documents for file not found. I would like to incorporate mutex locking on data accessed by multiple threads. I would like files to include a preview button so the client doesn't need to download the file. In particular I would like videos to be streamable from the host computer. It doesn't make sense to transfer all 250 episodes of dragon ball z, most of them aren't worth the bandwidth.

Even though the server is functionally doing everything I want it to do, I'm dissatisfied with the problem with receiving multiple requests from browsers.
