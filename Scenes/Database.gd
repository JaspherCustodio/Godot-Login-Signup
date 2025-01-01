extends Node

class_name Database

var db: SQLite  # Reference to SQLite instance

func _init() -> void:
	db = SQLite.new()
	db.path = "res://users_database.db"
	db.open_db()
	
	var table_dict: Dictionary = {
		"id" : {"data_type":"int", "primary_key" : true, "not_null" : true, "auto_increment" : true},
		"username" : {"data_type":"text", "unique" : true, "not_null" : true},
		"hashed_password" : {"data_type":"text", "not_null" : true},
		"salt" : {"data_type":"text", "not_null" : true}
	}
	
	db.create_table("users", table_dict)

# Adds a new user to the database
func sign_up(username: String, hashed_password: String, salt:String) -> bool:
	#insert a new user into the users table
	var row_dict: Dictionary = {
		"username" : username,
		"hashed_password" : hashed_password,
		"salt" : salt
	}
	
	db.insert_row("users", row_dict)
	
	print_debug(row_dict)
	
	return true

# Retrieves user data by username
func get_user(username: String) -> Dictionary:
	var query = "SELECT salt, hashed_password, id from users where username = ?"
	var param_bindings = [username]
	# Execute the query with bindings
	db.query_with_bindings(query, param_bindings)
	
	for i in db.query_result:
		return {
		"id" : i["id"],
		"hashed_password" : i["hashed_password"],
		"salt" : i["salt"],
		"username" : username
	}
	
	return{}
