class Spree::Interest < ActiveRecord::Base
  belongs_to :spree_payment_method
end
