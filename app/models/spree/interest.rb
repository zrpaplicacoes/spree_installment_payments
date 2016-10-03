class Spree::Interest < ActiveRecord::Base
  belongs_to :payment_method


  def percentage
    "#{value.to_f.round(4) * 100}%"
  end

end
