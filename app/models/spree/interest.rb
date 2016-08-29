module Spree
  class Interest
    def initialize args
      setup(args[:order])
    end

    def applicable?
      # all selected payment methods accept installments
      @order.payments.all? { |payment| payment.accept_installments? }
    end

    def retrieve
      if applicable?
    end

    private

    def setup(order)
      @order = order
      @zones = zones
    end

    def zones
      address = @order.billing_address
      order_zones = address.country.zones | address.state.zones if @billing_address
      order_zones.present? ? order_zones : []
    end

    def zone_interest_for_payment_installments(zone, number_of_installments)
      zone.find_interest_for(number_of_installments)
    end

  end
end
