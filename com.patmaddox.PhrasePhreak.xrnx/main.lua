-- phrase refactoring
-- Pat Maddox

-- HISTORY
--- extract selection to phrase
--- error if no open phrases
--- use the next open note for phrase
--- phrases are one note only
--- set pattern length & lpb based on selection
--- save configured key bindings

-- TODO
--- explode phrase to pattern
--- explode pattern w/ different LPB
--- use previous phrase note range length
--- what happens if you select multiple tracks?
--- phrase extraction - pattern, column, selection, loop

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

local function no_available_phrase_error()
  renoise.app():show_error("No phrase slots are available.")
end

local function can_insert_phrase_at(i)
  return renoise.song().selected_instrument:can_insert_phrase_at(i)
end

local function next_available_phrase_index()
  local phrase_index = nil

  for i=1, 120 do
    local status, result = pcall(can_insert_phrase_at, i)

    if not status then
      break
    end

    if result then
      phrase_index = i
      break
    end
  end
  
  return phrase_index
end

local function prepare_phrase_at_index(phrase_index)
  renoise.song().selected_instrument:insert_phrase_at(phrase_index)
  local phrase = renoise.song().selected_instrument:phrase(phrase_index)
  phrase:clear()
  phrase.lpb = renoise.song().transport.lpb

  local mapping = phrase.mapping
  local base_note = phrase_index - 1
  mapping.base_note = base_note
  mapping.note_range = {base_note, base_note}

  return phrase
end

local function copy_selected_lines_to_phrase(phrase)
  local selection = renoise.song().selection_in_pattern
  phrase.number_of_lines = selection.end_line - selection.start_line + 1

  local pin = renoise.song().selected_pattern_index
  local tin = renoise.song().selected_track_index
  local lines = renoise.song().pattern_iterator:lines_in_pattern_track(pin, tin)

  for pos, line in lines do
    if pos.line > selection.end_line then break end
    if pos.line >= selection.start_line then

      local phrase_line = phrase:line(pos.line)
      phrase_line:copy_from(line)
    end
  end
end

local function the_selection()
  return renoise.song().selection_in_pattern
end

local function extract_phrase()
  local selection = the_selection()

  if selection == nil then
    no_selection_error()
    return nil
  end

  local phrase_index = next_available_phrase_index()

  if phrase_index == nil then
    no_available_phrase_error()
    return nil
  end

  local phrase = prepare_phrase_at_index(phrase_index)
  copy_selected_lines_to_phrase(phrase)
end

local function explode_phrase()
  -- check if there's a phrase command beneath the cursor
  -- look up phrase in instrument
  -- copy instrument number to pattern line
  local pin = renoise.song().selected_pattern_index
  local tin = renoise.song().selected_track_index
  local pattern_lines = renoise.song().pattern_iterator:lines_in_pattern_track(pin, tin)
  local pattern = renoise.song().selected_pattern
  local track = pattern:track(tin)

  local phrase = renoise.song().selected_instrument:phrase(1)
  local lines = phrase.lines
  local selection = renoise.song().selection_in_pattern
  local start_line = renoise.song().selected_line_index

  for i, line in ipairs(lines) do
    local pattern_line = track:line(start_line + i - 1)
    pattern_line:copy_from(line)
  end
end

-- explode_phrase()

-- extract_phrase()

local options = renoise.Document.create("PhrasePhreak") { }
renoise.tool().preferences = options

renoise.tool():add_menu_entry {
  name = "--- Main Menu:Tools:PhrasePhreak:Extract Phrase",
  invoke = extract_phrase
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Selection:PhrasePhreak - Extract phrase",
  invoke = extract_phrase
}
