class Lesson < ActiveRecord::Base

  has_many :questions
  belongs_to :user
  attr_accessible :embed_code, :name, :user_id

end
