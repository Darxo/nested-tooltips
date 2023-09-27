::MSU.NestedTooltips <- {
	SkillObjectsByFilename = {}
};

::MSU.QueueBucket.FirstWorldInit.push(function() {
	foreach (file in ::IO.enumerateFiles("scripts/skills"))
	{
		local skill = ::new(file);
		if (::MSU.isIn("saveBaseValues", skill, true))
		{
			skill.saveBaseValues();
			::MSU.NestedTooltips.SkillObjectsByFilename[split(file, "/").top()] <- skill;
		}
	}
});
