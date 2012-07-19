class Question < ActiveRecord::Base

  has_many :votes
  belongs_to :lesson
  attr_accessible :content, :lesson_id

end
