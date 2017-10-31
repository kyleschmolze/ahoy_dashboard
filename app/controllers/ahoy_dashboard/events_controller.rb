module AhoyDashboard
  class EventsController < BaseController

    def index
      @start_date = 6.months.ago.beginning_of_day
      @end_date = DateTime.current
    end

    def names
      render json: Ahoy::Event.uniq.pluck(:name).sort.to_json
    end

    def keys
      name = params[:name]
      # should just use a cached list of all event names and confirm this is in them?
      if name.present? and Ahoy::Event.where(name: name).exists?
        render json: ActiveRecord::Base.connection.exec_query("SELECT DISTINCT JSON_OBJECT_KEYS(properties) AS key FROM ahoy_events WHERE id = id AND name = '#{name}';").rows.flatten.compact.sort.to_json
      else
        render json: []
      end
    end

    def values
      # should check all keys and confirm that this key is one of them
      name = params[:name]
      key = params[:key]
      if name.present? and key.present? and Ahoy::Event.where(name: name).exists?
        render json: Ahoy::Event.uniq.where(name: name).pluck("properties->>'#{key}'").compact.sort.to_json
      else
        render json: []
      end
    end

    def data
      @name = params[:name]
      @period = params[:period] || 'month'
      @uniqueness = params[:uniqueness] || 'total'
      @start_date = Date.parse(params[:start_date]).beginning_of_day rescue 6.months.ago.beginning_of_day
      @end_date = Date.parse(params[:end_date]).beginning_of_day rescue DateTime.current
      @events = Ahoy::Event.where(name: @name)
      @events = @events.where(time: @start_date..@end_date)

      if params[:key].present? and params[:value].present?
        @events = @events.where_properties(params[:key] => params[:value])
      end

      @explainer = @events.to_sql
      @events = @events.send("group_by_#{@period}", :time)

      if @uniqueness == 'total'
        @events = @events.count
      else
        @events = @events.joins(:ahoy_visit).uniq.count('visitor_token')
      end
      render layout: false
    end
  end
end
