extends GPUParticles2D

# Adjust the amount of rain particles emitted
func set_rain_intensity(amount: int) -> void:
	self.amount = amount  # 'amount' controls the number of emitted particles

# Adjust the speed of rain particles
func set_rain_speed(speed: float) -> void:
	var material 
	if material:
		material.initial_velocity = speed

# Change the direction of the rain (simulating wind)
func set_rain_direction(direction: Vector2) -> void:
	var material 
	if material:
		material.gravity = direction  # Adjusts gravity for directional effect
