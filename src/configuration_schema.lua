--
-- Lists the tests for each configuration value.
--

--[[
Copyright (C) 2013  simplex

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]


local type = type
local tostring = tostring
local table = table
local ipairs = ipairs
local JoinArrays = GLOBAL.JoinArrays

local setfenv = GLOBAL.setfenv

local _M = {}
_M._M = _M
RC_SCHEMA = _M
setfenv(1, _M)

local function And(p, q)
	return function(x)
		local b, id

		b, id = p(x)
		if not b then return false, id end

		b, id = q(x)
		if not b then return false, id end

		return true
	end
end

local function Or(p, q)
	return function(x)
		local b, p_id, q_id

		b, p_id = p(x)
		if b then return true end

		b, q_id = q(x)
		if b then return true end

		return false, JoinArrays(p_id, q_id)
	end
end

local function IsType(t) return function(x) return type(x) == t, {"a " .. t} end end
local function IsInRange(a, b) return function(x) return a <= x and x <= b, {"between " .. a .. " and " .. b} end end

local IsNumber = IsType("number")
local IsPositive = function(x) return x > 0, {"positive"} end
local IsPositiveNumber = And(IsNumber, IsPositive)
local IsInteger = function(x) return (IsNumber(x)) and x % 1 == 0, {"an integer"} end
local IsPositiveInteger = And(IsInteger, IsPositive)
local IsProbability = And(IsNumber, IsInRange(0, 1))
local IsBoolean = IsType("boolean")

KRAMPUS_SACK_BASE_CHANCE = IsProbability
KRAMPUS_SACK_CHANCE_HALF_LIFE = IsPositiveNumber

DEBUG = IsBoolean

return _M
