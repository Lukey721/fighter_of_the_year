# frozen_string_literal: true

class User < ApplicationRecord
  # Validations can go here later on
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :votes, dependent: :destroy
end
