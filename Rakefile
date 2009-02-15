# use pluginized rpsec if it exists
rspec_base = File.expand_path(File.dirname(__FILE__) + '/../rspec/lib')
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base) and !$LOAD_PATH.include?(rspec_base)

require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

plugin_name = "truncate_html"

task :default => :spec

desc "Run the specs for #{plugin_name}"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts  = ["--colour"]
end

desc "Generate RCov report for #{plugin_name}"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files  = FileList['spec/**/*_spec.rb']
  t.rcov        = true
  t.rcov_dir    = 'doc/coverage'
  t.rcov_opts   = ['--text-report', '--exclude', "spec/,rcov.rb,#{File.expand_path(File.join(File.dirname(__FILE__),'../../..'))}"] 
end

namespace :rcov do
  desc "Verify RCov threshold for #{plugin_name}"
  RCov::VerifyTask.new(:verify => "spec:rcov") do |t|
    t.threshold = 100.0
    t.index_html = File.join(File.dirname(__FILE__), 'doc/coverage/index.html')
  end
end

# the following tasks are for CI and doc building, so if dependencies don't
# exist just load these tasks
begin
  require 'hanna/rdoctask'
  require 'garlic/tasks'
  require 'grancher/task'
  
  task :cruise => ['garlic:all', 'doc:publish_new'] do
    puts "The build is GOOD"
  end

  task :doc => 'doc:build'

  namespace :doc do
    def repo_sha
      `git log -1 --pretty=format:"%h"`
    end
  
    def doc_sha
      File.read('doc/index.html').match(/<title>.*?\((\w{7})\)<\/title>/m)[1] rescue nil
    end
    
    task :publish_new do
      Rake::Task.invoke('doc:publish') if doc_sha != repo_sha
    end
    
    Rake::RDocTask.new(:build) do |d|
      d.rdoc_dir = 'doc'
      d.main     = 'README.rdoc'
      d.title    = "#{plugin_name} API Docs (#{repo_sha})"
      d.rdoc_files.include('README.rdoc', 'History.txt', 'License.txt', 'Todo.txt', 'lib/**/*.rb')
    end
  
    Grancher::Task.new(:publish) => ['doc:build'] do |g|
      if doc_sha != repo_sha
        g.keep 'index.html'
        g.directory 'doc', 'doc'
        g.branch = 'gh-pages'
        g.push_to = 'origin'
      end
    end
  end
rescue LoadError
end