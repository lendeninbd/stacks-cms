class Article < Document
  
  validates_uniqueness_of :title
  
  def before_destory
    # Never kill the Main Page
    raise "You can't destroy the Main Page" if self.title == 'Main Page'
  end
  
  def is_on_index?
    false
  end

end