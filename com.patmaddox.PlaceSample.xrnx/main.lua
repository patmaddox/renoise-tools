-- Reload the script whenever this file is saved. 
-- Additionally, execute the attached function.
_AUTO_RELOAD_DEBUG = function()
  show_dialog()
end

-- local dialog = nil
local vb = nil
local key_to_set = nil

function get_note(note_type)
  key_to_set = vb.views[note_type]
  key_to_set.text = "type a key..."
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

local function key_handler(dialog, key)
  if key_to_set then
    if key.note then
      local note = key.note
      local octave = renoise.song().transport.octave
      local note_name = keys[key.note + 1] .. "-" .. octave
      key_to_set.text = note_name
    end
    
    key_to_set = nil
  end
end

function show_dialog()
--  if dialog and dialog.visible then
--    dialog:show()
--    return
--  end
 
  vb = renoise.ViewBuilder()

  local DEFAULT_DIALOG_MARGIN = 
    renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
  local DEFAULT_CONTROL_SPACING = 
    renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
  local DEFAULT_BUTTON_HEIGHT =
    renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT   
  local TEXT_ROW_WIDTH = 100
  local WIDE = 180

  local dialog_title = "Place Sample"
  local dialog_buttons = {"Close"};
  
  local dialog_content = vb:column {
    vb:row {
      vb:button {
        text = "Base Note",
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
        text = "Low note"
      },
      
      vb:text {
        id = "low"
      }
    },
    
    vb:row {
      vb:button {
        text = "High note"
      },
      
      vb:text {
        id = "high"
      }
    }
  }
  
  local dialog = renoise.app():show_custom_dialog(
    dialog_title, dialog_content, key_handler)
end
