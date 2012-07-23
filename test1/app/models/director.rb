class Director < ActiveRecord::Base

  attr_accessible :dob, :name


  has_many :movies
end
