Rails.application.routes.draw do
  root to: 'vue_crud_data#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :vue_crud_data, only: [:index, :new, :create, :update, :destroy]

  # get 'vue_crud_data/index'
  get    'vue_crud_data/index'
  get    'vue_crud_data/new',  to: 'vue_crud_data#new',     as: 'new_vue_crud_data'
  post   'vue_crud_data',      to: 'vue_crud_data#create'
  put    'vue_crud_data/:id',  to: 'vue_crud_data#update'
  delete 'vue_crud_data/:id',  to: 'vue_crud_data#destroy'
end
