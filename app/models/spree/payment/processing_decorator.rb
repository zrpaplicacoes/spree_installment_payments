module Spree
  class Payment
    module ProcessingDecorator

      def capture!(amount = nil)
        return true if completed?
        byebug
        amount ||= money.money.cents
        started_processing!
        protect_from_connection_error do
          response = payment_method.capture(
            amount,
            response_code,
            gateway_options
          )
          money = ::Money.new(amount, currency)
          capture_events.create!(amount: money.to_f)
          split_uncaptured_amount
          handle_response(response, :complete, :failure)
        end
      end

      def process_purchase
        started_processing!
        result = gateway_action(source, :purchase, :complete)
        # This won't be called if gateway_action raises a GatewayError
        capture_events.create!(amount: amount_with_interest)
      end
    end

    module Processing
      prepend ProcessingDecorator
    end
  end
end
