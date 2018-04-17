class Item
  def initialize(item_data)
    @name    = item_data.fetch(:name)
    @quality = item_data.fetch(:quality)
    @sell_in = item_data.fetch(:sell_in)
  end

  def to_hash
    {
      name:    @name,
      sell_in: @sell_in,
      quality: @quality
    }
  end

  def update_item
    return aged_item if @name.downcase =~ /aged/
    return backstage_item if @name.downcase =~ /backstage/
    return sulfuras_item if @name.downcase =~ /sulfuras/
    return conjured_item if @name.downcase =~ /conjured/
    normal_item
    self
  end

  private

  def aged_item
    update_quality if valid_quality(1, 49)
    update_sell_in
    update_quality if valid_quality(1, 49) if after_sell_in?
    self
  end

  def backstage_item
    update_quality if valid_quality(1, 49)
    update_quality if valid_quality(1, 49) if @sell_in < 11
    update_quality if valid_quality(1, 49) if @sell_in < 6
    @quality = 0  if after_sell_in?
    update_sell_in
    self
  end

  def sulfuras_item
    self
  end

  def conjured_item
    update_quality(-2) if valid_quality(2, 50)
    update_sell_in
    update_quality(-2) if valid_quality(2, 50) if after_sell_in?
    self
  end

  def normal_item
    update_quality(-1) if valid_quality(1,50)
    update_sell_in
    update_quality(-1) if valid_quality(1,50) if after_sell_in?
    self
  end

  def valid_quality(min, max)
    return @quality.between?(min, max)
  end

  def update_sell_in
    @sell_in -= 1
  end

  def update_quality(val=1)
    @quality += val
  end

  def after_sell_in?
    @sell_in <= 0
  end
end


def update_quality(items)
  items.map do |item_data|
    Item.new(item_data).update_item.to_hash
  end
end
