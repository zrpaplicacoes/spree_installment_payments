module Spree
  class ZoneInterest < ActiveRecord::Base
    # relations
    belongs_to :zone

    # validations
    validates :start_number_of_installments, :end_number_of_installments, :zone_id, :interest, presence: true

    # validates :start_number_of_installments, numericality: { less_than: start_number_of_installments }
    # validates :end_number_of_installments, numericality: { less_than_or_equal_to: max_number_of_installments }
    validates :interest, numericality: { less_than_or_equal_to: 1, greater_than: 0 }

    validate :overlapping_interests

    # methods
    def overlapping_interests
      &&  && !(min_range..max_range).overlaps?(start_number_of_installments..end_number_of_installments)
    end

    private

    def has_range?
      start_number_of_installments < end_number_of_installments
    end

    def

    end

    def min_range
      Spree::ZoneInterest.where(spree_zone_id: spree_zone_id).minimum(:start_number_of_installments) || 0
    end

    def max_range
      Spree::ZoneInterest.where(spree_zone_id: spree_zone_id).maximum(:end_number_of_installments) || max_number_of_installments
    end

    def max_number_of_installments
      zone ? Spree::Zone.where(id: spree_zone_id).max_number_of_installments : 0
    end

  end
end
