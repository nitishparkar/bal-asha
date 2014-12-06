Rails.application.routes.draw do

  get 'welcome/index'

  devise_for :people

  root 'welcome#index'

end
