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
  
  def local_request?
    # Comment out this method if you aren't test 404/500
    false
  end
  
  def rescue_404
    rescue_action_in_public CustomNotFoundError.new
  end
  
  def rescue_action_in_public(exception)
    @show_tags = true
    case exception
    when CustomNotFoundError, ::ActionController::UnknownAction then
      render :template => 'shared/error404', :layout => 'layouts/blog', :status => '404'
    else
      Notifier.deliver_program_exception(exception,params)
      render :template => 'shared/error500', :layout => 'layouts/blog', :status => '500'
    end
  end
  
  def show_login
    render :template => 'shared/show_login', :layout => false
  end
  
  def set_renderer
    Document.set_renderer(PageRenderer.new(self))
  end
  
  def set_history
    session[:history] = request.request_uri
  end
  
end