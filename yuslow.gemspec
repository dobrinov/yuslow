lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'yuslow'
  spec.version     = '0.2.0'
  spec.date        = '2021-01-24'
  spec.summary     = 'Lightweight profiler for Ruby'
  spec.description = 'Y U Slow gives you a simple way to break down and debug why specific piece of code is slow.'
  spec.authors     = ['Deyan Dobrinov']
  spec.email       = 'deyan.dobrinov@gmail.com'
  spec.homepage    = 'https://github.com/dobrinov/yuslow'
  spec.license     = 'MIT'

  spec.files       = Dir['README.md', 'lib/**/*']

  spec.add_development_dependency 'rspec', "~> 3.10"
end
