Rails.application.routes.draw do
   namespace :acts_as_status_bar do
   	 	 resources :status_bar, :only =>[:edit]
  end
end