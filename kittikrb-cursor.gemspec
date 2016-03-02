# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kittikrb/cursor/version'

Gem::Specification.new do |spec|
  spec.name          = 'kittikrb-cursor'
  spec.version       = KittikRb::Cursor::VERSION
  spec.date          = Date.today.to_s
  spec.authors       = ['Vladyslav Siriniok']
  spec.email         = ['siriniok@gmail.com']
  spec.license       = 'MIT'
  spec.summary       = %q{ Low-level API for cursor in terminal.' }
  spec.description   = %q{ Implements low-level API for access to cursor in
    terminal.' }
  spec.homepage      = 'https://github.com/kittikjs/cursor'
  spec.required_ruby_version = '~> 2.2'
  spec.required_rubygems_version = '~> 2.2'

  spec.files         = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test|spec|features|examples)/})
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4'
  spec.add_development_dependency 'pry-byebug', '~> 3.3'
  spec.add_development_dependency 'awesome_print', '~> 1.6'
end
