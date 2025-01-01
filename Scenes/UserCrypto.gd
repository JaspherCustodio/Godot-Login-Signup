extends Node
class_name UserCrypto


# Generates a random salt
func generate_salt(length: int = 32) -> String:
	var crypto = Crypto.new()
	return crypto.generate_random_bytes(length).hex_encode()

# Hashes a password with a salt
func hash_password(password: String, salt: String) -> String:
	var password_data = password.to_utf8_buffer()
	var salt_data = salt.to_utf8_buffer()
	var combined_data = password_data + salt_data
	
	var hash_context = HashingContext.new()
	hash_context.start(HashingContext.HASH_SHA256)
	hash_context.update(combined_data)
	var hashed = hash_context.finish()
	
	return hashed.hex_encode()
