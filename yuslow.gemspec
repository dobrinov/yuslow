Gem::Specification.new do |spec|
  spec.name        = 'yuslow'
  spec.version     = '0.0.2'
  spec.date        = '2021-01-24'
  spec.summary     = 'Lightweight profiler for Ruby'
  spec.description = 'Y U Slow gives you a simple way to break down and debug why specific piece of code is slow.'
  spec.authors     = ['Deyan Dobrinov']
  spec.email       = 'deyan.dobrinov@gmail.com'
  spec.files       = ["lib/yuslow.rb"]
  spec.homepage    = 'https://github.com/dobrinov/yuslow'
  spec.license     = 'MIT'

  spec.add_development_dependency 'rspec', "~> 3.10"
end
