require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

module TruncateHtmlHelperSpecHelper
  def self.included(base) 
    base.class_eval do
      def self.with_length_should_equal(n, str)
        it "#{n}, should equal #{str}" do
          truncate_html(@html, n).should == str
        end
      end
    end
  end
end

describe Ardes::TruncateHtmlHelper, "html: <p>Hello <strong>World</strong></p>, length: " do
  include TruncateHtmlHelperSpecHelper
  
  before do
    @html = '<p>Hello <strong>World</strong></p>'
  end
  
  with_length_should_equal 3, '<p>Hel&hellip;</p>'
  with_length_should_equal 7, '<p>Hello <strong>W&hellip;</strong></p>'
  with_length_should_equal 11, '<p>Hello <strong>World</strong></p>'
end

describe Ardes::TruncateHtmlHelper, 'html: <p>Hello &amp; <span class="foo">Goodbye</span> <br /> Hi</p>, length: ' do
  include TruncateHtmlHelperSpecHelper
  
  before do
    @html = '<p>Hello &amp; <span class="foo">Goodbye</span> <br /> Hi</p>'
  end
  
  with_length_should_equal 7, '<p>Hello &amp;&hellip;</p>'
  with_length_should_equal 9, '<p>Hello &amp; <span class="foo">G&hellip;</span></p>'
  with_length_should_equal 18, '<p>Hello &amp; <span class="foo">Goodbye</span> <br></br> H&hellip;</p>'
end

describe Ardes::TruncateHtmlHelper, ' (incorrect) html: <p>Hello <strong>World</p><div>And Hi, length: ' do
  include TruncateHtmlHelperSpecHelper
  
  before do
    @html = '<p>Hello <strong>World</p><div>And Hi'
  end
  
  with_length_should_equal 10, '<p>Hello <strong>Worl&hellip;</strong></p>'
  with_length_should_equal 30, '<p>Hello <strong>World</strong></p><div>And Hi</div>'
end