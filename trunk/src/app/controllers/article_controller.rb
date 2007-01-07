class ArticleController < ApplicationController
  
  def view
    @article = Article.find(params[:name])
  end
  
end
