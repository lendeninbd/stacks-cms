class ArticleController < ApplicationController
  
  before_filter :authorized, :only => [ :edit, :delete ]
  before_filter :set_history, :except => [ :show_login, :edit, :delete ]
  before_filter :setup_page
  
  def delete
    @article = Article.find(params[:id])
    @article.destroy
    expire_caches(@article)
    redirect_to :action => :index
  end
  
  def edit
    @article = Article.find_or_initialize_by_title(params[:title])
    @new_record = @article.new_record?
    
    if request.post?
      @article.attributes = params[:article]
      @article.tag_with params[:tag_list]
      @article.user = session[:user] if @new_record
      if @article.save
        flash[:notice] = "This article was created successfully" if @new_record
        flash[:notice] = "Changes have been saved to this article" unless @new_record
        expire_caches(@article)
        redirect_to :action => :view, :title => @article.title
      else
        flash[:error] = 'You need text to save this article'
      end
    end
  end
  
  def index
    redirect_to :action => :view, :title => 'Main Page'
  end
  
  def tag
    @tag = Tag.find(:first, :conditions => [ 'name = ?', params[:tag] ])
    unless read_fragment("article/tag/#{@tag.name}")
      @posts = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Post }
      @articles = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Article }
    end
  end
  
  def view
    @article = Article.find_by_title(params[:title])
  end
  
  private
  def expire_caches(article)
    expire_fragment(:controller => 'article', :name => 'tag_cloud')
    expire_fragment(:controller => 'blog', :name => 'tag_cloud')
    expire_fragment(%r{blog/tag/.*})
    
    article.links_here.each { |link| 
      expire_fragment(:controller => 'blog', :action => 'index') if link.document.is_on_index? 
    }
  end
  
  def setup_page
    @article_controls = []
    @current_controller = controller_name
  end
  
end
