class Statistic < ActiveRecord::Base
    validates_uniqueness_of :status_code
end
