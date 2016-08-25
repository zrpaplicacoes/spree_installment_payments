module Spree
  class ZoneInterest < ActiveRecord::Base
    # relations
    belongs_to :spree_zone

    # aliasing
    alias_method :zone, :spree_zone
    delegate :max_number_of_installments, to: :zone

    # validations
    validates :start_number_of_installments, :end_number_of_installments, :spree_zone_id, :interest, presence: true

    validates :start_number_of_installments, numericality: { less_than: start_number_of_installments }
    validates :end_number_of_installments, numericality: { less_than_or_equal_to: max_number_of_installments }
    validates :interest, numericality: { less_than_or_equal_to: 1, greater_than: 0 }

    validate :overlapping_interests

    # methods
    def overlapping_interests
      (min_range..max_range).overlaps?(start_number_of_installments..end_number_of_installments)
    end

    private

    def min_range
      Spree::ZoneInterest.min(:start_number_of_installments) || 0
    end

    def max_range
      Spree::ZoneInterest.max(:end_number_of_installments) || max_number_of_installments
    end

  end
end
