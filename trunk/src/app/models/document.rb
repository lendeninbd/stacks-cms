class Document < ActiveRecord::Base
  
  acts_as_taggable

  belongs_to :user
  has_many :links, :dependent => :delete_all
  
  validates_presence_of :title
  validates_presence_of :markdown_text
  
  before_save :format_text
  
  TAG_EXPRESSION = /<[^>]*>/
  
  def after_destroy
    other_links = Link.find(:all, :conditions => [ 'links.title = ?', self.title ], :include => [ :document ])
    other_links.each { |link| 
      link.document.save if link.existing? 
    }
  end
  
  def after_save
    links.clear
    @new_links.each { |link| links.create(link) }
    
    other_links = Link.find(:all, :conditions => [ 'links.title = ?', self.title ], :include => [ :document ])
    other_links.each { |link| link.document.save unless link.existing? || link.document.title == self.title }
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
        new_link = { :title => $1, :existing => false }
        css_class = 'missing'
      else
        new_link = { :title => $1, :existing => true }
        css_class = 'exists'
      end
      @new_links << new_link unless @new_links.include?(new_link)
      
      @@renderer.make_link $1, { :controller => 'article', :action => 'view', :title => $1 }, css_class
    }
    
    self.raw_text = formatted_text.gsub(TAG_EXPRESSION, '')
    
    formatted_text
  end
  
  def self.set_renderer(renderer)
    @@renderer = renderer
  end
end
