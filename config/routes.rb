Rails.application.routes.draw do
  resources :merchants do
    resources :items, controller: 'merchant/items'
    resources :invoices, controller: 'merchant/invoices'
    get 'dashboard', to:'merchant/dashboard#show', on: :member
    patch '/merchants/:merchant_id/items', to: 'merchant/items#update_status'
  end
end
