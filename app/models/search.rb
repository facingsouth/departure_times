class Search < ActiveRecord::Base
  validates :origin, :destination,
            :presence => true
end
