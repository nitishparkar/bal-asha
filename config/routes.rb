Rails.application.routes.draw do

  resources :disbursements

  resources :donations

  resources :purchases

  resources :items

  resources :donors do
    resources :call_for_actions, except: [:index]
    member { get :info }
    collection { get :index }
  end

  resources :donations do
    member { get :print }
    resources :comments, only: [:create, :destroy]
  end

  resources :categories

  get 'welcome/index'

  devise_for :people

  resources :people do
    match 'change_password', to: 'people#change_password', via: [:get, :post], on: :collection
  end

  root 'welcome#index'

end
