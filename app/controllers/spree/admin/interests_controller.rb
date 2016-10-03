module Spree
  module Admin
    class InterestsController < ResourceController
      before_action :load_data, except: [:index]

      private

      def collection
        params[:q] ||= {}
        params[:q][:s] ||= "name asc"
        @search = super.ransack(params[:q])
        @zone_interests = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        @payment_methods = PaymentMethod.order(:name)
        @interests = Interest.order(:name)
      end

    end

  end
end
