$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'rhail'

Gem::Specification.new do |s|
  s.name        = 'rhail'
  s.version     = '0.0.1'
  s.date        = '2017-02-12'
  s.summary     = "Bunch of generators and functions to make you up and running fast in Rack web-app."

  s.description = <<-EOF

|````\\     |    ||
|____//     |____||
|    \\     |    ||
|     \\uby |    ||ail

Ruby Hail is fast-by-design Rack-based nano-framework.
It provides generator and helper to quickly create Rack-based web-apps.

You have options to make plain html-based app with basic templates. You can chain htmls and utilize ruby string interpolation.

You can generate simple json API with authentication.

Or you can go with SPA (single-page app). It uses Vue.js for UI because it shares 
fast-by-design philosophy and very similar to AngularJS 1.

In all cases you have database (sqlite by default) available out of the box.

EOF

  s.authors     = ["Maksim Sundukov"]
  s.email       = 'max.sundukov@gmail.com'
  s.files       =  Dir['{bin/*.*,lib/**/*.*,generator_folders/**/*,generator_folders/**/.*,generator_folders/**/*.*}'] + %w(LICENSE rhail.gemspec README.md) # simplify for generator_folders
  s.bindir      = 'bin'
  s.executables << 'rhail'
  s.homepage    = 'https://github.com/E-Xor/rhail'
  s.license     = 'MIT'

  s.extra_rdoc_files = []
  s.rdoc_options += ['-m', 'README.md', '-x', '/generator_folders/.*|rhail.gemspec', '--title', 'Ruby Hail']

  s.post_install_message = Rhail::USAGE

  s.required_ruby_version = '~> 2.0' # Generated code was written and testend in ruby 2.3.0, however there's nothing specific to this ruby versions.
  s.add_dependency 'rack', '~> 2.0'
end
