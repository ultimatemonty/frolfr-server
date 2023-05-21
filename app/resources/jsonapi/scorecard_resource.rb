module Jsonapi
  class ScorecardResource < JSONAPI::Resource
    attributes :created_at, :round_id

    has_many :turns
    has_one :user

    # def self.apply_sort(records, _order_options, _context = {})
    #   records.by_date
    # end
  end
end
