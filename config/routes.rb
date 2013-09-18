require 'sidekiq/web'
Studimetrics::Application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  resources :users, controller: 'users', only: [:create] do
    member do
      put :deactivate
    end
  end
  resource :profile

  resources :practice_tests, only: [:index] do
    resource :next_section_for_test, only: [:new]
    member do
      get :next
    end
  end

  resources :score_report_emails, only: [:create, :destroy]

  resources :colleges, only: [:index]
  resources :sections, only: [:show]
  resources :section_completions, only: [:new, :create, :update, :show]
  resources :user_responses, only: [:create]
  resources :concepts, only: [:index, :show]
  resources :concept_videos do
    member do
      post :track
    end
  end
  resource :settings

  # admin routes
  namespace 'admin' do
    resources :concept_videos
    resources :concepts
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
    resources :questions do
      resources :answers
    end
  end

  get '/admin', to: 'admin/dashboard#show', as: 'admin'

  constraints Clearance::Constraints::SignedIn.new do
    get '/', to: 'profiles#show'
  end

  resource :contact_us, only: [:create]

  if Rails.env.development?
    mount MailPreview => 'mail_preview'
  end

  root :to => 'high_voltage/pages#show', :id => 'home'

end
