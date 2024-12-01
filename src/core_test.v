module core_test

import core

fn test_map() {
	numbers := [1, 2, 3, 4]
	result := core.map(numbers, fn (n int) int {
		return n * 2
	})
	assert result == [2, 4, 6, 8]
}

fn test_filter() {
	numbers := [1, 2, 3, 4, 5]
	result := core.filter(numbers, fn (n int) bool {
		return n % 2 == 0
	})
	assert result == [2, 4]
}

fn test_reduce() {
	numbers := [1, 2, 3, 4]
	result := core.reduce(numbers, fn (acc int, n int) int {
		return acc + n
	}, 0)
	assert result == 10
}

fn test_for_each() {
	numbers := [1, 2, 3]
	mut output := &[]int{}
	core.for_each(numbers, fn [mut output] (n int) {
		output << n * n
	})
	assert output == [1, 4, 9]
}

fn test_find() {
	numbers := [1, 2, 3, 4, 5]
	result := core.find(numbers, fn (n int) bool {
		return n > 3
	}) or { 0 }
	assert result == 4 // The first number greater than 3

	none_result := core.find(numbers, fn (n int) bool {
		return n > 10
	})
	assert none_result == none
}
