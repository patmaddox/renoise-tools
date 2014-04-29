-- phrase refactoring
-- Pat Maddox

-- HISTORY
--- extract selection to phrase

-- TODO
--- explode phrase to pattern
--- use the next open note for phrase
--- error if no open phrases
--- explode pattern w/ different LPB
--- use previous phrase note range length
--- what happens if you select multiple tracks?

-- renoise.song().patterns[].tracks[]:lines_in_range(index_from, index_to)
-- renoise.song().patterns[].tracks[].lines[]:copy_from(
--   other renoise.PatternLine object)
-- renoise.song().selected_track
-- renoise.song().pattern_iterator:lines_in_pattern(pattern_index)
-- renoise.song().pattern_iterator:lines_in_track(
--   track_index, boolean visible_patterns_only)
-- renoise.song().pattern_iterator:lines_in_pattern_track(
--   pattern_index, track_index)
--   -> [iterator with pos, line (renoise.PatternLine object)]
-- renoise.song().selected_pattern_index
-- renoise.song().selected_track_index

local function no_selection_error()
  renoise.app():show_error("Please select some notes in the pattern editor!")
end

local function extract_phrase()
  if renoise.song().selection_in_pattern == nil then
    no_selection_error()
    return nil
  end
  
  local pin = renoise.song().selected_pattern_index
  local tin = renoise.song().selected_track_index
  local lines = renoise.song().pattern_iterator:lines_in_pattern_track(pin, tin)
  
  if renoise.song().selected_instrument:can_insert_phrase_at(1) then
    renoise.song().selected_instrument:insert_phrase_at(1)
  end
    
  local phrase = renoise.song().selected_instrument:phrase(1)
  phrase:clear()
  
  local selection = renoise.song().selection_in_pattern
  
  for pos, line in lines do
    if pos.line > selection.end_line then break end
    if pos.line >= selection.start_line then
    
      local phrase_line = phrase:line(pos.line)
      phrase_line:copy_from(line)
    end
  end
end

extract_phrase()
