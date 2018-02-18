Rails.application.routes.draw do
  resources :disbursements

  resources :donations

  resources :purchases

  resources :items do
    collection { get :needs }
  end

  resources :donors do
    resources :call_for_actions, except: [:index]
    member { get :info }
    collection { get :print_list }
  end

  resources :donations do
    member { get :print }
    member { get :print_new }
    resources :comments, only: [:create, :destroy]
  end

  resources :categories

  get 'welcome/index'

  devise_for :people

  resources :people do
    match 'change_password', to: 'people#change_password', via: [:get, :post], on: :collection
  end

  scope path: '/reports', as: 'reports' do
    get :daily_inventory, to: 'reports'
    get :audit, to: 'reports'
    get :top_donors, to: 'reports'
    get :total_kind_donations, to: 'reports'
  end

  root 'welcome#index'
end
