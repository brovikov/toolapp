Rails.application.routes.draw do
  root to: "tools#index"

  resources :tools
  resource :github_webhooks, only: :create
end
