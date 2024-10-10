package uutil

import "core:fmt"

Ratio :: struct {
	numerator:   int,
	denomerator: int,
}

is_even :: proc "c" (n: int) -> bool {
	return n & 1 == 0
}

@(export)
gcd :: proc "c" (first: int, sec: int) -> int {
	num1 := first
	num2 := sec
	pof2: u64 = 0

	if num1 == 0 || num2 == 0 {
		return num1 | num2
	}

	for (is_even(num1) && is_even(num2)) {
		num1 >>= 1
		num2 >>= 1
		pof2 += 1
	}

	body :: proc "c" (num1: ^int, num2: ^int) {
		for is_even(num1^) {
			num1^ >>= 1
		}
		for is_even(num2^) {
			num2^ >>= 1
		}
		if num1^ >= num2^ {
			num1^ = (num1^ - num2^) >> 1
		} else {
			tmp := num1^
			num1^ = (num2^ - num1^) >> 1
			num2^ = tmp
		}
	}
	body(&num1, &num2)
	for !(num1 == num2 || num1 == 0) {
		body(&num1, &num2)
	}
	return num2 << pof2
}

@(export)
make_ratio :: proc "c" () -> Ratio {
	return Ratio{}
}

@(export)
reduce_ratio :: proc "c" (ratio: ^Ratio) {
	gcd_val := gcd(ratio.numerator, ratio.denomerator)
	ratio.numerator /= gcd_val
	ratio.denomerator /= gcd_val
}
