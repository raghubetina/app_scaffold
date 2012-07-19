class User < ActiveRecord::Base

  has_many :lessons, :votes
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation

  has_secure_password

end
