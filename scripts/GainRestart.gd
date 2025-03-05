extends Resource
class_name GainRestart

enum RestartCriteria {
	PrimeNumbers,
	PowersOfTwo,
	MultiplesOfThree,
	NoMoreAvailable
}

@export var restart_criteria: RestartCriteria
@export var restart_number: int

var number_found: int

func update_with_move(move: int):
	if move_fulfills_criteria(move):
		number_found += 1
		Global.update_restart_criteria.emit(self)
		if number_found == restart_number:
			Global.enable_restart.emit()
			Global.spawn_notification.emit("Computer restart available")

func move_fulfills_criteria(move: int) -> bool:
	match restart_criteria:
		RestartCriteria.PrimeNumbers:
			return is_prime(move)
		RestartCriteria.PowersOfTwo:
			return is_power_of_two(move)
		RestartCriteria.MultiplesOfThree:
			return is_multiple_of_three(move)
	return false

func done() -> bool:
	return number_found >= restart_number

# theres a smarter way to do this
# but i am too drunk
static func is_prime(num: int) -> bool:
	if num == 1 or num == 0: return false
	if num == 2: return true
	for i in range(2, num):
		if num % i == 0:
			return false
	return true

# https://stackoverflow.com/questions/108318/how-can-i-test-whether-a-number-is-a-power-of-2
static func is_power_of_two(num: int):
	return !(num == 0) and !(num & (num - 1));

static func is_multiple_of_three(num: int):
	return num % 3 == 0
