class Merchant::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
    @app_logo = PhotoBuilder.app_photo_info
    @title_string = @merchant.name
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = @merchant.invoices.find(params[:id])
    @invoice_items = @merchant.invoice_items
    @app_logo = PhotoBuilder.app_photo_info
    @title_string = "#{@merchant.name}"
    @total_discounted_revenue = @invoice.total_discounted_revenue
    # require 'pry'; binding.pry
    @discount = @merchant.bulk_discounts
  end
end