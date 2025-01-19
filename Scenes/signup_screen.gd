extends Control

@onready var username_input = %UsernameSignup
@onready var password_input = %PasswordSignup
@onready var confirm_password_input = %ConfirmPasswordSignup
@onready var successful_feedback_label = %SuccessfulFeedbackLabel
@onready var error_feedback_label = %ErrorFeedbackLabel

@onready var db = Database.new()
@onready var crypto = UserCrypto.new()

@onready var loading_scene: Control = $LoadingScene


func _on_signup_button_pressed() -> void:
	var username = username_input.text
	var password = password_input.text
	var confirm_password = confirm_password_input.text
	
	# --- VALIDATION START ---
	# Check for empty fields
	if username == "" or password == "" or confirm_password == "":
		print("Please fill in all fields.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Please fill in all fields."
		return
	
	# Check username length
	if len(username) < 4 or len(username) > 20:
		print("Username must be 4-20 characters long.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Username must be 4-20 characters long."
		return
	
	# Check for invalid characters (only letters and numbers allowed)
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9_]+$")
	
	if not regex.search(username):
		print("Username can only contain letters, numbers and underscores.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Username can only contain letters,\nnumbers, and underscores."
		return
	
	# Password length check
	if len(password) < 8:
		print("Password must be at least 8 characters long.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Password must be at least\n8 characters long."
		return
	
	# Password strength check (at least one letter, one number, and one special character)
	var regex_lowercase = RegEx.new()
	regex_lowercase.compile("[a-zA-Z]")
	var regex_number = RegEx.new()
	regex_number.compile("[0-9]")
	var regex_special = RegEx.new()
	regex_special.compile("[!@#$%^&*(),.?\":{}|<>]")
	
	if not regex_lowercase.search(password) or not regex_number.search(password) or not regex_special.search(password):
		print("Password must include letters, numbers, and special characters.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Password must include letters,\nnumbers, and special characters."
		return
	
	# Check confirm password
	if password != confirm_password:
		print("Passwords do not match.")
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "Passwords do not match."
		return
	# --- VALIDATION END ---

	var user_data = db.get_user(username)
	
	if user_data.has("username"):
		if user_data.username != null:
			print("Username already exists.")
			successful_feedback_label.hide()
			error_feedback_label.show()
			error_feedback_label.text = "Username already exists."
			return

	var salt = crypto.generate_salt()
	var hashed_password = crypto.hash_password(password, salt)
	
	if db.sign_up(username, hashed_password, salt):
		print("Signup successful!")
		error_feedback_label.hide()
		successful_feedback_label.show()
		successful_feedback_label.text = "Signup successful!"
		loading_scene.show()
		await(get_tree().create_timer(2.4).timeout)
		SceneSwitcher.switch_scene("res://Scenes/login_screen.tscn")
	else:
		var error_details = "Unexpected error at signup process."
		print(error_details)
		print_debug("Error details:", error_details)
		successful_feedback_label.hide()
		error_feedback_label.show()
		error_feedback_label.text = "An unexpected error occurred.\nPlease try again."
		username_input.text = ""
		password_input.text = ""

func _on_login_button_pressed() -> void:
	# Switch to the Login screen
	SceneSwitcher.switch_scene("res://Scenes/login_screen.tscn")
