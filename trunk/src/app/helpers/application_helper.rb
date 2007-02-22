module ApplicationHelper
  
  def link_to_post(post, only_path = true)
    link_to post.title, 
    { :controller => 'blog',
      :action => :view, 
      :year => sprintf("%04d", post.created_at.year), 
      :month => sprintf("%02d", post.created_at.month),
      :day => sprintf("%02d", post.created_at.day),
      :id => post.id,
      :only_path => only_path
    }
  end
  
  def link_to_tag(tag)
    link_to tag.name, { :controller => @current_controller, :action => :tag, :tag => tag.name }, { :rel => 'tag' }
  end
  
  def tag_cloud()
    Tag.tags(:order => 'name asc').collect { |tag| link_to_tag tag }.join(', ')
  end
  
  def url_to_post(post, only_path = true)
    url_for(:controller => 'blog', :action => :view, :year => sprintf("%04d", post.created_at.year), :month => sprintf("%02d", post.created_at.month), :day => sprintf("%02d", post.created_at.day), :id => post.id, :only_path => only_path)
  end
  
end
