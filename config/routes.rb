App::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'

      # Rutas para reports
      get 'reports/top_products_by_category', to: 'reports#top_products_by_category'
      get 'reports/top_revenue_products_by_category', to: 'reports#top_revenue_products_by_category'

      # Rutas para purchases sin nesting adicional
      get 'purchases', to: 'purchases#index'
      get 'purchases/count_by_granularity', to: 'purchases#count_by_granularity'
    end
  end
end
