Rails.application.routes.draw do
  root 'index#index'
  devise_for :users, :skip => :all
  as :user do
    get    "/account/sign_in"  => "sessions#new"
    post   "/account/sign_in"  => "sessions#create"
    delete "/account/sign_out" => "sessions#destroy"
  end
end
