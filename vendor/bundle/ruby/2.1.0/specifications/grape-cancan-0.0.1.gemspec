# -*- encoding: utf-8 -*-
# stub: grape-cancan 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "grape-cancan"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ray Zane"]
  s.date = "2014-12-29"
  s.description = "Authorize your Grape API with CanCan"
  s.email = ["raymondzane@gmail.com"]
  s.homepage = "https://github.com/rzane/grape-cancan"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.5"
  s.summary = "Authorize your Grape API with CanCan"

  s.installed_by_version = "2.2.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<grape>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<cancancan>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<grape>, [">= 0.6.0"])
      s.add_dependency(%q<cancancan>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<grape>, [">= 0.6.0"])
    s.add_dependency(%q<cancancan>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end
