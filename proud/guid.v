module proud

import rand

type Guid = string
type GuidWithBrackets = string

pub fn guid_random() Guid {
	return Guid(rand.uuid_v4())
}

pub fn guid_from_string(guid string) Guid {
	return Guid(guid)
}

pub fn guid_bracket_string_to_guid(guid GuidWithBrackets) Guid {
	return Guid(guid.trim('{}'))
}

pub fn guid_to_bracket_string(guid Guid) GuidWithBrackets {
	return GuidWithBrackets('{${guid}}')
}