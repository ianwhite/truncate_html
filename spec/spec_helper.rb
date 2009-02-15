ENV["RAILS_ENV"] ||= "test"
__DIR__ = File.dirname(__FILE__)

# if we're in a rails env, use that, otherwise use rubygems to create a spec env
if File.exist?(rails_env = "#{__DIR__}/../../../../config/environment")
  require rails_env
else
  require 'rubygems'
  require 'activesupport'
  require 'actionpack'
  require 'action_view'
  $LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
  require File.join(File.dirname(__FILE__), '..', 'init')
end

require 'spec'