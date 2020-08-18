Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts, except: [:show] do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy, :edit, :update]
  end

  resources :users, except: [:index] do
    resources :friendships, only: [:create, :destroy, :index] do
      member do
        post 'accept'
        delete 'remove'
      end
    end
  end


  root to: 'posts#index'

end
