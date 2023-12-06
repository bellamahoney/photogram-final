Rails.application.routes.draw do
  devise_for :likes
  devise_for :follow_requests
  devise_for :comments
  devise_for :photos
  devise_for :create_photos
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
