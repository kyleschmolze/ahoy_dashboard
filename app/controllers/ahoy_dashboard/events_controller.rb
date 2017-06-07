module AhoyDashboard
  class EventsController < BaseController

    def index
      @all_event_names = Ahoy::Event.uniq.pluck(:name).sort
      @event_name = params[:event_name] || '$view'
      @period = params[:period] || 'month'
      @uniqueness = params[:uniqueness] || 'total'
      @start_date = Date.parse(params[:start_date]).beginning_of_day rescue 6.months.ago.beginning_of_day
      @end_date = Date.parse(params[:end_date]).beginning_of_day rescue DateTime.current
      @events = Ahoy::Event.where(name: @event_name)
      @events = @events.where(time: @start_date..@end_date)

      @key = params[:property_key]
      @value = params[:property_value]

      @keys = ActiveRecord::Base.connection.exec_query("SELECT DISTINCT JSON_OBJECT_KEYS(properties) AS key FROM ahoy_events WHERE id = id AND name = '#{@event_name}';").rows.flatten
      if @key
        @values = @events.uniq.pluck("properties->>'#{@key}'")
      end

      if @key and @value
        @events = @events.where_properties(@key => @value)
      end
      
      @events = @events.send("group_by_#{@period}", :time)

      if @uniqueness == 'total'
        @events = @events.count
      else
        @events = @events.joins(:ahoy_visit).pluck(:visitor_token).uniq.count
      end
    end

    def funnels
      @all_event_names = Ahoy::Event.uniq.pluck(:name).sort

      @first_event = params[:first_event]
      @second_event = params[:second_event]
      @start_date = Date.parse(params[:start_date]).beginning_of_day rescue 6.months.ago.beginning_of_day
      @end_date = Date.parse(params[:end_date]).beginning_of_day rescue DateTime.current
      first = Ahoy::Event.where(time: @start_date..@end_date).where(name: @first_event).joins(:ahoy_visit).uniq.pluck(:visitor_token)
      second = Ahoy::Event.where(time: @start_date..@end_date).where(name: @second_event).joins(:ahoy_visit).where(ahoy_visits: { visitor_token: first }).uniq.count

      @data = [ [@first_event , first.count], [@second_event , second ] ]
    end
  end
end
