module Spree
  Payment.class_eval do
    validates :interest, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :installments, numericality: { greater_than_or_equal_to: 1 }


    def charge_interest_label
      if charge_interest
        klass = "label label-considered_safe"
      else
        klass = "label label-considered_risky"
      end

      ActionController::Base.helpers.content_tag(:span, Spree.t(charge_interest.to_s), class: klass)
    end

  end

end