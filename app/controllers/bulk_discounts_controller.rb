class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_disount = @merchant.bulk_discounts
    @app_logo = PhotoBuilder.app_photo_info
  end
end
