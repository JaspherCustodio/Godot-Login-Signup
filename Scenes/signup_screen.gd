extends Control

@onready var username_input = %UsernameSignup
@onready var password_input = %PasswordSignup
@onready var confirm_password_input = %ConfirmPasswordSignup
#@onready var feedback_label = $FeedbackLabel
@onready var db = Database.new()
@onready var crypto = UserCrypto.new()

# SignupScreen.gd


func _on_create_account_button_pressed() -> void:
	var username = username_input.text
	var password = password_input.text
	var confirm_password = confirm_password_input.text
	
	if username == "" or password == "" or confirm_password == "":
		print("Please fill in all fields.")
		#feedback_label.text = "Please fill in all fields."
		return
	
	if password != confirm_password:
		print("Passwords do not match.")
		#feedback_label.text = "Passwords do not match."
		return
	
	if db.get_user(username) == null:
		print("Username already exists.")
		#feedback_label.text = "Username already exists."
		return
		
	var salt = crypto.generate_salt()
	var hashed_password = crypto.hash_password(password, salt)
	
	if db.sign_up(username, hashed_password, salt):
		print("Signup successful!")
		#feedback_label.text = "Signup successful!"
		# Redirect to login screen or main game scene
		SceneSwitcher.switch_scene("res://Scenes/login_screen.tscn")
	else:
		print("Signup failed.")
		#feedback_label.text = "Signup failed."


func _on_login_button_pressed() -> void:
	SceneSwitcher.switch_scene("res://Scenes/login_screen.tscn")
