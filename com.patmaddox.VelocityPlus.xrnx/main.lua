_AUTO_RELOAD_DEBUG = function()
  -- play_from()
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Velocity Plus:Velocity++",
  invoke = function() velocity_up(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Velocity++",
  invoke = function() velocity_up(1) end
}

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Velocity Plus:Velocity--",
  invoke = function() velocity_down(1) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Insert/Delete:Velocity--",
  invoke = function() velocity_down(1) end
}

function velocity_up(amount)
  renoise.song().transport.keyboard_velocity = math.min(renoise.song().transport.keyboard_velocity + amount, 127)
end

function velocity_down(amount)
  renoise.song().transport.keyboard_velocity = math.max(renoise.song().transport.keyboard_velocity - amount, 0)
end
