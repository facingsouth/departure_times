class Search < ActiveRecord::Base
  validates :origin, :destination,
            :presence => true

  validate :waypoint_must_can_be_found

  before_create :to_uppercase

  def search_result
    @transit ||= GoogleDirection.new(self.origin, self.destination)
    data = @transit.data_parser
    return data
  end

  private

  def to_uppercase
    self.origin.upcase!
    self.destination.upcase!
  end

  def waypoint_must_can_be_found
    @transit ||= GoogleDirection.new(self.origin, self.destination)
    error_status = @transit.data_parser[:status]
    if error_status
      errors.add(:origin, error_status)
      errors.add(:destination, error_status)
    end
  end
end
