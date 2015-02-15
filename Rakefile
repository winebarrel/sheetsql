require 'bundler/gem_tasks'

task :racc do
  path = File.expand_path('../lib/sheetsql/parser.y', __FILE__)
  sh "racc #{path}"
end
