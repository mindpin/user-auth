Rails.application.routes.draw do
  root 'index#index'
  post "/login"  => "index#login"
  get  "/logout" => "index#logout"
end
