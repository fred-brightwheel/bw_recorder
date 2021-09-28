Rails.application.routes.draw do
  post '/readings', to: 'readings#create'
  get '/devices/:id/total_count', to: 'devices#total_count'
  get '/devices/:id/latest_count', to: 'devices#latest_count'
end
