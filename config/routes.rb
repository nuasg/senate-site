Rails.application.routes.draw do
  root controller: :meetings, action: :index

  get '/display', controller: :main, action: :display

  resources :terms, except: [:show]

  resources :users, except: [:show]
  get '/users/roster', controller: :main, action: :roster

  resources :affiliations, except: [:show]

  resources :documents
  resources :meetings

  post '/documents/:id/open', controller: :documents, action: :open_voting
  post '/documents/:id/open_secret', controller: :documents, action: :open_secret
  post '/documents/:id/close', controller: :documents, action: :close_voting
  post '/documents/:id/reset', controller: :documents, action: :reset
  post '/documents/:id/vote/:vote', controller: :documents, action: :vote

  post '/meetings/:id/open', controller: :meetings, action: :open
  post '/meetings/:id/close', controller: :meetings, action: :close
  post '/meetings/:id/unclose', controller: :meetings, action: :unclose
  post '/meetings/:id/reset', controller: :meetings, action: :reset
  get '/meetings/:id/attendance', controller: :meetings, action: :attendance
  get '/meetings/:year/:quarter', controller: :meetings, action: :index

  get '/login', controller: :main, action: :login
  post '/login', controller: :main, action: :authenticate

  get '/logout', controller: :main, action: :logout
  post '/logout', controller: :main, action: :logout
end
