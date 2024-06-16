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
  end

  resources :categories, except: [:show]

  resources :meal_bookings, except: [:show] do
    collection do
      get :calendar
      get :meal_bookings_for_the_day
    end
  end

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
    get :form_10bd, controller: 'reports'
    get :foreign_donations, controller: 'reports'
  end

  root 'welcome#index'
end
