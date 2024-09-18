# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
User.destroy_all
Document.destroy_all

puts "Creating users..."
hugh = {username: "hclay", password: "123456", email: "hughgrassbyclayton@hotmail.com"}
john = {username: "jclay", password: "123456", email: "jhclay@bigpond.net"}

[hugh, john].each do |attributes|
  user = User.create!(attributes)
  puts "Created #{user.username}"
end
puts "finished"
