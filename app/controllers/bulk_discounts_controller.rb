class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts
    @app_logo = PhotoBuilder.app_photo_info
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @app_logo = PhotoBuilder.app_photo_info
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @app_logo = PhotoBuilder.app_photo_info
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = "Please fill out information fields properly"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def bulk_discount_params
    params.permit(:name, :percentage_discounts, :quantity_threshold)
  end
end
