Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  defaults format: :json do
    resources :books, only: %i[index show create destroy], param: :serial_number do
      resource :status, only: :update, controller: "book_statuses"
    end
  end
end
