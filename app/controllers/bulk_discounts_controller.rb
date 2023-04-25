class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts
    @app_logo = PhotoBuilder.app_photo_info
    @holidays = HolidayBuilder.holidays
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
    @bulk_discount = @merchant.bulk_discounts.new(strong_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = "Please fill out information fields properly"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def edit
    @app_logo = PhotoBuilder.app_photo_info
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash[:alert] = "Please fill out information fields properly"
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end
  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def strong_params
    params.permit(:name, :percentage_discounts, :quantity_threshold)
  end
  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage_discounts, :quantity_threshold)
  end
end
