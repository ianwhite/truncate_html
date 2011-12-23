ENV["RAILS_ENV"] ||= "test"
__DIR__ = File.dirname(__FILE__)

require 'rubygems'

require 'rails/all'
$LOAD_PATH << "#{__DIR__}/../lib"
require "#{__DIR__}/../init"

require 'rspec'

# dependencies of truncate_html
require 'htmlentities'
require 'nokogiri'
