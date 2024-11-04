extends Control

@onready var username_input = %UsernameLogin
@onready var password_input = %PasswordLogin
#@onready var feedback_label = $FeedbackLabel
@onready var db = Database.new()
@onready var crypto = UserCrypto.new()


func _on_login_button_pressed():
	var username = username_input.text
	var password = password_input.text
	
	if username == "" or password == "":
		print("Please enter both username and password.")
		#feedback_label.text = "Please enter both username and password."
		return
	
	# Fetch user data from the database
	var user_data = db.get_user(username)
	if user_data == null:
		print("User not found.")
		#feedback_label.text = "User not found."
		return
	if user_data.has("hashed_password") and user_data.has("salt"):
		var hashed_password = crypto.hash_password(password, user_data.salt)
		if user_data.hashed_password == hashed_password:
			var return_data = {
				"username" :user_data.username,
				"id" : user_data.id
			}
			print(return_data)
			print("Login successful!")
			#feedback_label.text = "Login successful!"
			# Switch to the main game or next scene here
		else:
			print("Invalid username or password.")
			#feedback_label.text = "Invalid username or password."
	else:
		print("Login failed due to missing data.")
		#feedback_label.text = "Login failed due to missing data."

func _on_signup_button_pressed() -> void:
	# Switch to the Signup screen
	SceneSwitcher.switch_scene("res://Scenes/signup_screen.tscn")
