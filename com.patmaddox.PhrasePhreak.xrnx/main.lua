-- phrase refactoring
-- Pat Maddox

-- HISTORY
--- extract selection to phrase
--- error if no open phrases
--- use the next open note for phrase
--- phrases are one note only
--- set pattern length & lpb based on selection
--- save configured key bindings
--- extract block loop to phrase

-- TODO
--- explode phrase to pattern
--- explode pattern w/ different LPB
--- use previous phrase note range length
--- what happens if you select multiple tracks?
--- phrase extraction - pattern, column

-- NOTES
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

local options = renoise.Document.create("PhrasePhreak") { }
renoise.tool().preferences = options

renoise.tool():add_menu_entry {
  name = "--- Main Menu:Tools:PhrasePhreak:Extract Phrase",
  invoke = function() extract_phrase() end
}

renoise.tool():add_keybinding {
  name = "Pattern Editor:Selection:PhrasePhreak - Extract phrase",
  invoke = function() extract_phrase() end
}

-- LOCAL FUNCTIONS
--- no_selection_error()
--- no_available_phrase_error()
--- can_insert_phrase_at(i)
--- next_available_phrase_index()
--- prepare_phrase_at_index(phrase_index)
--- copy_selected_lines_to_phrase(selection, phrase)
--- the_selection()
--- extract_phrase()

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

local function copy_selected_lines_to_phrase(selection, phrase)
  phrase.number_of_lines = selection.number_of_lines

  for pos, line in selection.lines do
    if pos.line > selection.end_line then break end
    if pos.line >= selection.start_line then
      local phrase_line = phrase:line(pos.line - selection.offset)
      phrase_line:copy_from(line)
    end
  end
end

local function the_selection()
  local start_line = nil
  local end_line = nil
  local number_of_lines = nil
  local pattern_index = nil
  local block_loop_coeff = nil

  if renoise.song().transport.loop_block_enabled then
    local loop_block_start_pos = renoise.song().transport.loop_block_start_pos
    start_line = loop_block_start_pos.line
    block_loop_coeff = renoise.song().transport.loop_block_range_coeff
    pattern_index = renoise.song().sequencer:pattern(loop_block_start_pos.sequence)
  else
    local selection = renoise.song().selection_in_pattern
    end_line = selection.end_line
    start_line = selection.start_line
    pattern_index = renoise.song().selected_pattern_index
  end

  local tin = renoise.song().selected_track_index
  local lines = renoise.song().pattern_iterator:lines_in_pattern_track(pattern_index, tin)

  if block_loop_coeff then
    local pattern = renoise.song():pattern(pattern_index)
    number_of_lines = pattern.number_of_lines / block_loop_coeff
    end_line = start_line - 1 + number_of_lines
  else
    number_of_lines = end_line - start_line + 1
  end

  return {
    start_line = start_line,
    end_line = end_line,
    number_of_lines = number_of_lines,
    lines = lines,
    offset = start_line - 1
  }
end

function extract_phrase()
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
  copy_selected_lines_to_phrase(selection, phrase)
end
