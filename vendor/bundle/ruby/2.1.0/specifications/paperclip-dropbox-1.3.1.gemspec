# -*- encoding: utf-8 -*-
# stub: paperclip-dropbox 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "paperclip-dropbox"
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Janko Marohni\u{107}"]
  s.date = "2015-01-29"
  s.description = "Extends Paperclip with Dropbox storage."
  s.email = ["janko.marohnic@gmail.com"]
  s.homepage = "https://github.com/janko-m/paperclip-dropbox"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.2.5"
  s.summary = "Extends Paperclip with Dropbox storage."

  s.installed_by_version = "2.2.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<paperclip>, ["< 5", ">= 3.1"])
      s.add_runtime_dependency(%q<dropbox-sdk>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.11"])
      s.add_development_dependency(%q<vcr>, [">= 2.6"])
      s.add_development_dependency(%q<webmock>, ["< 1.10", ">= 1.8"])
      s.add_development_dependency(%q<activerecord>, [">= 3.2"])
      s.add_development_dependency(%q<rest-client>, [">= 1.6"])
    else
      s.add_dependency(%q<paperclip>, ["< 5", ">= 3.1"])
      s.add_dependency(%q<dropbox-sdk>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.11"])
      s.add_dependency(%q<vcr>, [">= 2.6"])
      s.add_dependency(%q<webmock>, ["< 1.10", ">= 1.8"])
      s.add_dependency(%q<activerecord>, [">= 3.2"])
      s.add_dependency(%q<rest-client>, [">= 1.6"])
    end
  else
    s.add_dependency(%q<paperclip>, ["< 5", ">= 3.1"])
    s.add_dependency(%q<dropbox-sdk>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.11"])
    s.add_dependency(%q<vcr>, [">= 2.6"])
    s.add_dependency(%q<webmock>, ["< 1.10", ">= 1.8"])
    s.add_dependency(%q<activerecord>, [">= 3.2"])
    s.add_dependency(%q<rest-client>, [">= 1.6"])
  end
end
