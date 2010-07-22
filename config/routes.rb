ActionController::Routing::Routes.draw do |map|

  map.resources :google_forms
  map.resources :forms, :member => {:submit => :post, :thank_you => :get}
  
  # map.with_options :controller => 'operate_form' do |f|
  #   f.connect "/forms", :action => 'index'
  #   f.submit_operate_form "operate_form/:id", :action => "update"
  #   f.form "/forms/:slug", :action => "show"
  #   f.catch_all "/forms/*slug", :action => "show"
  # end
  
end
