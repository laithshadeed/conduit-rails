Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    post 'users', to: 'users#create'
    get 'user', to: 'users#show'
    put 'user', to: 'users#update'
    post 'users/login', to: 'users#login'
    get 'profiles/:username', to: 'users#profile'
    post 'profiles/:username/follow', to: 'users#follow'
    delete 'profiles/:username/follow', to: 'users#unfollow'
    resources :tags
    resources :articles do
      resources :comments
    end
  end
end
