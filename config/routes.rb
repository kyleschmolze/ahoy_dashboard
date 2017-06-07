AhoyDashboard::Engine.routes.draw do
  resources :events, only: [:index]
  resources :funnels, only: [:index]
  root "events#index"
end

