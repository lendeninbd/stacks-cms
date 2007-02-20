class Article < Document
  
  validates_uniqueness_of :title
  
  def is_on_index?
    false
  end

end