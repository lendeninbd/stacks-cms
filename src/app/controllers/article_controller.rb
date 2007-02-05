class ArticleController < ApplicationController
  
  before_filter :authorized, :only => [ :edit, :delete ]
  before_filter :set_history, :except => [ :show_login, :edit, :delete ]
  before_filter :setup_page
  
  def delete
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to :action => :index
  end
  
  def edit
    @article = Article.find_or_initialize_by_title(params[:title])
    @new_record = @article.new_record?
    
    if request.post?
      @article.attributes = params[:article]
      @article.tag_with params[:tag_list]
      if @article.save
        flash[:notice] = "This article was created successfully" if @new_record
        flash[:notice] = "Changes have been saved to this article" unless @new_record
        redirect_to :action => :view, :title => @article.title
      else
        flash[:error] = @article.errors.full_messages.join '<br />'
      end
    end
  end
  
  def index
    redirect_to :action => :view, :title => 'Main Page'
  end
  
  def tag
    @tags = Tag.find(:all, :order => 'name asc').uniq
    @tag = Tag.find(:first, :conditions => [ 'name = ?', params[:tag] ])
    @posts = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Post }
    @articles = Document.find_tagged_with(params[:tag]).reject { |d| d.class != Article }
  end
  
  def view
    @article = Article.find_by_title(params[:title])
    @tags = Tag.find(:all, :order => 'name asc').uniq
  end
  
  private
  def setup_page
    @article_controls = []
  end
  
end
