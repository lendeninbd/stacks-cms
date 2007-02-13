class LoginController < ApplicationController
  
  def index
    if request.post?
      user = User.find(:first, :conditions => [ 'username = ?', params[:username] ])
      if user.blank? || user.disabled? || Digest::SHA256.hexdigest(params[:password] + user.password_salt) != user.password_hash
        flash[:error] = 'Invalid username or password'
      else
        session[:user] = user
        if session[:history]
          redirect_to_url session[:history]
        else
          redirect_to :controller => 'blog'
        end
      end
    end
  end
  
  def logout
    session[:user] = nil
    if session[:history]
      redirect_to_url session[:history]
    else
      redirect_to :controller => 'blog'
    end
  end
  
end
