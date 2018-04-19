Rails.application.routes.draw do
 	root 'grams#index'
  resource :grams, only: [:new, :create]
end
