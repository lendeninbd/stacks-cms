class BlogController < ApplicationController
  
  before_filter :authorized, :only => [ :edit, :new, :delete ]
  before_filter :set_history, :except => [ :show_login, :new, :edit, :delete, :rss ]
  before_filter :setup_page, :except => [ :show_login, :rss ]
  
  caches_action :rss
  
  def delete
    @post = Post.find(params[:id])
    @post.destroy
    expire_caches
    redirect_to :action => :index
  end
  
  def edit
    @post = Post.find(params[:id])
    if request.post?
      @post.attributes = params[:post]
      @post.tag_with params[:tag_list]
      @post.edited_at = Time.now
      if @post.save
        expire_caches
        redirect_to_url session[:history]
      else
        flash[:error] = 'You must fix your errors before this post can be updated'
      end
    end
  end
  
  def index
    @posts = Post.find(:all, :limit => 5, :order => 'created_at DESC') unless read_fragment(:controller => 'blog', :action => 'index')
    @tags = get_tags unless read_fragment(:controller => 'blog', :name => 'tag_cloud')
  end
  
  def new
    @post = Post.new
    if request.post?
      @post.attributes = params[:post]
      @post.tag_with params[:tag_list]
      if @post.save
        expire_caches
        redirect_to :action => :index
      else
        flash[:error] = 'You must fix your errors before this post can be saved'
      end
    end
  end
  
  def rss
    headers['Content-Type'] = 'application/xml'
    @posts = Post.find(:all, :order => 'created_at desc', :limit => 15) unless read_fragment(:controller => 'blog', :action => 'rss')
    render :layout => false
  end
  
  def tag
    @tags = get_tags unless read_fragment(:controller => 'blog', :name => 'tag_cloud')
    @tag = Tag.find(:first, :conditions => [ 'name = ?', params[:tag] ])
    unless read_fragment("blog/tag/#{@tag.name}")
      @posts = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Post }
      @articles = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Article }
    end
  end
  
  def view
    @post = Post.find(params[:id])
    @tags = get_tags unless read_fragment(:controller => 'blog', :name => 'tag_cloud')
  end
  
  private
  def expire_caches
    expire_fragment(:controller => 'blog', :action => 'index')
    expire_fragment(:controller => 'blog', :name => 'tag_cloud')
    expire_fragment(%r{blog/tag/.*})
    expire_action(:action => :rss)
  end
  
  def setup_page
    @blog_controls = []
  end
  
end
