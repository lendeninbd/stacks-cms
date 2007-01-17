class BlogController < ApplicationController
  
  before_filter :set_history, :except => [ :show_login, :new, :edit, :delete ]
  before_filter :setup_page
  
  def delete
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to :action => :index
  end
  
  def edit
    @post = Post.find(params[:id])
    if request.post?
      @post.attributes = params[:post]
      @post.tag_with params[:tag_list]
      @post.edited_at = Time.now
      if @post.save
        redirect_to_url session[:history]
      else
        flash[:error] = 'You must fix your errors before this post can be updated'
      end
    end
  end
  
  def new
    @post = Post.new
    if request.post?
      @post.attributes = params[:post]
      @post.tag_with params[:tag_list]
      if @post.save
        redirect_to :action => :index
      else
        flash[:error] = 'You must fix your errors before this post can be saved'
      end
    end
  end
  
  def index
    @posts = Post.find(:all, :limit => 5, :order => 'created_at DESC')
    @tags = Tag.find(:all, :order => 'name asc').uniq
  end
  
  def tag
    @tags = Tag.find(:all, :order => 'name asc').uniq
    @tag = Tag.find(:first, :conditions => [ 'name = ?', params[:tag] ])
    @posts = Post.find_tagged_with(params[:tag])
    @articles = Post.find_tagged_with(params[:tag])
  end
  
  def view
    @post = Post.find(params[:id])
    @tags = Tag.find(:all).uniq
  end
  
  private
  def setup_page
    @blog_controls = []
  end
  
end
