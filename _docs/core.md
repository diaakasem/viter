# module core


## Contents
- [filter](#filter)
- [find](#find)
- [for_each](#for_each)
- [map](#map)
- [reduce](#reduce)

## filter
Example
```v

numbers := [1, 2, 3, 4, 5]
even := filter(numbers, fn (n int) bool { return n % 2 == 0 })
println(even) // [2, 4]

```

[[Return to contents]](#Contents)

## find
Example
```v

numbers := [1, 2, 3, 4, 5]
even := find(numbers, fn (n int) bool { return n % 2 == 0 })
println(even) // ?2

```

[[Return to contents]](#Contents)

## for_each
Example
```v

numbers := [1, 2, 3, 4, 5]
for_each(numbers, fn (n int) { println(n) }) // prints each number

```

[[Return to contents]](#Contents)

## map
Example
```v

numbers := [1, 2, 3, 4, 5]
doubled := map(numbers, fn (n int) int { return n * 2 })
println(doubled) // [2, 4, 6, 8, 10]

```

[[Return to contents]](#Contents)

## reduce
Example
```v

numbers := [1, 2, 3, 4, 5]
sum := reduce(numbers, fn (acc int, n int) int { return acc + n }, 0)
println(sum) // 15

```

[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 1 Dec 2024 09:57:08
