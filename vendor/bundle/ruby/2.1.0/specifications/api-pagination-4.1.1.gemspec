# -*- encoding: utf-8 -*-
# stub: api-pagination 4.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "api-pagination"
  s.version = "4.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Celis"]
  s.date = "2015-02-12"
  s.description = "Link header pagination for Rails and Grape APIs"
  s.email = ["me@davidcel.is"]
  s.homepage = "https://github.com/davidcelis/api-pagination"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.5"
  s.summary = "Link header pagination for Rails and Grape APIs. Don't use the request body."

  s.installed_by_version = "2.2.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<grape>, [">= 0.10.0"])
      s.add_development_dependency(%q<railties>, [">= 3.0.0"])
      s.add_development_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_development_dependency(%q<sequel>, [">= 4.9.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<grape>, [">= 0.10.0"])
      s.add_dependency(%q<railties>, [">= 3.0.0"])
      s.add_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_dependency(%q<sequel>, [">= 4.9.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<grape>, [">= 0.10.0"])
    s.add_dependency(%q<railties>, [">= 3.0.0"])
    s.add_dependency(%q<actionpack>, [">= 3.0.0"])
    s.add_dependency(%q<sequel>, [">= 4.9.0"])
  end
end
