Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  post 'urls/encode', to: 'urls#encode'
  get 'urls/decode', to: 'urls#decode'
  get ':short_code', to: 'redirects#show'

  # Just temporary hotfix for CVE-2018-10561
  match '/GponForm/diag_Form', to: 'application#malicious_request', via: :all
end
