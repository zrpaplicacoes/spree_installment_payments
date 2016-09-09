module Spree
  class ZoneInterest < ActiveRecord::Base
    # relations
    belongs_to :zone
    belongs_to :payment_method

    # validations
    validates :start_number_of_installments, :end_number_of_installments, :zone_id, :interest, presence: true

    validates :start_number_of_installments, numericality: { greater_than: 0, only_integer: true }
    validates :interest, numericality: { less_than_or_equal_to: 1, greater_than: 0 }

    validates :name, uniqueness: { allow_blank: true }

    validate :range
    validate :inside_zone_limits
    validate :overlapping_interests

    # methods
    def range
      errors.add(:start_number_of_installments, I18n.t('activerecord.errors.invalid_range', start: start_number_of_installments, end: end_number_of_installments)) unless has_range?
    end

    def inside_zone_limits
      errors.add(:end_number_of_installments, I18n.t('activerecord.errors.limit_overflow', value: end_number_of_installments, limit: max_number_of_installments)) unless range_inside_zone_installments_limit?
    end

    def overlapping_interests
      errors.add(:start_number_of_installments, I18n.t('activerecord.errors.overlap', interval: "(#{min_range}, #{max_range})", defined_interval: "(#{start_number_of_installments},#{end_number_of_installments})")) if (min_range..max_range).overlaps?(start_number_of_installments..end_number_of_installments)
    end

    def fit? number_of_installments
      number_of_installments.between?(start_number_of_installments,end_number_of_installments)
    end

    def to_hash_range
      { range: [start_number_of_installments,end_number_of_installments], interest: interest }
    end

    private

    def has_range?
      start_number_of_installments < end_number_of_installments if start_number_of_installments.present? && end_number_of_installments.present?
    end

    def range_inside_zone_installments_limit?
      end_number_of_installments  <= max_number_of_installments
    end

    def min_range
      Spree::ZoneInterest.where(zone_id: zone_id, payment_method: payment_method_id).where.not(id: self.id).minimum(:start_number_of_installments) || 0
    end

    def max_range
      Spree::ZoneInterest.where(zone_id: zone_id, payment_method: payment_method_id).where.not(id: self.id).maximum(:end_number_of_installments) || 0
    end

    def max_number_of_installments
      zone ? zone.max_number_of_installments : 0
    end

  end
end
