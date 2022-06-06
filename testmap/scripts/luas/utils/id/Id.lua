--转换256进制整数
local tb = {}

local _ids1 = {}
local _ids2 = {}

function tb._id(a)
	local r = ('>I4'):pack(a)
	_ids1[a] = r
	_ids2[r] = a
	return r
end

function tb.__id2(a)
	local r = ('>I4'):unpack(a)
	_ids2[a] = r
	_ids1[r] = a
	return r
end

function tb.id2string(a)
	if (type(a) == "number") then
		a = tostring(a)
	end

	if (#a <4) then return end

	return tostring(_ids1[a] or tb._id(a))
end

function tb.string2id(a)
	if (#a <4) then return end

	return tonumber(_ids2[a] or tb.__id2(a))
end

return tb