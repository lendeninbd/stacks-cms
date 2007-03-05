ActionController::Routing::Routes.draw do |map|
  map.connect 'blog/:year/:month/:day/:id', :controller => 'blog', :action => 'view'
  map.connect 'blog/tag/:tag', :controller => 'blog', :action => 'tag'
  
  map.connect 'article/view/:title', :controller => 'article', :action => 'view'
  map.connect 'article/edit/:title', :controller => 'article', :action => 'edit'
  map.connect 'article/tag/:tag', :controller => 'article', :action => 'tag'
  
  map.connect '', :controller => 'blog'

  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect ':controller/:action/:id'
  
  # Catch anything that is from the old site
  map.connect '*path', :controller => 'application', :action => 'rescue_404' unless ::ActionController::Base.consider_all_requests_local
  
end
