Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect("admin/experiments")

  namespace :admin do
    resources :experiments, only: :index
    resources :device_tokens, only: :index
  end

  namespace :api do
    namespace :v1 do
      namespace :devices do
        resources :experiments, only: :index
      end
    end
  end
end
