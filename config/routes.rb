Rails.application.routes.draw do
  # static redirects
  get '/shadow-log/patroller', to: redirect('https://airtable.com/shriJDxEwrORVr9El')
  get '/shadow-log/candidate', to: redirect('https://airtable.com/shrRpyRyxydNcLuEf')

  # always use schedule (makes the Auto0 stuff work a little better)
  unless Rails.env.development?
    constraints subdomain: false do
      get ':any', to: redirect(subdomain: 'schedule', path: '/%{any}'), any: /.*/
    end
  end

  resources :commitments, only: [:index, :show, :create, :destroy] do
    collection do
      post 'notify_early'
      post 'notify_today'
    end
  end

  resources :identities, only: [:index, :show, :update, :destroy]
  resources :users do
    member do
      get 'commitments'
      get 'commitments_ics'
      put 'suspend'
      put 'unsuspend'
    end
  end

  # auth0
  post '/login' => 'auth0#login'
  post '/logout' => 'auth0#logout'
  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/auth0/verify_email' => 'auth0#verify_email'
  get '/auth/auth0/password_reset' => 'auth0#password_reset'

  # static
  # get '/*id' => 'pages#show', as: :page, format: false

  # root
  root 'pages#show', id: 'home'
end
