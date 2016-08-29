module Spree
  Zone.class_eval do
    has_many :zone_interests

    alias_method :interests, :zone_interests

    validates :max_number_of_installments, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }

    validates :base_value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100000 }

    def has_installments?
      max_number_of_installments.present? && max_number_of_installments > 1
    end

    def find_interest_for number_of_installments
      interests.find { |interest| interest.fit?(number_of_installments) }
    end

  end
end
