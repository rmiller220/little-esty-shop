require 'json'
require 'httparty'
require './app/poros/holiday.rb'
require './app/services/holiday_service.rb'

class HolidayBuilder
  def self.service
    HolidayService.new
  end

  def self.holidays
    Holiday.new(service.holidays)
  end
end