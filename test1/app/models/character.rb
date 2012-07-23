class Character < ActiveRecord::Base

  attr_accessible :actor_id, :movie_id, :name

  belongs_to :actor
  belongs_to :movie

end
