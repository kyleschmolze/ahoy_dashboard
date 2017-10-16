AhoyDashboard::Engine.routes.draw do
  get 'events', to: 'events#index', as: :events
  get 'events/names', to: 'events#names', as: :event_names
  get 'events/keys', to: 'events#keys', as: :event_keys
  get 'events/values', to: 'events#values', as: :event_values

  resources :funnels, only: [:index]
  root "events#index"
end

