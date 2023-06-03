module Jsonapi
  class RoundResource < JSONAPI::Resource
    attributes :created_at

    has_one :course
    has_many :scorecards
    has_many :users

    filter :user_id, apply: lambda { |records, value, _options|
      records.joins(:scorecards).where(scorecards: { user_id: value.first })
    }

    filter :course_id, apply: lambda { |records, value, _options|
      records.where(course_id: value.first)
    }

    after_create do
      course = @model.course
      scorecards = @model.scorecards

      scorecards.each do |scorecard|
        course.holes.each do |hole|
          Turn.create!(hole:, scorecard:, par: hole.par, hole_number: hole.number)
        end
      end
    end

    def self.sortable_fields(context)
      super + [:created_at]
    end

    def self.apply_sort(records, _order_options, _context = {})
      records.by_date
    end
  end
end
