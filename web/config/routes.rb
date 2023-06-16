Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect("admin/experiments")

  namespace :admin do
    resources :experiments, only: :index
    resources :device_tokens, only: :index

    get '/*path', controller: :base, action: :not_found
  end

  namespace :api do
    namespace :v1 do
      namespace :devices do
        resources :experiments, only: :index
      end

      match '/*path', controller: :base, action: :not_found, via: [:get, :post, :put, :patch, :delete]
    end
  end
end
