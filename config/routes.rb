Rails.application.routes.draw do
  root controller: :meetings, action: :index

  get '/display', controller: :main, action: :display

  get '/management/roster', controller: :management, action: :view_roster

  get '/management/terms/new', controller: :management, action: :new_term
  get '/management/terms', controller: :management, action: :view_terms
  post '/management/terms', controller: :management, action: :create_term
  delete '/management/terms/:id', controller: :management, action: :destroy_term

  resources :users, path: '/management/users'
  resources :affiliations, path: '/management/affiliations'

  get '/login', controller: :main, action: :login
  post '/login', controller: :main, action: :authenticate

  get '/logout', controller: :main, action: :logout
  post '/logout', controller: :main, action: :logout

  resources :documents
  resources :meetings

  get '/meetings/:id', controller: :meetings, action: :show
  post '/meetings/:id/open', controller: :meetings, action: :open
  post '/meetings/:id/close', controller: :meetings, action: :close
  get '/meetings/:id/attendance', controller: :meetings, action: :attendance
  patch '/meetings/:id/attendance/:time', controller: :meetings, action: :update_attendance
  get '/meetings/:year/:quarter', controller: :meetings, action: :index
end
