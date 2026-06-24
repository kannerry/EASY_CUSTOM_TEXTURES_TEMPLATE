local mod = SMODS.current_mod
local target_dir = "Mods/" .. mod.id .. "/assets/1x"
local files = love.filesystem.getDirectoryItems(target_dir)

local base_cards = {}
local variant_cards = {}
local soul_sprites = {}
local custom_cards = {}
local custom_cards_alt = {}

local function key_to_name(k)
    local stripped = k:match("^[^_]+_(.+)$") or k
    return (stripped:gsub("[^%a]", " "):gsub("(%a)([%w_]*)", function(a, b)
        return a:upper() .. b:lower()
    end))
end

local key_to_set = {}
for set_name, key_list in pairs(Malverk.keys) do
    for _, k in ipairs(key_list) do
        key_to_set[k] = set_name
    end
end

local function get_set(key)
    if key_to_set[key] then return key_to_set[key] end
        local prefix = key:match("^([^_]+)_")
        if prefix == "j" then return "Joker"
        elseif prefix == "v" then return "Voucher"
        elseif prefix == "p" then return "Booster"
        elseif prefix == "m" then return "Enhanced"
        elseif prefix == "bl" then return "Blind"
        elseif prefix == "b" then return "Back"    
        elseif prefix == "stake" then return "Stake"   
        elseif prefix == "tag" then return "Tag"
        elseif prefix == "c" then return "Spectral"
    end
    return "Joker"
end

for _, file in ipairs(files) do
    if file:match("%.png$") then
        local atlas_key = file:sub(1, -5)
        local base_key, variant_tag = atlas_key:match("^([^-]+)-(.+)$")
        local actual_base = base_key or atlas_key

        local card_data = {
            atlas_key = atlas_key,
            base_key = actual_base,
            file = file,
            set = get_set(actual_base)
        }

        if variant_tag and variant_tag ~= "soul" then
            table.insert(variant_cards, card_data)
        else
            table.insert(base_cards, card_data)
            if variant_tag == "soul" then
                soul_sprites[actual_base] = file
            end
        end
    end
end

for _, card in ipairs(base_cards) do
    local soul_file = soul_sprites[card.base_key]
    
    AltTexture({
        key = card.atlas_key,
        set = card.set,
        path = card.file,
        keys = {card.base_key},
        loc_txt = {name = key_to_name(card.atlas_key)},
        soul = soul_file,
        soul_keys = soul_file and {card.base_key} or nil
    })
    
    table.insert(custom_cards, mod.prefix .. "_" .. card.atlas_key)
end

for _, card in ipairs(variant_cards) do
    AltTexture({
        key = card.atlas_key,
        set = card.set,
        path = card.file,
        keys = {card.base_key},
        loc_txt = {name = key_to_name(card.atlas_key)}
    })
    table.insert(custom_cards_alt, mod.prefix .. "_" .. card.atlas_key)
    table.insert(custom_cards, mod.prefix .. "_" .. card.atlas_key)
end

for i, key in ipairs(custom_cards) do
    if key == mod.prefix .. "_" .. mod.display_card then
        table.remove(custom_cards, i)
        table.insert(custom_cards, 1, key)
        break
    end
end

TexturePack({
    key = mod.id,
    textures = custom_cards,
    toggle_textures = custom_cards_alt,
    loc_txt = {
        name = mod.name,
        text = { mod.description }
    }
})