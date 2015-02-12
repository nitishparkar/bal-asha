Rails.application.routes.draw do

  resources :donations

  resources :purchases

  resources :items

  resources :donors do
    member { get :info }
    collection { get :index }
  end

  resources :donations do
    resources :comments
  end

  resources :categories

  get 'welcome/index'

  devise_for :people

  resources :people do
    match 'change_password', to: 'people#change_password', via: [:get, :post], on: :collection
  end

  root 'welcome#index'

end
