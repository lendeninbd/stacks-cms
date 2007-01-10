module BlogHelper
  
  def link_to_post(post)
    link_to post.title, 
    { :action => :view, 
      :year => sprintf("%04d", post.created_on.year), 
      :month => sprintf("%02d", post.created_on.month),
      :day => sprintf("%02d", post.created_on.day),
      :id => post.id 
    }
  end
  
  def link_to_tag(tag)
    link_to tag.name, { :action => :tag, :tag => tag.name }
  end
  
  def tag_cloud(tags)
    tags.collect { |tag| link_to_tag tag }.join(', ')
  end
  
end
