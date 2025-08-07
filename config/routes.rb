Rails.application.routes.draw do

  # / Menu
  root "pages#home"
  get "/collections", to: "pages#collections"
  get "/fragments", to: "pages#fragments"
  get "/a-propos", to: "pages#a_propos"
  get "/contact", to: "pages#contact"

  # / Gimix Collections
  get "/silenthorizons", to: "pages#silenthorizons"
  get "/willow_and_stone", to: "pages#willow_and_stone"
  get "/metropolitan", to: "pages#metropolitan"
  get "/velvetreverie", to: "pages#velvetreverie"

  # / Collections Globales
  get "/spirituals", to: "pages#spirituals"
  get "/lifestyles", to: "pages#lifestyles"
  get "/interiors", to: "pages#interiors"
  get "/commercials", to: "pages#commercials"
end


