_AUTO_RELOAD_DEBUG = function()
  -- play_from()
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Nudge Volume:Up",
  invoke = function() nudge_volume(3) end
}

renoise.tool():add_keybinding {
  name = "Mixer:Track Control:Nudge Volume (Up)",
  invoke = function() nudge_volume(3) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Track Control:Nudge Volume (Up)",
  invoke = function() nudge_volume(3) end
}

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Nudge Volume:Down",
  invoke = function() nudge_volume(-3) end
}

renoise.tool():add_keybinding {
  name = "Mixer:Track Control:Nudge Volume (Down)",
  invoke = function() nudge_volume(-3) end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Track Control:Nudge Volume (Down)",
  invoke = function() nudge_volume(-3) end
}

function nudge_volume(amount)
  local track = renoise.song().selected_track;
  local volume = track.postfx_volume;
  local db = string.match(volume.value_string, '(.*) dB')
  local newDb = tonumber(db) + amount;
  volume.value_string = tostring(newDb);
end
