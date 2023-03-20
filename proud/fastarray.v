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

pub fn new_fast_array_from_ptr[T](data &T, count int) CFastArray[T] {
	mut array := CFastArray[T]{}

	array.insert_range(0, data, count)
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

pub fn (mut a CFastArray[T]) get_recommended_capacity(wanted_length int) int {
	grow_by := match a.grow_policy {
		.normal {
			mut tmp := a.data.len / 8
			tmp = math.min(tmp, 1024)
			math.max(tmp, 4)
		}
		.high_speed {
			mut tmp := a.data.len / 8
			tmp = math.max(tmp, 16)
			tmp = math.max(tmp, 64 / a.data.element_size)
			math.min(tmp, 1024)
		}
		.low_memory {
			math.max(a.min_capacity, wanted_length)
		}
	}

	v1 := a.data.cap
	v2 := wanted_length + grow_by
	mut diff := 0
	if v1 > v2 {
		diff = v1 - v2
	} else {
		diff = v2 - v1
	}

	if !a.suspend_shrink {
		if diff > grow_by {
			return math.max(a.min_capacity, v2)
		} else {
			return math.max(a.min_capacity, v1)
		}
	}

	if diff > grow_by {
		return math.max(a.data.cap, v2)
	}

	return math.max(a.data.cap, v1)
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
		capacity := a.get_recommended_capacity(count)
		a.set_capacity(capacity)
	}
}

pub fn (mut a CFastArray[T]) add_count(count int) {
	assert count >= 0

	if a.data.len + count > a.data.cap {
		capacity := a.get_recommended_capacity(a.data.len + count)
		a.set_capacity(capacity)
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

pub fn (mut a CFastArray[T]) resize(count int) {
	a.set_count(count)
}

pub fn (mut a CFastArray[T]) bound_check(index int) ! {
	if index < 0 || index >= a.data.len {
		return error('Out of bounds')
	}
}

pub fn (mut a CFastArray[T]) get_capacity() int {
	return a.data.cap
}

pub fn (mut a CFastArray[T]) get_count() int {
	return a.data.len
}

pub fn (mut a CFastArray[T]) size() int {
	return a.data.len
}

pub fn (mut a CFastArray[T]) is_empty() bool {
	return a.data.len == 0
}

pub fn (mut a CFastArray[T]) copy_range_to(mut dst &CFastArray[T], src_offset int, count int) {
	assert src_offset + count > a.data.len || src_offset >= 0 || count >= 0

	dst.set_count(count)

	mut our_ptr := &u8(a.get_data().data)
	unsafe {
		our_ptr += src_offset
		vmemcpy(dst.get_data().data, our_ptr, a.data.element_size * count)
		dst.get_data().data
	}
}

pub fn (mut a CFastArray[T]) copy_to(mut dst &CFastArray[T]) {
	a.copy_range_to(mut dst, 0, a.data.len)
}

pub fn (mut a CFastArray[T]) copy_from(mut src &CFastArray[T]) {
	src.copy_to(mut a)
}

pub fn (mut a CFastArray[T]) remove_range(index int, count int) {
	assert index >= 0
	assert count >= 0

	real_count := math.min(count, a.data.len - index)
	amount := a.data.len - index + real_count

	mut dest_ptr := &u8(a.data.data)
	mut src_ptr := &u8(a.data.data)
	unsafe {
		dest_ptr += index
		src_ptr += index + real_count

		vmemmove(dest_ptr, src_ptr, a.data.element_size * amount)
	}

	a.set_count(a.data.len - real_count)
}

pub fn (mut a CFastArray[T]) remove_at(index int) {
	a.remove_range(index, 1)
}

pub fn (mut a CFastArray[T]) remove_one_by_value(value T) bool {
	for i := 0; i < a.data.len; i++ {
		if a.data[i] == value {
			a.remove_at(i)
			return true
		}
	}

	return false
}

pub fn (mut a CFastArray[T]) find_by_value(value T) int {
	for i := 0; i < a.data.len; i++ {
		if a.data[i] == value {
			return i
		}
	}

	return -1
}

pub fn (mut a CFastArray[T]) contains(value T) bool {
	return a.find_by_value(value) >= 0
}

pub fn (mut a CFastArray[T]) equals(mut rhs &CFastArray[T]) bool {
	if a.data.len != rhs.data.len {
		return false
	}

	unsafe {
		return vmemcmp(a.data.len, rhs.get_data().data, a.data.len * a.data.element_size) == 0
	}
}
