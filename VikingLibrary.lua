
require "Apollo"
require "GameLib"

-- require "Window"
-- require "ChatSystemLib"

-----------------------------------------------------------------------------------------------
-- VikingLibrary Module Definition
-----------------------------------------------------------------------------------------------

local VikingLibrary = {
  _VERSION = 'VikingLibrary.lua 0.0.1',
  _URL     = '',
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
  ]]
}

local VikingSettings

local tModules = {
  Colours = {
    red = "ff0000",
    green = "00ff00",
    blue = "0000ff"
  },
  Number = 32,
  Who = "noone",
  Why = "no reason"
}

-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function VikingLibrary:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self


    return o
end


function VikingLibrary:Init()
  local bHasConfigureFunction = false
  local strConfigureButtonText = ""
  local tDependencies = { "VikingSettings" }

  Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end


-----------------------------------------------------------------------------------------------
-- VikingLibrary OnLoad
-----------------------------------------------------------------------------------------------
function VikingLibrary:OnLoad()
  -- load our form file
  self.xmlDoc = XmlDoc.CreateFromFile("VikingLibrary.xml")
  self.xmlDoc:RegisterCallback("OnDocLoaded", self)

  Apollo.LoadSprites("VikingSprites.xml")

end

-----------------------------------------------------------------------------------------------
-- Public Methods
-----------------------------------------------------------------------------------------------

-- Assumes that alpha is a value of 0-100
function VikingLibrary:NewColor(color, alpha)
  self.color(color, alpha)
  return ApolloColor.new(sAlpha .. self.tColors[color])
end

function VikingLibrary.color(color, alpha)
  alpha = alpha == nil and 100
  local sAlpha = string.format("%x", (alpha / 100) * 255)
  return sAlpha .. VikingLibrary.tColors[color]
end

-----------------------------------------------------------------------------------------------
-- VikingLibrary OnDocLoaded
-----------------------------------------------------------------------------------------------
function VikingLibrary:OnDocLoaded()

  if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
    self.wndMain = Apollo.LoadForm(self.xmlDoc, "Form", nil, self)
    if self.wndMain == nil then
      Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
      return
    end

    self.wndMain:Show(true, true)

    Event_FireGenericEvent("VikingLibrary:Loaded")

    VikingSettings = Apollo.GetAddon("VikingSettings")

    self.tColors = VikingSettings.tColors
    -- if the xmlDoc is no longer needed, you should set it to nil
    -- self.xmlDoc = nil

    -- Register handlers for events, slash commands and timer, etc.
    -- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)

    -- Do additional Addon initialization here
  end
end

function VikingLibrary.RegisterSettings(parent, xmlDoc)
  return VikingSettings.RegisterSettings(parent, xmlDoc)
end

function VikingLibrary.GetDatabase(dbName)
  VikingSettings = Apollo.GetAddon("VikingSettings")
  local db = VikingSettings.db.char[dbName]
  db.General = VikingSettings.db.char.General
  return db
end

function VikingLibrary.Include(modules)

  local m = {}
  for k,v in ipairs(modules) do
    table.insert(m, tModules[v])
  end
  return unpack(m)

end


-----------------------------------------------------------------------------------------------
-- VikingLibrary Instance
-----------------------------------------------------------------------------------------------
local VikingLibraryInst = VikingLibrary:new()
VikingLibraryInst:Init()
