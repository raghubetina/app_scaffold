class Movie < ActiveRecord::Base

  attr_accessible :director_id, :title, :year

  belongs_to :director
  has_many :characters
  has_many :favorites
end
