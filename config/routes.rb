Studimetrics::Application.routes.draw do

  resources :topics

  resources :users
  namespace 'admin' do
    resources :books
    resources :users
    resources :practice_tests
    resources :topics
  end
  get '/admin', to: 'admin/dashboard#show', as: 'admin'

  root :to => 'high_voltage/pages#show', :id => 'home'

end
