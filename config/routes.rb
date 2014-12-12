Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/manage', as: 'rails_admin'
  resources :donations

  resources :items

  resources :donors do
    member { get :show_partial }
    collection { get :index }
  end

  resources :categories

  get 'welcome/index'

  devise_for :people

  resources :people do
    match 'change_password', to: 'people#change_password', via: [:get, :post], on: :collection
  end

  root 'welcome#index'

end
