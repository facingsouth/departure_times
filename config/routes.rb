Rails.application.routes.draw do
  resources :searches, only: [:new, :create, :show]
end
