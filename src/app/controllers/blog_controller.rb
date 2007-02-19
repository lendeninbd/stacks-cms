class BlogController < ApplicationController
  
  before_filter :authorized, :only => [ :edit, :new, :delete ]
  before_filter :set_history, :except => [ :show_login, :new, :edit, :delete, :rss ]
  before_filter :setup_page, :except => [ :show_login, :rss ]
  
  caches_action :rss
  
  def delete
    @post = Post.find(params[:id])
    tags = @post.tags.dup
    @post.destroy
    expire_caches
    expire_tag_caches tags
    redirect_to :action => :index
  end
  
  def edit
    @post = Post.find(params[:id])
    if request.post?
      @post.attributes = params[:post]
      @post.tag_with params[:tag_list]
      @post.edited_at = Time.now
      old_tags = @post.tags.dup
      if @post.save
        expire_caches
        expire_tag_caches @post.tags
        expire_tag_caches old_tags
        redirect_to_url session[:history]
      else
        flash[:error] = 'You need a title and text to save this post'
      end
    end
  end
  
  def index
    @posts = Post.find(:all, :limit => POSTS_ON_INDEX, :order => 'created_at DESC') unless read_fragment(:controller => 'blog', :action => 'index')
  end
  
  def new
    @post = Post.new
    if request.post?
      @post.attributes = params[:post]
      @post.tag_with params[:tag_list]
      @post.user = session[:user]
      if @post.save
        expire_caches
        expire_tag_caches(@post.tags)
        redirect_to :action => :index
      else
        flash[:error] = 'You need a title and text to save this post'
      end
    end
  end
  
  def rss
    headers['Content-Type'] = 'application/xml'
    @posts = Post.find(:all, :order => 'created_at desc', :limit => POSTS_IN_FEED) unless read_fragment(:controller => 'blog', :action => 'rss')
    render :layout => false
  end
  
  def tag
    @tag = Tag.find(:first, :conditions => [ 'name = ?', params[:tag] ])
    unless read_fragment("blog/tag/#{@tag.name}")
      @posts = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Post }
      @articles = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Article }
    end
  end
  
  def view
    @post = Post.find(params[:id])
  end
  
  private
  def expire_caches
    expire_fragment(:controller => 'blog', :action => 'index')
    expire_fragment(:controller => 'blog', :name => 'tag_cloud')
    expire_fragment(:controller => 'article', :name => 'tag_cloud')
    expire_action(:action => :rss)
  end
  
  def setup_page
    @blog_controls = []
    @current_controller = controller_name
  end
  
end
