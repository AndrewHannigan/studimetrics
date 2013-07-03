Studimetrics::Application.routes.draw do

  resources :users, only: [:create]
  resource :profile
  resources :practice_tests, only: [:index]
  resources :sections, only: [:show]
  resources :section_completions, only: [:new, :create, :update] do
    member do
      get :review
    end
  end
  resources :user_responses, only: [:create]

  # admin routes
  namespace 'admin' do
    resources :colleges
    resources :books
    resources :users
    resources :practice_tests do
      resources :sections
    end
    resources :sections do
      resources :questions
    end
    resources :subjects
    resources :topics
    resources :questions do
      resources :answers
    end
  end
  get '/admin', to: 'admin/dashboard#show', as: 'admin'

  root :to => 'high_voltage/pages#show', :id => 'home'

end
