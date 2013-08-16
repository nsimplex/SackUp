-----
--[[ SackUp ]] VERSION="2.0"
--
-- Last updated: 2013-08-16
-----

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

The file favicon/sackup.tex is based on textures from Klei Entertainment's
Don't Starve and is not covered under the terms of this license.
]]--


MODNAME = modname:upper()

_NAME = modname
_VERSION = VERSION


local assert = GLOBAL.assert
local GetClock = GLOBAL.GetClock

modimport('lib/customizability.lua')

LoadConfigs('rc.defaults.lua')
LoadConfigs('rc.lua')
local DEBUG = TUNING[MODNAME].DEBUG

function krampuspostinit(inst)
	if inst.components.lootdropper then
		if inst.components.lootdropper.chanceloot then
			for i,v in ipairs(inst.components.lootdropper.chanceloot) do
				if v.prefab == "krampus_sack" then
					if DEBUG then
						print('Removing the original Krampus Sack drop...')
					end
					table.remove(inst.components.lootdropper.chanceloot, i)
					break
				end
			end
		end

		local clock = assert(GetClock(), "There's no clock!")
		local p = 
			TUNING[MODNAME].KRAMPUS_SACK_BASE_CHANCE
		/
			2^( -- "2^" is treated as an unary operator, for brevity.
					TUNING.TOTAL_DAY_TIME*( clock:GetNumCycles() + clock:GetNormTime() )
				/
					TUNING[MODNAME].KRAMPUS_SACK_CHANCE_HALF_LIFE 
			)

		if DEBUG then
			print(('Adding the custom Krampus Sack drop with chance of %.1f%%...'):format(100*p))
		end
		inst.components.lootdropper:AddChanceLoot("krampus_sack", p)
	end
end

AddPrefabPostInit("krampus", krampuspostinit)

AddSimPostInit(function()
	print('Thank you, ' .. (GLOBAL.STRINGS.NAMES[GLOBAL.GetPlayer().prefab:upper()] or "player") .. ', for using ' .. modname .. ' Mod ' .. VERSION .. '.')
	print(modname .. ' is free software, licensed under the terms of the GNU GPLv2.')
end)


if DEBUG then
	function GLOBAL.SpawnKrampuses(n)
		n = n or 16
		for _=1, n do
			GLOBAL.DebugSpawn("krampus")
		end
	end
	
	function GLOBAL.KillKrampuses(radius)
		radius = radius or 256
		
		local x, y, z = GLOBAL.GetPlayer():GetPosition():Get()
		local E = GLOBAL.TheSim:FindEntities(x, y, z, radius)

		for _, e in ipairs(E) do
			if e.prefab and e.prefab == "krampus" then
				e.components.health:DoDelta(-2^10)
			end
		end
	end

	function GLOBAL.TestKrampuses(n, radius)
		GLOBAL.SpawnKrampuses(n)

		GLOBAL.GetPlayer():DoTaskInTime(0, function()
			GLOBAL.KillKrampuses(radius)
		end)
	end
end
