---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Config object
local Config = require 'config.shared'

---******************************************************
--- Keybinds                                          ***
---******************************************************

-- Register the keybind to open the VPC-Tab if configured
if Config.OpenTabHotkey ~= nil and Config.OpenTabHotkey ~= '' and Config.OpenTabHotkey ~= 'nil' then
  lib.addKeybind({
    name = 'vpc_open_tab',
    description = 'Open VPC-Tab',
    defaultKey = Config.OpenTabHotkey,
    defaultMapper = 'keyboard',
    onPressed = function()
      TriggerEvent('vpc_connector:client:openTablet')
    end
  })
end
