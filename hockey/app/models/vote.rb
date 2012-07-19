class Vote < ActiveRecord::Base

  belongs_to :question, :user
  attr_accessible :question_id, :user_id

end
