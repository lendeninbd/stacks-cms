class Document < ActiveRecord::Base
  
  acts_as_taggable
  
  validates_presence_of :title
  validates_presence_of :markdown_text
  
  has_many :links, :dependent => :delete_all
  
  before_save :format_text
  
  TAG_EXPRESSION = /<[^>]*>/
  
  def after_destroy
    other_links = Link.find(:all, :conditions => [ 'links.title = ?', self.title ], :include => [ :document ])
    other_links.each { |link| 
      link.document.save if link.exists? 
    }
  end
  
  def after_save
    links.clear
    @new_links.each { |link| links.create(link) }
    
    other_links = Link.find(:all, :conditions => [ 'links.title = ?', self.title ], :include => [ :document ])
    other_links.each { |link| link.document.save unless link.exists? }
  end
  
  def before_save
    self.formatted_text = format_text
  end
  
  def format_text
    @new_links = []
    
    formatted_text = BlueCloth.new(self.markdown_text).to_html
    formatted_text.gsub!(/<a /, '<a class="external" ')
    formatted_text.gsub!(/\[\[([^\]]*?)\]\]/) { |link|
      page = Article.find(:first, :conditions => [ 'title = ?', $1 ])
      if page.nil?
        @new_links << { :title => $1, :exists => false }
        css_class = 'missing'
      else
        @new_links << { :title => $1, :exists => true }
        css_class = 'exists'
      end
      
      @@renderer.make_link $1, { :controller => 'article', :action => 'view', :title => $1 }, css_class
    }
    
    self.raw_text = formatted_text.gsub(TAG_EXPRESSION, '')
    
    formatted_text
  end
  
  def self.set_renderer(renderer)
    @@renderer = renderer
  end
end
