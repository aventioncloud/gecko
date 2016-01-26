# -*- encoding: utf-8 -*-
# stub: dropbox-sdk 1.6.5 ruby lib

Gem::Specification.new do |s|
  s.name = "dropbox-sdk"
  s.version = "1.6.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dropbox, Inc."]
  s.date = "2015-07-29"
  s.description = "    A library that provides a plain function-call interface to the\n    Dropbox API web endpoints.\n"
  s.email = ["support-api@dropbox.com"]
  s.homepage = "http://www.dropbox.com/developers/"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.5"
  s.summary = "Dropbox REST API Client."

  s.installed_by_version = "2.2.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<minitest>, ["~> 4.3.2"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<minitest>, ["~> 4.3.2"])
      s.add_dependency(%q<test-unit>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<minitest>, ["~> 4.3.2"])
    s.add_dependency(%q<test-unit>, [">= 0"])
  end
end
