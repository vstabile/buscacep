# encoding: UTF-8
require "rubygems"
require "rake"
require "rake/testtask"
require "rdoc/task"
require "rake/packagetask"
require "rake/gempackagetask"

require File.join(File.dirname(__FILE__), "lib", "buscacep", "version")

PKG_BUILD     = ENV["PKG_BUILD"] ? "." + ENV["PKG_BUILD"] : ""
PKG_NAME      = "buscacep"
PKG_VERSION   = BrCep::VERSION::STRING + PKG_BUILD
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
Rake::TestTask.new { |t|
  t.libs << "test"
  t.pattern = "test/*_test.rb"
  t.verbose = true
  t.warning = false
}

#Generate the RDoc documentation
Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.title    = "Busca CEP"
  rdoc.options << "--line-numbers" << "--inline-source" << "-A cattr_accessor=object"
  rdoc.options << "--charset" << "utf-8"
  rdoc.template = "#{ENV["template"]}.rb" if ENV["template"]
  rdoc.rdoc_files.include("README", "CHANGELOG")
  rdoc.rdoc_files.include("lib/**/*")
}

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  `gem push pkg/#{PKG_FILE_NAME}.gem`
end
