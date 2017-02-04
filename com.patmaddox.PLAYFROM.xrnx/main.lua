_AUTO_RELOAD_DEBUG = function()
  -- play_from()
end

renoise.tool():add_menu_entry {
  name = "--- Main Menu:Tools:PLAYFROM",
  invoke = function() play_from() end
}

renoise.tool():add_keybinding {
  name = "Global:Transport:PLAYFROM",
  invoke = function() play_from() end
}

function play_from()
  local pos = find_off()

  if pos then
    renoise.song().transport:start_at(pos)
  end
end

function find_play_from_track()
  for i, track in pairs(renoise.song().tracks) do
    if track.name == "PLAYFROM" then
      return i
    end
  end
end

function find_off()
  local track_index = find_play_from_track()

  if not track_index then
    return
  end

  for pos, line in renoise.song().pattern_iterator:note_columns_in_track(track_index) do
    if line.note_string == "OFF" then
      return renoise.SongPos(pos.pattern, pos.line)
    end
  end
end
