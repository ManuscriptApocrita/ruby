Rails.application.routes.draw do
  get "tasks/table", to: "tasks#table", as: "table"
  root to: "tasks#index"
  resources :tasks
end
