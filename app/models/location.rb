class Location < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_numericality_of :latitude
  validates_numericality_of :longitude
end
