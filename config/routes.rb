Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :matching_datum, only: [:index, :new, :create]
  root to: 'matching_datum#index'
end
