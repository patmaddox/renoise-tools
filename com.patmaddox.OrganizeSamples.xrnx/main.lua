-- OrganizeSamples
-- Pat Maddox

local options = renoise.Document.create("OrganizeSamples") { }
renoise.tool().preferences = options

local function organize_samples()
  local instrument = renoise.song().selected_instrument
  local group_names = {}
  local group_order = {}

  for i, sample in ipairs(instrument.samples) do
    if group_names[sample.name] == nil then
      group_names[sample.name] = 0
      group_order[#group_order+ 1] = sample.name
    end
  
    group_names[sample.name] = group_names[sample.name] + 1
  end

  local offsets = {}
  local total_offset = 0

  for i, group_name in ipairs(group_order) do
    local offset = group_names[group_name]
    offsets[group_name] = total_offset
    total_offset = total_offset + offset
  end

  for i, group_name in ipairs(group_order) do
    for j, sample in ipairs(instrument.samples) do
      if sample.name == group_name and j > offsets[sample.name] then
        offsets[sample.name] = offsets[sample.name] + 1
      
        if instrument.samples[offsets[sample.name]].name ~= group_name then
          instrument:swap_samples_at(j, offsets[sample.name])
        end
      end
    end
  end
end

renoise.tool():add_menu_entry {
  name = "Sample Navigator:Organize Samples",
  invoke = organize_samples
}
