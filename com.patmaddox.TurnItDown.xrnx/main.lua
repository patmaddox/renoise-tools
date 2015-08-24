-- TurnItDown
-- Pat Maddox

-- local options = renoise.Document.create("TurnItDown") { }
-- renoise.tool().preferences = options

local function attenuate_samples(context)
  if context and context.type == "insert" then
    local attenuation = 0.25118863582611; -- -12.00 dB
    renoise.song().selected_instrument:sample(context.index).volume = attenuation;
  end
end

local function on_instrument_selected()
  if not renoise.song().selected_instrument.samples_observable:has_notifier(attenuate_samples) then
    renoise.song().selected_instrument.samples_observable:add_notifier(attenuate_samples);
  end
end

local function on_song_created()
  renoise.song().selected_instrument_observable:add_notifier(on_instrument_selected);
  on_instrument_selected(); -- for the first instrument
end

-- add new song observer
if not renoise.tool().app_new_document_observable:has_notifier(on_song_created) then
  renoise.tool().app_new_document_observable:add_notifier(on_song_created);
end

