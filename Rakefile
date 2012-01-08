# use pluginized rpsec if it exists
rspec_base = File.expand_path(File.dirname(__FILE__) + '/../rspec/lib')
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base) and !$LOAD_PATH.include?(rspec_base)

require 'rcov'
require 'rspec/core/rake_task'

PluginName = "truncate_html"

task :default => :spec

desc "Run the specs for #{PluginName}"
RSpec::Core::RakeTask.new(:spec)

desc "Generate RCov report for #{PluginName}"
RSpec::Core::RakeTask.new(:rcov) do |t|
  # t.spec_files  = FileList['spec/**/*_spec.rb']
  t.rcov        = true
  # t.rcov_dir    = 'doc/coverage'
  t.rcov_opts   = ['--text-report', '--exclude', "/Library/Ruby,spec/,rcov.rb,#{File.expand_path(File.join(File.dirname(__FILE__),'../../..'))}"]
end

# the following tasks are for CI and doc building
begin
  require 'hanna/rdoctask'
  require 'garlic/tasks'
  require 'grancher/task'

  task :cruise => ['garlic:all', 'doc:publish']

  Rake::RDocTask.new(:doc) do |d|
    d.options << '--all'
    d.rdoc_dir = 'doc'
    d.main     = 'README.rdoc'
    d.title    = "#{PluginName} API Docs"
    d.rdoc_files.include('README.rdoc', 'History.txt', 'License.txt', 'Todo.txt', 'lib/**/*.rb')
  end

  namespace :doc do
    task :publish => :doc do
      Rake::Task['doc:push'].invoke unless uptodate?('.git/refs/heads/gh-pages', 'doc')
    end

    Grancher::Task.new(:push) do |g|
      g.keep_all
      g.directory 'doc', 'doc'
      g.branch = 'gh-pages'
      g.push_to = 'origin'
    end
  end

rescue LoadError
end
