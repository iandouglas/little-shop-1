class Dashboard::DiscountsController < Dashboard::BaseController
  def index
    @discounts = current_user.my_discounts
  end

  def new
    @discount = Discount.new
    @items = current_user.items
  end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      redirect_to dashboard_discounts_path, success: "You have created a new discount for item #{@discount.item.item_name}"
    else
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(update_params)
      redirect_to dashboard_discounts_path, success: "Discount updated"
    else
      render :edit
    end
  end

  private

  def discount_params
    dp = params.require(:discount).permit(:item_id, :percentage, :min_quantity)
    dp[:percentage] = dp[:percentage].to_f / 100
    dp
  end

  def update_params
    up = params.require(:discount).permit(:percentage, :min_quantity)
    up.delete(:percentage) if up[:percentage].blank?
    up.delete(:min_quantity) if up[:min_quantity].blank?
    if up[:percentage]
      up[:percentage] = up[:percentage].to_f / 100
    end
    up
  end
end
