module Boostify
  module Models
    module ActiveRecord
      module Charity
        extend ActiveSupport::Concern

        included do
          monetize :income_cents, with_currency: Boostify::CURRENCY
        end

        private

          def advocate_count
            donations.uniq.count(:user_id)
          end

          def calculate_income
            Money.new donations.sum(:commission_cents), Boostify::CURRENCY
          end
      end
    end
  end
end
