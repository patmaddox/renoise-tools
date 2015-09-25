-- Reload the script whenever this file is saved. 
-- Additionally, execute the attached function.
_AUTO_RELOAD_DEBUG = function()
  show_dialog()
end

local dialog = nil
local vb = nil

function show_dialog()
  if dialog and dialog.visible then
    dialog:show()
    return
  end
 
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
        text = "Base Note"
      },
      
      vb:text {
        text = "da base"
      }
    },
    
    vb:row {
      vb:button {
        text = "Low note"
      },
      
      vb:text {
        text = "low"
      }
    },
    
    vb:row {
      vb:button {
        text = "High note"
      },
      
      vb:text {
        text = "high"
      }
    },
    
    vb:row {
      vb:text {
        text = "hello"
      }
    }
  }
  
  dialog = renoise.app():show_custom_dialog(
    dialog_title, dialog_content)
end
