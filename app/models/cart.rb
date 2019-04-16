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
    quantity = @contents[item.id.to_s]
    if item.qualify_for_discount?(quantity)
      biggest_eligible_dc = item.max_eligible_discount(quantity)
      st = (quantity * item.current_price ) * (1 - biggest_eligible_dc.percentage)
    else
      st = quantity * item.current_price
    end
    st
  end

  def cart_total
    items.inject(0) do |total, item|
      total += subtotal(item)
    end

  end

end
