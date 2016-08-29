module Spree
  class Interest

    class UndefinedZone < StandardError; end

    def initialize args
      setup(args[:order])
    end

    def applicable?
      # all selected payment methods accept installments
      @order.payments.all? { |payment| installment?(payment) }
    end

    def retrieve
      # if applicable?
    end

    private

    def setup(order)
      @order = order
      @zones = zones
      raise UndefinedZone if @zones.empty?
    end

    def installment?(payment)
      payment.accept_installments? &&
      payment.max_number_of_installments > 1 &&
      payment.installments > 1
    end

    def zones
      order_zones = @order.billing_address.country.zones | @order.billing_address.state.zones if @order.billing_address

      order_zones.present? ? order_zones : []
    end

    def zone_interest_for_payment_installments(zone, number_of_installments)
      zone.find_interest_for(number_of_installments)
    end

  end
end
