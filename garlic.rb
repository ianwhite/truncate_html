# This is for running specs against target versions of rails
#
# To use do
#   - cp garlic_example.rb garlic.rb
#   - rake get_garlic
#   - [optional] edit this file to point the repos at your local clones of
#     rails, rspec, and rspec-rails
#   - rake garlic:all
#
# All of the work and dependencies will be created in the galric dir, and the
# garlic dir can safely be deleted at any point

garlic do
  repo 'truncate_html', :path => '.'

  repo 'rails', :url => 'git://github.com/rails/rails'
  repo 'rspec', :url => 'git://github.com/dchelimsky/rspec'
  repo 'rspec-rails', :url => 'git://github.com/dchelimsky/rspec-rails'

  ['origin/2-2-stable', 'origin/2-1-stable', 'origin/2-0-stable'].each do |rails|
    target "Rails: #{rails}", :tree_ish => rails do
      prepare do
        plugin 'truncate_html', :clone => true
        plugin 'rspec'
        plugin 'rspec-rails' do
          `script/generate rspec -f`
        end
      end
  
      run do
        cd "vendor/plugins/truncate_html" do
          sh "rake spec:rcov:verify"
        end
      end
    end
  end
end
