Rails.application.routes.draw do
  devise_for :users, controllers:{
  	omniauth_callbacks: "users/omniauth_callbacks"
  }

  # post "/custom_sign_up", to: "users/omniauth_callbacks#custom_sign_up"

  devise_scope :user do post "/custom_sign_up" => "users/omniauth_callbacks#custom_sign_up"
  end

  root 'main#home'

   # 1 Mandar información a facebook
   # 2 si es Si, Facebook retorna a nuestra app callback_url
   # 3 procesar la info de facebook
   # Autenticar o crear nuevo usuario

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
