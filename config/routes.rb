ActionController::Routing::Routes.draw do |map|
  map.day 'day/:date', :controller=>:comics, :action=>:day
  map.daylist 'day', :controller=>:comics, :action=>:daylist
  map.root :controller=>:comics, :action=>:daylist
  map.update_online_list 'comics/update_online_list', :controller=>:comics, :action=>:update_online_list
  map.show_example_from_online_list 'comics/update_online_list/example/:ident', :controller=>:comics, :action=>:show_example_from_online_list
  map.use_online_list 'comics/use_online_list', :controller=>:comics, :action=>:use_online_list, :conditions=>{:method=>:post}
  map.connect 'comics/:id/page/:page', :controller=>:comics, :action=>:show
  map.resources :strips, :only=>[:show]
  map.comic_update 'comics/:id/update', :controller=>:comics, :action=>:get_new_strip
  map.feed 'feed', :controller=>:comics, :action=>:feed
  map.resources :comics
  map.debug_comic 'comics/:id/debug', :controller=>:comics, :action=>:debug

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
