Rails.application.routes.draw do
  require 'figaro'
  Figaro.load

  mount RailsAdmin::Engine => '/manage', as: 'rails_admin'
  resources :donations

  resources :items

  resources :donors do
    member { get :show_partial }
  end

  resources :categories

  get 'welcome/index'

  devise_for :people

  resources :people do
    match 'change_password', to: 'people#change_password', via: [:get, :post], on: :collection
  end

  root 'welcome#index'

end
