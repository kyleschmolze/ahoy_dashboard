module AhoyDashboard
  class BaseController < ActionController::Base
    layout "ahoy_dashboard/application"

    protect_from_forgery

    http_basic_authenticate_with name: ENV["AHOY_DASHBOARD_USERNAME"], password: ENV["AHOY_DASHBOARD_PASSWORD"] if ENV["AHOY_DASHBOARD_PASSWORD"]
  end
end

