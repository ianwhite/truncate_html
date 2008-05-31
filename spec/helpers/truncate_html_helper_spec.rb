require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ardes::TruncateHtmlHelper do
  include Ardes::TruncateHtmlHelper
  
  def self.with_length_should_equal(n, str)
    it "#{n}, should equal #{str}" do
      truncate_html(@html, n).should == str
    end
  end
  
  
  describe "html: <p>Hello <strong>World</strong></p>, length: " do
    before { @html = '<p>Hello <strong>World</strong></p>' }
  
    with_length_should_equal 3, '<p>Hel&hellip;</p>'
    with_length_should_equal 7, '<p>Hello <strong>W&hellip;</strong></p>'
    with_length_should_equal 11, '<p>Hello <strong>World</strong></p>'
  end
  
  describe 'html: <p>Hello &amp; <span class="foo">Goodbye</span> <br /> Hi</p>, length: ' do
    before { @html = '<p>Hello &amp; <span class="foo">Goodbye</span> <br /> Hi</p>' }

    with_length_should_equal 7, '<p>Hello &amp;&hellip;</p>'
    with_length_should_equal 9, '<p>Hello &amp; <span class="foo">G&hellip;</span></p>'
    with_length_should_equal 18, '<p>Hello &amp; <span class="foo">Goodbye</span> <br></br> H&hellip;</p>'
  end

  describe '(incorrect) html: <p>Hello <strong>World</p><div>And Hi, length: ' do
    before { @html = '<p>Hello <strong>World</p><div>And Hi' }
  
    with_length_should_equal 10, '<p>Hello <strong>Worl&hellip;</strong></p>'
    with_length_should_equal 30, '<p>Hello <strong>World</strong></p><div>And Hi</div>'
  end
end