class AdminController < ApplicationController
  
  before_filter :authorized
  before_filter :can_modify_users, :only => [ :disable, :enable, :set_password, :user, :users, ]
  
  def add_user
    user = User.new(params[:user])
    user.password = params[:password]
    flash[:user_error] = user.errors.full_messages.join '<br />' unless user.save
    redirect_to :action => :users
  end
  
  def change_password
    user = session[:user]
    if Digest::SHA256.hexdigest(params[:old_password] + user.password_salt) != user.password_hash
      flash[:password_error] = 'You must supply a valid password before you can change it'
    elsif params[:new_password_1].blank?
      flash[:password_error] = 'You must supply a new password'
    elsif params[:new_password_2].blank?
      flash[:password_error] = 'You must confirm the password that you have entered'
    elsif params[:new_password_1] != params[:new_password_2]
      flash[:password_error] = 'Your new password does not match your confirmation'
    else
      user.password = params[:new_password_1]
      user.save
      flash[:password_notice] = 'Your password has been changed'
    end
    redirect_to :action => :profile
  end
  
  def disable
    if session[:user].can_modify_users?
      user = User.find(params[:id])
      if user == session[:user]
        flash[:error] = "You can't disable yourself"
      else
        user.disabled = true
        user.save
      end
    end
    redirect_to :action => :users
  end
  
  def enable
    if session[:user].can_modify_users?
      user = User.find(params[:id])
      user.disabled = false
      user.save
    end
    redirect_to :action => :users
  end
  
  def index
    redirect_to :action => :profile
  end
  
  def non_existent_pages
    @links = {}
    Link.find(:all, :conditions => [ 'existing = ?', false ], :include => [ :document ]).each do |link|
      @links[link.title] = [] if @links[link.title].nil?
      @links[link.title] << link.document.title
    end
  end
  
  def profile
    @user = session[:user]
    if request.post?
      @user.attributes = params[:user].delete(:can_modify_users)
      if @user.save
        session[:user] = @user
        flash[:notice] = 'Changes have been saved to your account'
      else
        flash[:error] = @user.errors.full_messages.join '<br />'
      end
    end
  end
  
  def set_password
    user = User.find(params[:id])
    if params[:new_password].blank?
      flash[:password_error] = 'You must supply a new password'
    elsif params[:confirm_password].blank?
      flash[:password_error] = 'You must confirm the password that you have entered'
    elsif params[:new_password] != params[:confirm_password]
      flash[:password_error] = 'Your new password does not match your confirmation'
    else
      user.password = params[:new_password]
      user.save
      flash[:password_notice] = 'This password has been changed'
    end
    redirect_to :action => :user, :id => user
  end
  
  def users
    @users = User.find(:all, :order => 'disabled asc, username asc')
  end
  
  def user
    @user = User.find(params[:id])
    if request.post?
      if @user.update_attributes(params[:user])
        flash[:notice] = "Changes to <em>#{@user.username}</em> were saved"
        redirect_to :action => :users
      else
        flash[:error] = @user.errors.full_messages.join '<br />'
      end
    end
  end
  
  private
  def can_modify_users
    unless session[:user].can_modify_users
      render :text => "<h1>Forbidden</h1>", :status => 403
    end
  end
  
end
