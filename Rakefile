require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

spec = Gem::Specification.new do |spec|
  spec.name             = 'has_digest'
  spec.version          = '0.1.0'
  spec.summary          = 'ActiveRecord macro that helps encrypt passwords and generate api tokens before_save.'
  spec.files            = FileList['README.rdoc', 'MIT-LICENSE', 'init.rb', 'lib/**/*.rb', 'shoulda_macros/**/*.rb', 'test/**/*.rb'].to_a
  spec.has_rdoc         = true
  spec.rdoc_options     = %W[--main README.rdoc --title #{spec.name}-#{spec.version} --inline-source --line-numbers]
  spec.extra_rdoc_files = FileList['README.rdoc'].to_a
  spec.author           = 'Matthew Todd'
  spec.email            = 'matthew.todd@gmail.com'
end

desc 'Generate a gemspec file'
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end

desc 'Test the has_digest plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the has_digest plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HasDigest'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('shoulda_macros/**/*.rb')
end
