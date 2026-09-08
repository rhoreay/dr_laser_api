user = User.find_or_initialize_by(email_address: "admin@gmail.com")
user.username = "admin"
user.password = "admin_password"
user.save!

puts "Seed: Admin user configured successfully (email: admin@gmail.com, username: admin, password: admin_password)"
