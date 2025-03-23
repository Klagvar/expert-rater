Rails.application.routes.draw do
  # Глобальные API-маршруты (без локали)
  namespace :api do
    get "next_image", to: "api#next_image"
    get "prev_image", to: "api#prev_image"
    post "rate_image", to: "api#rate_image"
  end

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "work#index"

    # WorkController
    get "work", to: "work#index"
    get "choose_theme", to: "work#choose_theme"
    post "display_theme", to: "work#display_theme"
    get 'best_images', to: 'best_images#index'

    # Маршруты для аутентификации
    get 'signup', to: 'sessions#signup'
    post 'signup', to: 'sessions#create_user'
    get 'signin', to: 'sessions#new'
    post 'signin', to: 'sessions#create'
    delete 'signout', to: 'sessions#destroy'
    get 'profile', to: 'sessions#profile'

    # Остальные ресурсы
    resources :values, :themes, :images, :users

    # MainController
    get "main/index"
    get "main/help"
    get "main/contacts"
    get "main/about"
  end

  # Глобальный маршрут для переключения локали
  get 'toggle_locale', to: 'application#toggle_locale'
end