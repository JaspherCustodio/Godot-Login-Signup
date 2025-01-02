extends Control

@onready var username_input = %UsernameLogin
@onready var password_input = %PasswordLogin
@onready var successful_feedback_label = %SuccessfulFeedbackLabel
@onready var error_feedback_label = %ErrorFeedbackLabel

@onready var db = Database.new()
@onready var crypto = UserCrypto.new()

@onready var loading_scene: Control = $LoadingScene


func _on_login_button_pressed():
	var username = username_input.text
	var password = password_input.text
	
	# --- VALIDATION START ---
	# Check for empty fields
	if username == "" or password == "":
		print("Please enter both username and password.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Please enter username and password."
		return
	
	# Validate username length
	if len(username) < 4 or len(username) > 20:
		print("Username must be between 4 and 20 characters.")
		error_feedback_label.show()
		error_feedback_label.text = "Username must be between 4\nand 20 characters."
		return
	
	# Ensure username has valid characters
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9_]+$")
	
	if not regex.search(username):
		print("Username can only contain letters, numbers, and underscores.")
		error_feedback_label.show()
		error_feedback_label.text = "Username can only contain letters,\nnumbers, and underscores."
		return
	
	# Check password length
	if len(password) < 8:
		print("Password must be at least 8 characters long.")
		error_feedback_label.show()
		error_feedback_label.text = "Password must be at least\n8 characters long."
		return
	# --- VALIDATION END ---

	# Fetch user data from the database
	var user_data = db.get_user(username)
	
	if user_data == null:
		print("User not found.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "User not found."
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
			error_feedback_label.hide()
			successful_feedback_label.show()
			successful_feedback_label.text = "Login successful!"
			loading_scene.show()
			await(get_tree().create_timer(2.4).timeout)
			SceneSwitcher.switch_scene("res://Scenes/user_screen.tscn")
		else:
			print("Invalid username or password.")
			successful_feedback_label.hide()
			error_feedback_label.show()
			error_feedback_label.text = "Invalid username or password."
	else:
		print("Login failed due to missing data.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Login failed due to missing data."
		username_input.text = ""
		password_input.text = ""

func _on_signup_button_pressed() -> void:
	# Switch to the Signup screen
	SceneSwitcher.switch_scene("res://Scenes/signup_screen.tscn")
