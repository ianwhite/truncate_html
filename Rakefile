# use pluginized rpsec if it exists
rspec_base = File.expand_path(File.dirname(__FILE__) + '/../rspec/lib')
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base) and !$LOAD_PATH.include?(rspec_base)

require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

PluginName = "truncate_html"

task :default => :spec

desc "Run the specs for #{PluginName}"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts  = ["--colour"]
end

desc "Generate RCov report for #{PluginName}"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files  = FileList['spec/**/*_spec.rb']
  t.rcov        = true
  t.rcov_dir    = 'doc/coverage'
  t.rcov_opts   = ['--text-report', '--exclude', "spec/,rcov.rb,#{File.expand_path(File.join(File.dirname(__FILE__),'../../..'))}"] 
end

namespace :rcov do
  desc "Verify RCov threshold for #{PluginName}"
  RCov::VerifyTask.new(:verify => "rcov") do |t|
    t.threshold = 100.0
    t.index_html = File.join(File.dirname(__FILE__), 'doc/coverage/index.html')
  end
end

# the following tasks are for CI and doc building
begin
  require 'hanna/rdoctask'
  require 'garlic/tasks'
  require 'grancher/task'
  
  task :cruise => ['garlic:all', 'doc:publish']
  
  Rake::RDocTask.new(:doc) do |d|
    d.rdoc_dir = 'doc'
    d.main     = 'README.rdoc'
    d.title    = "#{PluginName} API Docs"
    d.rdoc_files.include('README.rdoc', 'History.txt', 'License.txt', 'Todo.txt', 'lib/**/*.rb')
  end

  namespace :doc do
    Grancher::Task.new(:publish => :doc) do |g|
      g.keep 'index.html', '.gitignore'
      g.directory 'doc', 'doc'
      g.branch = 'gh-pages'
      g.push_to = 'origin'
    end
  end

rescue LoadError
end
