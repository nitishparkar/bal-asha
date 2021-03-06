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
    resources :comments, only: [:create, :destroy]
    resource :donation_actions, only: [:update]
  end

  resources :categories

  get 'welcome/index'

  devise_for :people

  resources :people do
    match 'change_password', to: 'people#change_password', via: [:get, :post], on: :collection
  end

  scope path: '/reports', as: 'reports' do
    get :daily_inventory, controller: 'reports'
    get :audit, controller: 'reports'
    get :top_donors, controller: 'reports'
    get :total_kind_donations, controller: 'reports'
    get :donation_acknowledgements, controller: 'reports'
  end

  root 'welcome#index'
end
