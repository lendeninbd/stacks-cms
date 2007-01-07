class ApplicationController < ActionController::Base
  
  before_filter :set_renderer
  
  def authorized
    if session[:user]
      @user = session[:user]
    else
      redirect_to :action => :unauthorized
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
  
  def unauthorized
    render :text => "Forbidden", :status => 403, :layout => false
  end
  
end