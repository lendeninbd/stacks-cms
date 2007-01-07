require File.dirname(__FILE__) + '/../test_helper'

class LinkTest < Test::Unit::TestCase
  fixtures :links
  
  def setup
    Document.set_renderer(TestRenderer.new)
  end

  def test_single_article
    article = Article.new({ :title => 'Test Article', :raw_text => 'This is a [[test]]' })
    assert article.save
    assert_equal 1, article.links.size
    assert_equal 'test', article.links.first.title
    assert !article.links.first.exists?
  end
  
  def test_single_post
    post = Post.new({ :title => 'Test Post', :raw_text => 'This is a [[test]]' })
    assert post.save
    assert_equal 1, post.links.size
    assert_equal 'test', post.links.first.title
    assert !post.links.first.exists?
  end
  
  def test_post_article_creation
    post = Post.new({ :title => 'New Post', :raw_text => 'This post points to [[This Article]]' })
    assert post.save
    
    article = Article.new({ :title => 'This Article', :raw_text => 'And there is some text inside of it' })
    assert article.save
    
    post.reload
    assert_equal 1, post.links.size
    assert_equal 'This Article', post.links.first.title
    assert post.links.first.exists?
  end
  
  def test_article_article_creation
    article1 = Article.new({ :title => 'Article 1', :raw_text => 'This points to [[Article 2]]' })
    assert article1.save
    
    article2 = Article.new({ :title => 'Article 2', :raw_text => 'This is Article 2' })
    assert article2.save
    
    article1.reload
    assert_equal 1, article1.links.size
    assert_equal 'Article 2', article1.links.first.title
    assert article1.links.first.exists?
  end

  def test_page_deletion
    article1 = Article.new({ :title => 'Article 1', :raw_text => 'This points to [[Article 2]]' })
    assert article1.save
    
    article2 = Article.new({ :title => 'Article 2', :raw_text => 'This is Article 2' })
    assert article2.save
    
    assert article2.destroy
    
    article1.reload
    assert_equal 1, article1.links.size
    assert_equal 'Article 2', article1.links.first.title
    assert !article1.links.first.exists?
  end
  
end
