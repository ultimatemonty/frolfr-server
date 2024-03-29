class Course < ApplicationRecord
  HOLE_COUNTS = (9..27).to_a
  PENDING_STATUS = 'pending'
  APPROVED_STATUS = 'approved'
  STATUSES = [PENDING_STATUS, APPROVED_STATUS].freeze

  has_many :holes, dependent: :destroy
  has_many :rounds
  has_many :reviews, dependent: :destroy
  has_many :photos, through: :rounds
  belongs_to :submitter, class_name: 'User'

  validates :state, :city, :country, :name, :status, presence: true
  validates_uniqueness_of :name, scope: :city
  validates :status, inclusion: STATUSES
  validates :state, inclusion: States.abbreviations

  scope :by_name, -> { order(:name) }
  scope :approved, -> { where(status: APPROVED_STATUS) }
  scope :available_to, ->(user) { where("courses.status = 'approved' OR courses.submitter_id = ?", user.id) }

  auto_strip_attributes :address, :name, :city, :state, squish: true

  geocoded_by :full_street_address
  after_validation :geocode

  def full_street_address
    [name, address, city, state, country].compact.join(', ')
  end

  def rated?
    rating.present?
  end

  # TODO: this is persisted because of bad naming. Will remove in Frolfr 2.0 launch
  def hole_count
    holes.count
  end

  def hole_one
    holes.find_by(number: '1')
  end

  def scorecards
    Scorecard
      .joins(:round)
      .where(rounds: { course_id: id })
  end
end
