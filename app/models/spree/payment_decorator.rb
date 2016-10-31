module Spree
  module PaymentDecorator

    def charge_interest_label
      if charge_interest
        klass = "label label-considered_safe"
      else
        klass = "label label-considered_risky"
      end

      ActionController::Base.helpers.content_tag(:span, Spree.t(charge_interest.to_s), class: klass)
    end

    def amount
      super * interest_adjustment
    end

    def interest_adjustment
      begin
        update_self_if_processing

        if self.interest.present? && !self.interest.zero?
          if saved_installments.present? && saved_installments > 1
            (1.0 + self.interest)**saved_installments
          else
            (1.0 + self.interest)
          end
        else
          1.0
        end
      rescue
        1.0
      end
    end

    def has_charge_interest?
      if self.state == "processing"
        self.payment_method.accept_installments? ? self.payment_method.charge_interest : false
      else
        self.charge_interest || false
      end
    end

    def saved_installments
      if self.state == "processing"
        self.payment_method.accept_installments ? (self.installments || 1) : 1
      else
        self.installments || 1
      end
    end

    def update_self_if_processing
      if self.state == "processing"
        payment_interest = self.payment_method.interest_value_for(installments)
        payment_method_charge_interest = self.payment_method.charge_interest
        self[:interest] = payment_interest
        self[:charge_interest] = payment_method_charge_interest
      end
    end
  end

  Payment.class_eval do
    prepend Spree::PaymentDecorator

    validates :interest, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :installments, numericality: { greater_than_or_equal_to: 1 }

  end

end