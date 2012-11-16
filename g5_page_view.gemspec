# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'page_view/version'

Gem::Specification.new do |s|
  s.name        = "g5_page_view"
  s.version     = G5PageView::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['G5']
  s.homepage = %q{http://github.com/steveburkett/g5_page_view}
  s.summary     = "Page view concept"
  s.description = "Page view abstracted out into lib for use in multiple projects."
  s.extra_rdoc_files = [
    "README.rdoc"
  ]

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "g5_page_view"

  s.add_development_dependency "bundler", ">= 1.0.3"

  s.files        = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'

  #Defaults
  s.add_runtime_dependency('rake')
  s.add_runtime_dependency("mongo", "1.7.1")
  s.add_runtime_dependency("bson", "1.7.1")
  s.add_runtime_dependency("bson_ext", "1.7.1")
  
  #Dev/Test
  s.add_development_dependency("rspec", "~> 2.3.0")
  s.add_development_dependency("ruby-debug", ">= 0")
end
