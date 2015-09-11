Rails.application.routes.draw do
  root to: "searches#new"
  resources :searches, only: [:new, :create, :show]
end
