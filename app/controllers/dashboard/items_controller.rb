class Dashboard::ItemsController < Dashboard::BaseController

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
    @items = Item.merchant_items(current_user)
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to dashboard_items_path, success: "Item #{@item.id} has been updated"
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id]).delete
    redirect_to dashboard_items_path, danger: "Item #{@item.id} has been deleted"
  end

  def deactivate
    @item = Item.find(params[:id])
    @item.update(enabled: false)
    redirect_to dashboard_items_path,  danger: "Item #{@item.id} has been disabled"
  end

  def activate
    @item = Item.find(params[:id])
    @item.update(enabled: true)
    redirect_to dashboard_items_path, success: "Item #{@item.id} has been enabled"
  end

  private


  def item_params
    params.require(:item).permit(:item_name,
                                 :description,
                                 :image_url,
                                 :current_price,
                                 :inventory).merge(user_id: current_user.id)
  end


end
