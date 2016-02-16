Rails.application.routes.draw do
  resources :tasks do
    member do
      put 'complete'
      put 'cancel_completion'
    end
  end

  get     'tags', to: 'tags#index', as: :tags
  get     'tags/filter', to: 'tags#filter'

  post    'assignments/:task_id', to: 'assignments#create', as: :assignments
  delete  'assignments/:task_id', to: 'assignments#destroy', as: :assignment

  get     'sign_in', to: 'sessions#new', as: :new_session
  delete  'sign_out', to: 'sessions#destroy', as: :session
  match   '/auth/:provider/callback', to: 'oauth_callbacks#create', via: [:get, :post], as: :oauth_callbacks

  get     'search', to: 'search#index', as: :search

  root 'home#index'
end
