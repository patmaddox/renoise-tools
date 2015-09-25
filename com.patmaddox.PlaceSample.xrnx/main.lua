-- Reload the script whenever this file is saved. 
-- Additionally, execute the attached function.
_AUTO_RELOAD_DEBUG = function()
  -- show_dialog()
end

local tool_name = "Place Sample"

-- local dialog = nil
local vb = nil
local key_to_set = nil
local dialog = nil

function get_note(note_type)
  key_to_set = note_type
  vb.views[key_to_set].text = "type a key..."
end

local keys = {
  "C",
  "C#",
  "D",
  "D#",
  "E",
  "F",
  "F#",
  "G",
  "G#",
  "A",
  "A#",
  "B",
  "B#"
}

local function midi_note_to_name(midi_note)
  local octave = math.floor(midi_note / 12)
  local key = midi_note % 12
  return keys[key + 1] .. "-" .. octave
end

local function display_mappings()
  local mapping = renoise.song().selected_sample.sample_mapping
    
  local base_note = mapping.base_note
  vb.views.base.text = midi_note_to_name(base_note)
    
  local low_note = mapping.note_range[1]
  vb.views.low.text = midi_note_to_name(low_note)
    
  local high_note = mapping.note_range[2]
  vb.views.high.text = midi_note_to_name(high_note)
end

local function key_handler(dialog, key)
  if key_to_set then
    if key.note then
      local note = key.note
      local octave = renoise.song().transport.octave
      
      local sample = renoise.song().selected_sample
      if sample then
        local mapping = sample.sample_mapping
        local midi_note = (octave * 12) + note
        
        if key_to_set == "base" then
          mapping.base_note = midi_note
        elseif key_to_set == "low" then
          local high = mapping.note_range[2]
          if midi_note > high then high = midi_note end
          mapping.note_range = {midi_note, high}
        elseif key_to_set == "high" then
          local low = mapping.note_range[1]
          if midi_note < low then low = midi_note end
          mapping.note_range = {low, midi_note}
        end
      end
      
      display_mappings()
      key_to_set = nil
    end
  elseif key.name == "1" then
    get_note("base")
  elseif key.name == "2" then
    get_note("low")
  elseif key.name == "3" then
    get_note("high")
  end
  
  if key.name == "esc" then
    dialog:close()
  end
  
  return key
end

function show_dialog()
--  if dialog and dialog.visible then
--    dialog:show()
--    return
--  end
 
  vb = renoise.ViewBuilder()

  local dialog_title = "Place Sample"
  
  local sample = renoise.song().selected_sample

  if sample then
    
  else
    renoise.app():show_error("You must select a sample!")
    return
  end
  
  local dialog_content = vb:column {
    vb:row {
      vb:button {
        text = "(1) Base",
        notifier = function()
          get_note("base")
        end
      },
      
      vb:text {
        id = "base"
      }
    },
    
    vb:row {
      vb:button {
        text = "(2) Low",
        notifier = function() get_note("low") end
      },
      
      vb:text {
        id = "low"
      }
    },
    
    vb:row {
      vb:button {
        text = "(3) High",
        notifier = function() get_note("high") end
      },
      
      vb:text {
        id = "high"
      }
    }
  }
  
  display_mappings()
  
  dialog = renoise.app():show_custom_dialog(
    dialog_title, dialog_content, key_handler)
end

renoise.tool():add_menu_entry {
  name = "Sample Navigator:"..tool_name,
  invoke = show_dialog
}

renoise.tool():add_keybinding {
  name = "Sample Keyzones:Tools:" .. tool_name,
  invoke = show_dialog
}

local function on_sample_change()
  if dialog and dialog.visible then
    display_mappings()
  end
end

if not renoise.song().selected_sample_observable:has_notifier(on_sample_change) then
  renoise.song().selected_sample_observable:add_notifier(on_sample_change)
end
