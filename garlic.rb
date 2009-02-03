garlic do
  repo 'truncate_html', :path => '.'

  repo 'rails', :url => 'git://github.com/rails/rails'
  repo 'rspec', :url => 'git://github.com/dchelimsky/rspec'
  repo 'rspec-rails', :url => 'git://github.com/dchelimsky/rspec-rails'

  # 2-0-stable is out at the moment, because there's a problem running rspec with it
  ['origin/master', 'origin/2-2-stable', 'origin/2-1-stable'].each do |rails|
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
