class Spree::Interest < ActiveRecord::Base
  belongs_to :payment_method

  validates :number_of_installments, uniqueness: { scope: :payment_method }
  validates :number_of_installments, numericality: { greater_than_or_equal_to: 1 }
  validates :value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  def percentage
    "#{value.to_f.round(4) * 100}%"
  end

end
