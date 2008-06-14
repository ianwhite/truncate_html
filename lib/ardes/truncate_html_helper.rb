require "rexml/parsers/pullparser"
require 'rubygems'
begin; require "htmlentities"; rescue LoadError; puts "WARNING: htmlentities gem is required for truncate_html plugin"; end
begin; require "hpricot"; rescue LoadError; puts "WARNING: htmlentities gem is required for truncate_html plugin"; end

module Ardes #:nodoc:
  module TruncateHtmlHelper
    # Truncates html respecting tags and html entities.
    #
    # The API is the same as ActionView::Helpers::TextHelper#truncate.  It uses Rexml for the parsing, and HtmlEntities for entity awareness.  If Rexml raises a ParseException, then Hpricot is used to fixup the tags, and we try again
    #
    # Examples:
    #  truncate_html '<p>Hello <strong>World</strong></p>', 7 # => '<p>Hello <strong>W&hellip;</strong></p>'
    #  truncate_html '<p>Hello &amp; Goodbye</p>', 7          # => '<p>Hello &amp;&hellip;</p>'
    def truncate_html(input, length = 30, ellipsis = '&hellip;')
      parser = REXML::Parsers::PullParser.new(input)
      tags, output, chars_remaining = [], '', length
      
      while parser.has_next? && chars_remaining > 0
        element = parser.pull
        case element.event_type
        when :start_element
          output << rexml_element_to_tag(element)
          tags.push element[0]
        when :end_element
          output << "</#{tags.pop}>"
        when :text
          text = HTMLEntities.decode_entities(element[0])
          output << HTMLEntities.encode_entities(text.first(chars_remaining), :named, :basic)
          chars_remaining -= text.length
          output << ellipsis if chars_remaining < 0
        end
      end
      
      tags.reverse.each {|tag| output << "</#{tag}>" }
      output
    
    rescue REXML::ParseException
      truncate_html(Hpricot(input, :fixup_tags => true).to_html, length, ellipsis)
    end
    
  private
    def rexml_element_to_tag(element)
      "<#{element[0]}#{element[1].inject(""){|m,(k,v)| m << %{ #{k}="#{v}"}} unless element[1].empty?}>"
    end
  end
end