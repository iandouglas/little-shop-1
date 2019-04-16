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

  private

  def discount_params
    dp = params.require(:discount).permit(:item_id, :percentage, :min_quantity)
    dp[:percentage] = dp[:percentage].to_f / 100
    dp
  end
end
