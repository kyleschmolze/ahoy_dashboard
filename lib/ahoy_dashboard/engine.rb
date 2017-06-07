module AhoyDashboard
  class Engine < ::Rails::Engine
    isolate_namespace AhoyDashboard

    # prevents conflict with ahoy_dashboard method in views
    engine_name "ahoy_dashboard_engine"
  end
end

