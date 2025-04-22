# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Create Fighters first
fighters = Fighter.create([
                            { name: 'Conor McGregor', ufc_id: 1 },
                            { name: 'Khabib Nurmagomedov', ufc_id: 2 }
                          ])

# Manually reference existing users' ids. These IDs should correspond to the user records already in the user-api.
# The following user IDs are assumed to exist in your `user-api`.

existing_user_ids = [1] # These should be real user IDs from your `user-api`

# Create Votes by referencing existing user IDs
Vote.create([
              { user_id: existing_user_ids[0], fighter_id: fighters[0].id }
            ])

Rails.logger.info 'Seed data created successfully!'
