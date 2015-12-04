Rails.application.routes.draw do
  resources :tasks do
    member do
      put 'complete'
    end
  end
  get     'tags', to: 'tags#index', as: :tags
  get     'sign_in', to: 'sessions#new', as: :new_session
  delete  'sign_out', to: 'sessions#destroy', as: :session
  match   '/auth/:provider/callback', to: 'oauth_callbacks#create', via: [:get, :post], as: :oauth_callbacks

  root 'home#index'
end
