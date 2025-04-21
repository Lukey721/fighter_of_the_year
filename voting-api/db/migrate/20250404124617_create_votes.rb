# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :fighter_id

      t.timestamps
    end
  end
end
