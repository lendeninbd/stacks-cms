class ApplicationController < ActionController::Base
  
  before_filter :set_renderer
  
  def authorized
    if session[:user]
      @user = session[:user]
    else
      render :text => "<h1>Forbidden</h1>", :status => 403
    end
  end
  
  def expire_tag_caches(tags)
    tags.each do |tag| 
      expire_fragment("blog/tag/#{tag.name}") 
      expire_fragment("article/tag/#{tag.name}")
    end
  end
  
  def show_login
    
  end
  
  def set_renderer
    Document.set_renderer(PageRenderer.new(self))
  end
  
  def set_history
    session[:history] = request.request_uri
  end
  
end