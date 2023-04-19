require 'photo_builder'
class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @enabled_items = @merchant.items.enabled_items
    @disabled_items = @merchant.items.disabled_items
    @top_five = @merchant.items.top_five_items
    @app_logo = PhotoBuilder.app_photo_info
    @title_string = @merchant.name
  end

  def show
    @item = Item.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @item_photo = PhotoBuilder.item_photo_info(@item.name)
    @app_logo = PhotoBuilder.app_photo_info
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @app_logo = PhotoBuilder.app_photo_info
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new(item_params)
    if @item.save
      @item.status = 0
      redirect_to merchant_items_path(@merchant)
    else
      flash[:alert] = "Please fill out information fields properly"
      redirect_to new_merchant_item_path(@merchant)
    end
  end

  def edit
    @item = Item.find(params[:id])
    @app_logo = PhotoBuilder.app_photo_info
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      if !params[:status].nil?
        redirect_to merchant_items_path(@item.merchant)
      else
        redirect_to merchant_item_path(@item.merchant, @item)
      end
    else
      flash[:alert] = "Please fill out information fields properly"
      redirect_to edit_merchant_item_path(@item.merchant, @item)
    end
  end



  def item_params
    params.permit(:name, :description, :unit_price, :status)
  end
end
