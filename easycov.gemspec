# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: easycov 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "easycov"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chetan Sarva"]
  s.date = "2013-09-18"
  s.description = "An easy to use, simplecov-compatibile code coverage library for Ruby"
  s.email = "chetan@pixelcop.net"
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "Rakefile",
    "VERSION",
    "easycov.gemspec",
    "lib/easycov.rb",
    "lib/easycov/filters.rb"
  ]
  s.homepage = "http://github.com/chetan/easycov"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.0"
  s.summary = "Ruby code coverage library"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<simplecov>, [">= 0"])
      s.add_runtime_dependency(%q<multi_json>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<minitest>, ["~> 4.0"])
    else
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<multi_json>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<bundler>, ["~> 1.1"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<minitest>, ["~> 4.0"])
    end
  else
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<multi_json>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<bundler>, ["~> 1.1"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<minitest>, ["~> 4.0"])
  end
end

