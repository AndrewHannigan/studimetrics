Studimetrics::Application.routes.draw do
  resources :books

  resources :users
  namespace 'admin' do
    resources :books
    resources :users
  end
  get '/admin', to: 'admin/dashboard#show', as: 'admin'

  root :to => 'high_voltage/pages#show', :id => 'home'
end
