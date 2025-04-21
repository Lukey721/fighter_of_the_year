# frozen_string_literal: true

class CreateFighters < ActiveRecord::Migration[7.1]
  def change
    create_table :fighters do |t|
      t.string :name
      t.integer :ufc_id

      t.timestamps
    end
  end
end
