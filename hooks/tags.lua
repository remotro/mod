RE.Tags = {}

function RE.Tags.pending()
    local tags = {}
    for _, tag in pairs(G.GAME.tags) do
        table.insert(tags, RE.Tags.tag(tag))
    end
end

function RE.Tags.tag(tag)
    local kind_data = nil
    local kind = tag.key
    if kind == "tag_handy" then
        kind_data = { earnings = self.config.dollars_per_hand*(G.GAME.hands_played or 0) }
    elseif kind == "tag_skip" then
        kind_data = { earnings = self.config.skip_bonus * ((G.GAME.skips or 0) + 1) }
    elseif kind == "tag_orbital" then
        kind_data = { hand = self.ability.orbital_hand }
    elseif kind == "tag_garbage" then
        kind_data = { earnings = self.config.dollars_per_discard*(G.GAME.unused_discards or 0)  }
    end
	if kind_data then
		return { [kind] = kind_data }
	else
		return kind
	end
end