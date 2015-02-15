require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

task :default => :spec

task :racc do
  path = File.expand_path('../lib/sheetsql/parser.y', __FILE__)
  sh "racc #{path}"
end
