Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'artists#index'

  resources :artists do
    collection do
      get 'search'
    end
    member do
      get 'tracks' => 'artist_tracks#index'
    end
  end
end
