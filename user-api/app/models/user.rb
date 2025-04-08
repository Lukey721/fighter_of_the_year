class User < ApplicationRecord
  # Validations can go here later on -lc
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :votes
end