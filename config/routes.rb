Rails.application.routes.draw do

  resources :items

  resources :countries

  resources :categories

  get 'welcome/index'

  devise_for :people

  resources :people do
    match 'change_password', to: 'people#change_password', via: [:get, :post], on: :collection
  end

  root 'welcome#index'

end
