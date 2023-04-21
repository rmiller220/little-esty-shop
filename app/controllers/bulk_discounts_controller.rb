class BulkDiscountsController < ApplicationController

  def index
    # require 'pry'; binding.pry
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts
    @app_logo = PhotoBuilder.app_photo_info
  end

  def show
    # puts "params[:id] = #{params[:id]}]"
    # require 'pry'; binding.pry
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @app_logo = PhotoBuilder.app_photo_info
  end
end
