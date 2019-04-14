class Dashboard::ItemsController < ApplicationController
  before_action :require_merchant

  def new
    @item = Item.new
  end

  def create
    # item_params[:image_url] ||= #default image
    @item = Item.new(item_params)
    if @item.save
      session[:item_id] = @item.id
      redirect_to dashboard_items_path, success: "Item #{@item.id} has been created"
    else
      render :new
    end
  end

  def index
    @items = Item.merchant_items(current_user).order(:item_name)
  end

  def edit
    @item = Item.find_by_slug(params[:id])
  end

  def update
    @item = Item.find_by_slug(params[:id])
    if @item.update(update_item_params)
      redirect_to dashboard_items_path, success: "Item #{@item.id} has been updated"
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find_by_slug(params[:id]).delete
    redirect_to dashboard_items_path, danger: "Item #{@item.id} has been deleted"
  end

  def deactivate
    @item = Item.find_by_slug(params[:id])
    @item.update(enabled: false)
    redirect_to dashboard_items_path,  danger: "Item #{@item.id} has been disabled"
  end

  def activate
    @item = Item.find_by_slug(params[:id])
    @item.update(enabled: true)
    redirect_to dashboard_items_path, success: "Item #{@item.id} has been enabled"
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end

  def item_params
    ip = params.require(:item).permit(:item_name,
                                 :description,
                                 :image_url,
                                 :current_price,
                                 :inventory,
                                 :slug).merge(user_id: current_user.id)
    create_item_slug(ip)
    ip
  end

  def update_item_params
    ip = params.require(:item).permit(:item_name,
                                 :description,
                                 :image_url,
                                 :current_price,
                                 :inventory,
                                 :slug).merge(user_id: current_user.id)
    create_item_slug(ip) unless params[:item][:item_name].blank?
    ip.delete(:item_name) if ip[:item_name].blank?
    ip
  end
