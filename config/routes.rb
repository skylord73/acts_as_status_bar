Rails.application.routes.draw do
   namespace :acts_as_status_bar do
     resources :status_bar, :only =>[:index, :show, :destroy] do
 	     delete 'destroy_all', :on => :collection
 	   end
  end
end