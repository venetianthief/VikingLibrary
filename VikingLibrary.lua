
require "Apollo"
require "GameLib"

-- require "Window"
-- require "ChatSystemLib"

--------------------------------------------------------------------------------
-- VikingLibrary Module Definition
--------------------------------------------------------------------------------
local VikingLibrary = {
  _VERSION = 'VikingLibrary.lua 0.0.1',
  _URL     = 'https://github.com/vikinghug/VikingLibrary',
  _DESCRIPTION = '',
  _LICENSE = [[
    MIT LICENSE

    Copyright (c) 2014 Kevin Altman

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]],

  Settings = nil
}

local tModules = {}

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------
function VikingLibrary:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end


--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function VikingLibrary:Init()
  local bHasConfigureFunction = false
  local strConfigureButtonText = ""
  local tDependencies = { "VikingSettings" }

  Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end


--------------------------------------------------------------------------------
-- VikingLibrary OnLoad
--------------------------------------------------------------------------------
function VikingLibrary:OnLoad()
  -- load our form file
  self.xmlDoc = XmlDoc.CreateFromFile("VikingLibrary.xml")
  self.xmlDoc:RegisterCallback("OnDocLoaded", self)

  Apollo.LoadSprites("VikingSprites.xml")

end


--------------------------------------------------------------------------------
-- Public Methods: START
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Assumes that alpha is a value of 0-100
--------------------------------------------------------------------------------
function VikingLibrary:NewColor(color, alpha)
  self.color(color, alpha)
  return ApolloColor.new(sAlpha .. self.tColors[color])
end


--------------------------------------------------------------------------------
-- Is this part of VikingLibrary:NewColor?
--------------------------------------------------------------------------------
function VikingLibrary.color(color, alpha)
  alpha = alpha == nil and 100
  local sAlpha = string.format("%x", (alpha / 100) * 255)
  return sAlpha .. VikingLibrary.tColors[color]
end


--------------------------------------------------------------------------------
-- GetKeyFromValue(t, value)
--
-- Finds a key in table 't' which has the value 'v'
--------------------------------------------------------------------------------
function VikingLibrary.GetKeyFromValue(t, value)
  for k,v in pairs(t) do
    if v==value then return k end
  end
  return nil
end


--------------------------------------------------------------------------------
-- Number formating
--
-- Uses k instead of 1000. Ex: 27564 -> 27.5k
--------------------------------------------------------------------------------
function VikingLibrary:NumberToHuman(num)
  if num ~= nil and num > 999 then
    local decimalPlaces = 10^1
    local roundedNum    = math.floor(num)
    local sizes = {
      { 'Billions', 1000000000 },
      { 'Millions', 1000000 },
      { 'Short', 1000 },
    }

    for i, value in ipairs(sizes) do
      local abbrev = value[1]
      local size = value[2]
      if roundedNum >= size then
        local number = math.floor(roundedNum * decimalPlaces / size) / decimalPlaces
        local sType  = number % 1 ~= 0 and "Float" or "Whole"
        local sFormatString = Apollo.GetString('TargetFrame_' .. abbrev .. 'Number' .. sType)

        return String_GetWeaselString(sFormatString, number)
      end
    end
  end
  return num
end

--------------------------------------------------------------------------------
-- Public Methods: END
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- VikingLibrary OnDocLoaded
--------------------------------------------------------------------------------
function VikingLibrary:OnDocLoaded()

  if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
    self.wndMain = Apollo.LoadForm(self.xmlDoc, "Form", nil, self)
    if self.wndMain == nil then
      Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
      return
    end

    self.wndMain:Show(true, true)

    Event_FireGenericEvent("VikingLibrary:Loaded")

    self.Settings = Apollo.GetAddon("VikingSettings")

    self.tColors = self.Settings.tColors
  end
end


--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function VikingLibrary.Include(modules)

  local m = {}
  for k,v in ipairs(modules) do
    table.insert(m, tModules[v])
  end
  return unpack(m)

end


--------------------------------------------------------------------------------
-- VikingLibrary Instance
--------------------------------------------------------------------------------
local VikingLibraryInst = VikingLibrary:new()
VikingLibraryInst:Init()
