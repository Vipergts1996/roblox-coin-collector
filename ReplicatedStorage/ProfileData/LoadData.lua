local Data = {}

local PlayerData = require(script.Parent:WaitForChild("ProfileService"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = ReplicatedStorage:WaitForChild("Settings")
local Assets = ReplicatedStorage:WaitForChild("Models")
local RunService = game:GetService("RunService")
local Pets = Assets:WaitForChild("Pets")
local CreateTable = require(script.Parent.Parent:WaitForChild("CreateTable"))
local PetHandler = require(script.Parent.Parent:WaitForChild("PetHandler"))
local GameData = require(script.Parent.Parent:WaitForChild("GameData"))

local suffixes = {'','K','M','B','T','qd','Qn','sx','Sp','O','N','de','Ud','DD','tdD','qdD','QnD','sxD','SpD','OcD','NvD','Vgn','UVg','DVg','TVg','qtV','QnV','SeV','SPG','OVG','NVG','TGN','UTG','DTG','tsTG','qtTG','QnTG','ssTG','SpTG','OcTG','NoAG','UnAG','DuAG','TeAG','QdAG','QnAG','SxAG','SpAG','OcAG','NvAG','CT'}
local function format(val)
	for i=1, #suffixes do
		if tonumber(val) < 10^(i*3) then
			return math.floor(val/((10^((i-1)*3))/100))/(100)..suffixes[i]
		end
	end
end

return Data
