class Post < Document
  
  def is_on_index?
    Post.find(:all, :limit => POSTS_ON_INDEX, :order => 'created_at DESC').include? self
  end
end