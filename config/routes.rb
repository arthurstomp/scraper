Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }

  get '/quotes/:tag', to: 'tags#show', as: 'tag_quotes'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
