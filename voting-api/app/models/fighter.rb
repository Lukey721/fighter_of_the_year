# frozen_string_literal: true

class Fighter < ApplicationRecord
  has_many :votes, dependent: :destroy
end
