Rails.application.routes.draw do

  root "pages#home"  # <- la page d’accueil va pointer vers pages#home
  get "/galerie", to: "pages#galerie"
  get "/a-propos", to: "pages#a_propos"
  get "/contact", to: "pages#contact"
  get "/new_york", to: "pages#new_york"
  get "/landscapes", to: "pages#landscapes"
  get "/streets", to: "pages#streets"
  get "/charmes", to: "pages#charmes"

end


