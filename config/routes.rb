Studimetrics::Application.routes.draw do

  resources :users

  namespace 'admin' do
    resources :books
    resources :users
    resources :practice_tests do
      resources :sections
    end
    resources :sections do
      resources :questions
    end
    resources :topics
    resources :questions do
      resources :answers
    end
  end
  get '/admin', to: 'admin/dashboard#show', as: 'admin'

  root :to => 'high_voltage/pages#show', :id => 'home'

end
