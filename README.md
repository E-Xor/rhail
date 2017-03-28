# Ruby Hail

## About

Ruby Hail is Rack-based nano framework. It's the fastest-by-design Rack-based framework. It requires less learning (besides Rack, you suppose to know it by this time) than any other framework. It works great for simple dynamic web-sites, single-page web-apps and microservices.

[Official website](http://www.rubyhail.org)

## Why

[Watch video with the story](https://www.youtube.com/watch?v=hKzYhoo68os)

I was looking for balance between simplicity and development speed. If you go bellow Rack it's a lot of extra work for simple things. If you put a lot of abstractions on top of Rack then you loose track of what's going on under the hood and with high probability slowing things down.

I believe in right tool for the right job. If you look for fully-featured framework you might need Rails, something simpler - Sinatra, static site - Jekyll, blog - Wordpress. When you need simple web app or API that can do just couple of things really fast and easy - go Ruby Hail.

It was born when I was looking for web frameworks for Go and people advocated to not to use any except for the very basic ones. Otherwise you can't get the performance you're aiming for. So I took this concept to my favorite language - Ruby. I wanted to use as bare metal approach much as possible and to implement only the most necessary things so everyone can solve one task per app with high efficiency.

## Use

[Watch video with examples](https://www.youtube.com/watch?v=b2qNVZHlAwU)

### Regular install

```
gem install rhail
```

### More secure install

```
gem cert --add <(curl -Ls https://raw.github.com/E-Xor/rhail/master/certs/rhail-public-cert.pem)
gem install rhail -P MediumSecurity
```

### The rest of installation process
```
rhail generate <plain|json|spa> path/to/folder # it will create directory with app structure
cd path/to/folder
# Install ruby via rvm if needed
gem install bundler
bundle install
bundle exec rackup # Go to http://127.0.0.1:9292 or wherever output tells you.
```

To run it in production treat it as any other Rack-based (Rails or Sinatra) app. For example Passenger should be ponted to `<the folder>/public`.

Enjoy!

## Generators

### Plain

[Watch video with detailed explanation](https://www.youtube.com/watch?v=BrtrmFLrK-8)

```
rhail generate plain path/to/folder
```

Traditional server-side-based web-app, with example of (relatively secured) form, database and very simple html templating. You can chain htmls and utilize ruby string interpolation.

### JSON

```
rhail generate json path/to/folder
```

JSON Web-API with authentication.

#### Play with it

```
curl -i -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://127.0.0.1:9292/
curl -i -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://127.0.0.1:9292/example_one
curl -i -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' -H "Content-Type: application/json" -X POST -d '{"city":"asd","state":"asd","zipcode":"123","name":"asd"}' http://127.0.0.1:9292/example_two
```

### SPA

```
rhail generate spa path/to/folder
```

Single-page app based on Ruby Hail with VueJS. VueJS has a lot of similarities to AngularJS 1, minus performance issues.

## Custom code

Once you play with automatically generated code you will want to extend it with your real functionality.

```
RhailHelper.render_json(response_structure: {}, headers: {}
RhailHelper.render_html files: %w(head body foot), local_vars: {}, headers: {}
```

## Benchmarks

[In another repo](https://github.com/E-Xor/rhail-benchmark "Ruby Hail Benchmark")
