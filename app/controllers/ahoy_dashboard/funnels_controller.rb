module AhoyDashboard
  class FunnelsController < BaseController

    def index
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

