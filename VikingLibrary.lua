
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

local tColors = {
  black       = "201e2d",
  white       = "ffffff",
  grey        = "",
  lightGrey   = "bcb7da",
  red         = "e05757",
  green       = "06ff5e",
  blue        = "49e8ee",
  lightPurple = "645f7e",
  purple      = "28253a",
  yellow      = "ffd161",
  orange      = ""
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

    -- initialize variables here
    o.tColors = tColors

    return o
end


function VikingLibrary:Init()
  local bHasConfigureFunction = false
  local strConfigureButtonText = ""
  local tDependencies = { }

  Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end


-----------------------------------------------------------------------------------------------
-- VikingLibrary OnLoad
-----------------------------------------------------------------------------------------------
function VikingLibrary:OnLoad()
  -- load our form file
  self.xmlDoc = XmlDoc.CreateFromFile("VikingLibrary.xml")
  self.xmlDoc:RegisterCallback("OnDocLoaded", self)

  Apollo.LoadSprites("VikingLibrarySprites.xml")
end

-----------------------------------------------------------------------------------------------
-- Public Methods
-----------------------------------------------------------------------------------------------

-- Assumes that alpha is a value of 0-100
function VikingLibrary:NewColor(color, alpha)
  local sAlpha = string.format("%x", (alpha / 100) * 255)
  return ApolloColor.new(sAlpha .. tColors[color])
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

    -- if the xmlDoc is no longer needed, you should set it to nil
    -- self.xmlDoc = nil

    -- Register handlers for events, slash commands and timer, etc.
    -- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)

    -- Do additional Addon initialization here
  end
end

-----------------------------------------------------------------------------------------------
-- VikingLibrary Instance
-----------------------------------------------------------------------------------------------
local VikingLibraryInst = VikingLibrary:new()
VikingLibraryInst:Init()
