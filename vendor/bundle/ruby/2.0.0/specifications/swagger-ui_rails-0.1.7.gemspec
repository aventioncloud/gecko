# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "swagger-ui_rails"
  s.version = "0.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stjepan Hadjic"]
  s.date = "2014-02-08"
  s.description = "A gem to add swagger-ui to rails asset pipeline"
  s.email = ["Stjepan.hadjic@infinum.hr"]
  s.homepage = "https://github.com/d4be4st/swagger-ui_rails"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Add swagger-ui to your rails app easily"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
