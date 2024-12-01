module core

// Applies a function `fn` to each element of an iterable and returns a new array.
// Example:
// ```v
// numbers := [1, 2, 3, 4, 5]
// doubled := map(numbers, fn (n int) int { return n * 2 })
// println(doubled) // [2, 4, 6, 8, 10]
// ```
pub fn map[T, U](iterable []T, f fn (T) U) []U {
	mut result := []U{}
	for item in iterable {
		result << f(item)
	}
	return result
}

// Filters elements of an iterable using a predicate function `fn`.
// Example:
// ```v
// numbers := [1, 2, 3, 4, 5]
// even := filter(numbers, fn (n int) bool { return n % 2 == 0 })
// println(even) // [2, 4]
// ```
pub fn filter[T](iterable []T, f fn (T) bool) []T {
	mut result := []T{}
	for item in iterable {
		if f(item) {
			result << item
		}
	}
	return result
}

// Reduces an iterable to a single value using a reducer function `fn`.
// Example:
// ```v
// numbers := [1, 2, 3, 4, 5]
// sum := reduce(numbers, fn (acc int, n int) int { return acc + n }, 0)
// println(sum) // 15
// ```
pub fn reduce[T, U](iterable []T, f fn (U, T) U, initial U) U {
	mut acc := initial
	for item in iterable {
		acc = f(acc, item)
	}
	return acc
}

// Applies a function `fn` to each element of an iterable.
// Example:
// ```v
// numbers := [1, 2, 3, 4, 5]
// for_each(numbers, fn (n int) { println(n) }) // prints each number
// ```
pub fn for_each[T](iterable []T, f fn (T)) {
	for item in iterable {
		f(item)
	}
}

// Finds the first element in an iterable that satisfies the predicate `fn`.
// Example:
// ```v
// numbers := [1, 2, 3, 4, 5]
// even := find(numbers, fn (n int) bool { return n % 2 == 0 })
// println(even) // ?2
// ```
pub fn find[T](iterable []T, f fn (T) bool) ?T {
	for item in iterable {
		if f(item) {
			return item
		}
	}
	return none
}
