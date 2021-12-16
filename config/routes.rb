Rails.application.routes.draw do
  patch '/bulk', to: 'bulk#operations'
end
