module proud

import math

// TODO: []T.grow_cap/len does not compile..
enum GrowPolicy {
	normal
	high_speed
	low_memory
}

struct CFastArray[T] {
mut:
	data           []T
	grow_policy    GrowPolicy = .normal
	min_capacity   int
	suspend_shrink bool
}

pub fn (mut c CFastArray[T]) get_grow_policy() GrowPolicy {
	return c.grow_policy
}

pub fn (mut c CFastArray[T]) set_grow_policy(policy GrowPolicy) {
	c.grow_policy = policy
}

pub fn (mut c CFastArray[T]) set_min_capacity(cap int) {
	c.min_capacity = cap
}

pub fn (mut c CFastArray[T]) get_min_capacity() int {
	return c.min_capacity
}

pub fn (mut c CFastArray[T]) suspend_shrink() {
	c.suspend_shrink = true
}

pub fn (mut a CFastArray[T]) set_capacity(cap int) {
	new_capacity := math.max(a.get_min_capacity(), math.max(cap, a.data.cap))

	if new_capacity <= a.data.cap {
		return
	}

	new_data := []T{len: a.data.len, cap: new_capacity}
	unsafe {
		vmemcpy(new_data.data, a.data.data, a.data.element_size * a.data.len)
	}
}

pub fn (mut a CFastArray[T]) on_recycle() {
}

pub fn (mut a CFastArray[T]) on_drop() {
	a.clear()
}

pub fn (mut a CFastArray[T]) clear() {
	a.set_count(0)
}

pub fn (mut a CFastArray[T]) clear_and_keep_capacity() { // only for debug.
	a.clear()
}

pub fn (mut a CFastArray[T]) element_at(index int) !T {
	a.bound_check(index)!
	return a.data[index]
}

pub fn (mut a CFastArray[T]) get_data() []T {
	return a.data
}

pub fn (mut a CFastArray[T]) add(value T) {
	a.data << value
}

pub fn (mut a CFastArray[T]) insert(index int, value T) {
	a.insert_range(index, &value, 1)
}

pub fn (mut a CFastArray[T]) insert_range(index int, data voidptr, count int) {
	assert count >= 0
	assert index >= 0
	assert index < a.data.len

	old_count := a.data.len

	a.add_count(count)

	move_amount := old_count - index
	src := &u8(a.get_data().data)

	if move_amount > 0 {
		unsafe {
			vmemmove(src + index + count, src + index, a.data.element_size * move_amount)
		}
	}

	unsafe {
		vmemcpy(src + index, data, a.data.element_size * count)
	}
}

pub fn (mut a CFastArray[T]) set_count(count int) {
	assert count >= 0

	if count == a.data.len {
		return
	}

	if count > a.data.len {
		a.add_count(count - a.data.len)
	} else if count < a.data.len {
		// todo: get_recommended_capacity(count)
		a.set_capacity(count)
	}
}

pub fn (mut a CFastArray[T]) add_count(count int) {
	assert count >= 0

	if a.data.len + count > a.data.cap {
		// todo: get_recommended_capacity(a.data.len + count)
		a.set_capacity(a.data.len + count)
	}

	a.data << []u8{len: count}
}

pub fn (mut a CFastArray[T]) add_range(data voidptr, count int) {
	assert count >= 0

	if count == 0 {
		return
	}

	old_count := a.data.len

	a.add_count(count)

	src := &u8(a.get_data().data)

	unsafe {
		src += old_count
		vmemcpy(src, data, a.data.element_size * count)
	}
}

pub fn (mut a CFastArray[T]) bound_check(index int) ! {
	if index < 0 || index >= a.data.len {
		return error('Out of bounds')
	}
}
