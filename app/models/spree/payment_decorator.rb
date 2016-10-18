module Spree
  Payment.class_eval do
    validates :interest, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :installments, numericality: { greater_than_or_equal_to: 1 }
  end

end