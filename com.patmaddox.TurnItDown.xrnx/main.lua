-- TurnItDown
-- Pat Maddox

-- local options = renoise.Document.create("TurnItDown") { }
-- renoise.tool().preferences = options

local function attenuate_sample(sample)
  local attenuation = 0.25118863582611; -- -12.00 dB
  sample.volume = attenuation;
end

local function on_samples_changed(instrument, context)
  rprint(context);
  if context and context.type == "insert" then
    local sample = instrument:sample(context.index);
    attenuate_sample(sample);
  end
end

local function add_on_samples(instrument)
  if not instrument.samples_observable:has_notifier(on_samples_changed) then
    instrument.samples_observable:add_notifier(instrument, on_samples_changed);
  end
end

local function on_instrument_added(context)
  if context and context.type == "insert" then
    local instrument = renoise.song():instrument(context.index);
    add_on_samples(instrument);

    for i, sample in ipairs(instrument.samples) do
      attenuate_sample(sample);
    end
  end
end

local function on_song_created()
  renoise.song().instruments_observable:add_notifier(on_instrument_added);
  for i, instrument in ipairs(renoise.song().instruments) do
    add_on_samples(instrument);
  end
end

-- add new song observer
if not renoise.tool().app_new_document_observable:has_notifier(on_song_created) then
  renoise.tool().app_new_document_observable:add_notifier(on_song_created);
end

