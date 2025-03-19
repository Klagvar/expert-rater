=begin
Rails.application.routes.draw do
  get "sessions/new"
  get "work/index"
  get "work/choose_theme"
  get "work/display_theme"
  resources :values
  resources :themes
  resources :images
  resources :users
  get "main/index"
  get "main/help"
  get "main/contacts"
  get "main/about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.slim)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  #root "main#index"

  root "work#index" # Временный корневой путь

  get "work", to: "work#index"
  get "choose_theme", to: "work#choose_theme"
  post "display_theme", to: "work#display_theme"
end
=end
Rails.application.routes.draw do
  root "work#index"

  # WorkController
  get "work", to: "work#index"
  get "choose_theme", to: "work#choose_theme"
  post "display_theme", to: "work#display_theme"

  # API Routes
  namespace :api do
    get "next_image", to: "api#next_image"
    get "prev_image", to: "api#prev_image"
  end

  # Маршруты для аутентификации
  get 'signup', to: 'sessions#signup'       # Форма регистрации
  post 'signup', to: 'sessions#create_user'   # Обработка регистрации
  get 'signin', to: 'sessions#new'    # Форма входа
  post 'signin', to: 'sessions#create' # Обработка входа
  delete 'signout', to: 'sessions#destroy' # Выход
  get 'profile', to: 'sessions#profile'

  # Остальные ресурсы
  resources :values, :themes, :images, :users

  # MainController
  get "main/index", "main/help", "main/contacts", "main/about"
end