::MSU.Mod.Tooltips.setTooltips({
	CharacterStats = ::MSU.Class.CustomTooltip(@(_data) ::TooltipEvents.general_queryUIElementTooltipData(null, "character-stats." + _data.ExtraData, null)),
	Perk = ::MSU.Class.CustomTooltip(function(_data) {
		local filename = _data.ExtraData;
		if (filename in ::MSU.NestedTooltips.PerkIDByFilename) return ::TooltipEvents.general_queryUIPerkTooltipData(null, ::MSU.NestedTooltips.PerkIDByFilename[_data.ExtraData]);
		return ::TooltipEvents.general_querySkillNestedTooltipData(null, null, filename);
	}),
	Skill = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		local entityId = "entityId" in _data ? _data.entityId : null;
		local skillId = arr.len() > 1 && arr[1] != "null" ? arr[1] : null;
		return ::TooltipEvents.general_querySkillNestedTooltipData(entityId, skillId, arr[0])
	}),
	// Sometimes you need to show the nested tooltip by considering the entity to be null. This is useful for
	// e.g. showing nested tooltips of StatusEffects inside perk tooltips on the perk tree window when the selected
	// character has the StatusEffect. Using the standard Skill+filename will show the tooltip of the effect based on that character
	// whereas we want to show a generic tooltip independent of the entity.
	NullEntitySkill = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		local skillId = arr.len() > 1 && arr[1] != "null" ? arr[1] : null;
		return ::TooltipEvents.general_querySkillNestedTooltipData(null, skillId, arr[0])
	}),
	Item = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		local entityId = "entityId" in _data ? _data.entityId : null;
		local itemId = arr.len() > 1 && arr[1] != "null" ? arr[1] : null;
		local itemOwner = arr.len() > 2 && arr[2] != "null" ? arr[2] : null;
		return ::TooltipEvents.general_queryItemNestedTooltipData(entityId, itemId, itemOwner, arr[0])
	}),
});

local tooltipImageKeywords = {
	"ui/icons/action_points.png" 		: "CharacterStats+ActionPoints"
	"ui/icons/health.png" 				: "CharacterStats+Hitpoints"
	"ui/icons/morale.png" 				: "CharacterStats+Morale"
	"ui/icons/fatigue.png" 				: "CharacterStats+Fatigue"
	"ui/icons/armor_head.png" 			: "CharacterStats+ArmorHead"
	"ui/icons/armor_body.png" 			: "CharacterStats+ArmorBody"
	"ui/icons/melee_skill.png"  		: "CharacterStats+MeleeSkill"
	"ui/icons/ranged_skill.png" 		: "CharacterStats+RangeSkill"
	"ui/icons/melee_defense.png" 		: "CharacterStats+MeleeDefense"
	"ui/icons/ranged_defense.png" 		: "CharacterStats+RangeDefense"
	"ui/icons/vision.png" 				: "CharacterStats+SightDistance"
	"ui/icons/regular_damage.png" 		: "CharacterStats+RegularDamage"
	"ui/icons/armor_damage.png" 		: "CharacterStats+CrushingDamage"
	"ui/icons/chance_to_hit_head.png" 	: "CharacterStats+ChanceToHitHead"
	"ui/icons/initiative.png" 			: "CharacterStats+Initiative"
	"ui/icons/bravery.png" 				: "CharacterStats+Bravery"
}

::MSU.QueueBucket.AfterHooks.push(function()
{
	foreach (perk in ::Const.Perks.LookupMap)
	{
		local filename = split(perk.Script, "/").top();
		tooltipImageKeywords[perk.Icon] <- "Perk+" + filename;
		::MSU.NestedTooltips.PerkIDByFilename[filename] <- perk.ID;
	}
	::MSU.Mod.Tooltips.setTooltipImageKeywords(tooltipImageKeywords);
});
