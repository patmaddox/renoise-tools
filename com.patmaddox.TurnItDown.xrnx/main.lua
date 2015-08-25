-- TurnItDown
-- Pat Maddox

-- local options = renoise.Document.create("TurnItDown") { }
-- renoise.tool().preferences = options

local function attenuate_sample(sample)
  local attenuation = 0.25118863582611; -- -12.00 dB
  sample.volume = attenuation;
end

local function on_samples(context)
  if context and context.type == "insert" then
    local sample = renoise.song().selected_instrument:sample(context.index);
    attenuate_sample(sample);
  end
end

local function add_on_samples(instrument)
  if not instrument.samples_observable:has_notifier(on_samples) then
    instrument.samples_observable:add_notifier(on_samples);
  end
end

local function remove_on_samples(instrument)
  if instrument.samples_observable:has_notifier(on_samples) then
    instrument.samples_observable:remove_notifier(on_samples);
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

local function set_up_instrument_handlers()
  renoise.song().instruments_observable:add_notifier(on_instrument_added);

  for i, instrument in ipairs(renoise.song().instruments) do
    add_on_samples(instrument);
  end
end

local function remove_instrument_handlers()
  if renoise.song().instruments_observable:has_notifier(on_instrument_added) then
    renoise.song().instruments_observable:remove_notifier(on_instrument_added);
  end

  for i, instrument in ipairs(renoise.song().instruments) do
    remove_on_samples(instrument);
  end
end

local function on_disk_browser()
  if renoise.app().window.disk_browser_is_visible then
    set_up_instrument_handlers();
  else
    remove_instrument_handlers();
  end
end

local function on_song_created()
  if not renoise.app().window.disk_browser_is_visible_observable:has_notifier(on_disk_browser) then
    renoise.app().window.disk_browser_is_visible_observable:add_notifier(on_disk_browser);
  end

  on_disk_browser();
end

-- add new song observer
if not renoise.tool().app_new_document_observable:has_notifier(on_song_created) then
  renoise.tool().app_new_document_observable:add_notifier(on_song_created);
end

