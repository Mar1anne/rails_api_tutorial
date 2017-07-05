class Order < ApplicationRecord
  belongs_to :user

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true

  before_validation :set_total!

  has_many :placements
  has_many :products, through: :placements

  def set_total!
    self.total = products.map(&:price).sum
  end

  def build_placements_with_product_ids_and_quantities(ids_and_quantities)
    ids_and_quantities.each do |id_and_quantity|
      id, quantity = id_and_quantity
      placements.build(product_id: id)
    end
  end
end
