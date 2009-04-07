garlic do
  repo 'truncate_html', :path => '.'

  repo 'rails', :url => 'git://github.com/rails/rails'
  repo 'rspec', :url => 'git://github.com/dchelimsky/rspec'
  repo 'rspec-rails', :url => 'git://github.com/dchelimsky/rspec-rails'

  ['master', '2-3-stable', '2-2-stable', '2-1-stable'].each do |rails|
    target rails, :tree_ish => "origin/#{rails}" do
      prepare do
        plugin 'truncate_html', :clone => true
        plugin 'rspec'
        plugin 'rspec-rails' do
          `script/generate rspec -f`
        end
      end
  
      run do
        cd "vendor/plugins/truncate_html" do
          sh "rake rcov:verify"
        end
      end
    end
  end
end
