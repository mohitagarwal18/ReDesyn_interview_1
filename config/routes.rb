Rails.application.routes.draw do

  

  get '/log' => 'logs#log_file'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
