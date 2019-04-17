class Cart
  attr_reader :contents


  def initialize(contents)
    @contents = contents || Hash.new(0)
    @contents.default = 0
  end

  def items
    Item.where(id: @contents.keys)
  end

  def total_count
    @contents.values.sum if @contents
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def add_item(item_id)
    @contents[item_id.to_s] += 1
  end

  def subtotal(item)
    @contents[item.id.to_s] * item.current_price
  end

  def cart_total
    items.inject(0) do |total, item|
      total += subtotal(item)
    end
  end

  def regular_items(coupon)
    items.where.not(id: coupon.item_list)
  end

  def discount_items(coupon)
    items.where(id: coupon.item_list)
  end

  def discount_total(coupon)
    regular_total = regular_items(coupon).inject(0) {|total, item| total += subtotal(item)}
    if coupon.discount == "dollar"
      if (cart_total - regular_total - coupon.amount) < 0
        regular_total
      else
        cart_total - coupon.amount
      end
    elsif coupon.discount == "percent"
      if coupon.amount < 100
        discount_total = discount_items(coupon).inject(0) {|total, item| total += subtotal(item)*(coupon.percent_off)}
      else
        discount_total = 0
      end
      discount_total + regular_total
    end
  end

end
