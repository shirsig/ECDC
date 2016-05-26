function ECDC_OnLoad()
	ECDC_ToolTips = {};
	ECDC_ToolTipDetails = {};
	ECDC_ErrCountdown = 13;
	ECDC_UsedSkills = {};
	ECDC_UpdateInterval = 0.1;
	ECDC_TimeSinceLastUpdate = 0;

	ECDC_GAINS = "(.+) gains (.+).";
	ECDC_ABILITY_HITS = "(.+)'s (.+) hits (.+) for (.+)";
	ECDC_ABILITY_CRITS = "(.+)'s (.+) crits (.+) for (.+)";
	ECDC_ABILITY_ABSORB = "(.+)'s (.+) is absorbed by (.+).";
	ECDC_ABILITY_PERFORM = "(.+) performs (.+).";
	ECDC_ABILITY_CHARGE = "(.+) gains (.+) Rage from (.+)'s Charge.";
	ECDC_ABILITY_CAST = "(.+) casts (.+).";

	ECDC_LoadSkills();
	ECDC_Activate();
end

function ECDC_ToggleStack(setPos)
	if (setPos == "Verti") then
		ECDC_Pos = "Verti";
		ECDC_Tex1:ClearAllPoints(); ECDC_Tex1:SetPoint("TOP", "ECDC", "BOTTOM", 0, 3);
		ECDC_Tex2:ClearAllPoints(); ECDC_Tex2:SetPoint("TOP", "ECDC_Tex1", "BOTTOM", 0, 0);
		ECDC_Tex3:ClearAllPoints(); ECDC_Tex3:SetPoint("TOP", "ECDC_Tex2", "BOTTOM", 0, 0);
		ECDC_Tex4:ClearAllPoints(); ECDC_Tex4:SetPoint("TOP", "ECDC_Tex3", "BOTTOM", 0, 0);
		ECDC_Tex5:ClearAllPoints(); ECDC_Tex5:SetPoint("TOP", "ECDC_Tex4", "BOTTOM", 0, 0);
		ECDC_Tex6:ClearAllPoints(); ECDC_Tex6:SetPoint("TOP", "ECDC_Tex5", "BOTTOM", 0, 0);
		ECDC_Tex7:ClearAllPoints(); ECDC_Tex7:SetPoint("TOP", "ECDC_Tex6", "BOTTOM", 0, 0);
		ECDC_Tex8:ClearAllPoints(); ECDC_Tex8:SetPoint("TOP", "ECDC_Tex7", "BOTTOM", 0, 0);
		ECDC_Tex9:ClearAllPoints(); ECDC_Tex9:SetPoint("TOP", "ECDC_Tex8", "BOTTOM", 0, 0);
		ECDC_Tex10:ClearAllPoints(); ECDC_Tex10:SetPoint("TOP", "ECDC_Tex9", "BOTTOM", 0, 0);
	elseif (setPos == "Hori") then
		ECDC_Pos = "Hori";
		ECDC_Tex1:ClearAllPoints(); ECDC_Tex1:SetPoint("LEFT", "ECDC", "RIGHT", 0, 0);
		ECDC_Tex2:ClearAllPoints(); ECDC_Tex2:SetPoint("LEFT", "ECDC_Tex1", "RIGHT", 0, 0);
		ECDC_Tex3:ClearAllPoints(); ECDC_Tex3:SetPoint("LEFT", "ECDC_Tex2", "RIGHT", 0, 0);
		ECDC_Tex4:ClearAllPoints(); ECDC_Tex4:SetPoint("LEFT", "ECDC_Tex3", "RIGHT", 0, 0);
		ECDC_Tex5:ClearAllPoints(); ECDC_Tex5:SetPoint("LEFT", "ECDC_Tex4", "RIGHT", 0, 0);
		ECDC_Tex6:ClearAllPoints(); ECDC_Tex6:SetPoint("LEFT", "ECDC_Tex5", "RIGHT", 0, 0);
		ECDC_Tex7:ClearAllPoints(); ECDC_Tex7:SetPoint("LEFT", "ECDC_Tex6", "RIGHT", 0, 0);
		ECDC_Tex8:ClearAllPoints(); ECDC_Tex8:SetPoint("LEFT", "ECDC_Tex7", "RIGHT", 0, 0);
		ECDC_Tex9:ClearAllPoints(); ECDC_Tex9:SetPoint("LEFT", "ECDC_Tex8", "RIGHT", 0, 0);
		ECDC_Tex10:ClearAllPoints(); ECDC_Tex10:SetPoint("LEFT", "ECDC_Tex9", "RIGHT", 0, 0);
	end
end

function ECDC_Click()
	if (arg1 == "LeftButton") then	
		if (ECDC_Activated == 0) then 
			ECDC_Activate(); 
		else 
			ECDC_Deactivate(); 
		end;
	elseif (arg1 == "RightButton") then
		if (ECDC_Pos == "Hori") then
			ECDC_ToggleStack("Verti");
		elseif (ECDC_Pos == "Verti") then
			ECDC_ToggleStack("Hori");
		else
			-- If its nothing.. set it to something!
			ECDC_ToggleStack("Verti");
		end
	end
end

function ECDC_Activate()
	ECDC_Activated = 1;
	ECDC_Button:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Abilities-Up.blp");

	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");

	this:RegisterEvent("ADDON_LOADED");
 end

function ECDC_Deactivate()
	ECDC_Activated = 0;
	ECDC_Button:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-Abilities-Disabled.blp");

	-- Someone gains something.
	this:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS");
	this:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_ENEMYPLAYER_BUFFS");
	this:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS");

	-- Someone's something hits/crits someone for #.
	this:UnregisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE");
	this:UnregisterEvent("CHAT_MSG_SPELL_ENEMYPLAYER_DAMAGE");
end

function ECDC_ToolTip(tooltipnum)
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:AddLine(ECDC_ToolTips[tooltipnum]);
	GameTooltip:AddLine(ECDC_ToolTipDetails[tooltipnum], .8, .8, .8, 1);
	GameTooltip:Show();
end

function ECDC_OnEvent(event)
	if event == 'ADDON_LOADED' and arg1 == 'ECDC' then
		ECDC_ToggleStack(ECDC_Pos)
		if ECDC_Locked then
			ECDC_Button:Hide()
		end
	end
	-- For gains
	for player, spell in string.gfind(arg1, ECDC_GAINS) do
		if (ECDC_GetSkillCooldown(spell) ~= ECDC_ErrCountdown) then
			table.insert(ECDC_UsedSkills, {player = player, skill = spell, info = ECDC_GetInfo(spell), texture = ECDC_GetTexture(spell), countdown = ECDC_GetSkillCooldown(spell), started = time()});
		end
	end
	-- For performs
	for player, spell in string.gfind(arg1, ECDC_ABILITY_PERFORM) do
		if (ECDC_GetSkillCooldown(spell) ~= ECDC_ErrCountdown) then
			table.insert(ECDC_UsedSkills, {player = player, skill = spell, info = ECDC_GetInfo(spell), texture = ECDC_GetTexture(spell), countdown = ECDC_GetSkillCooldown(spell), started = time()});
		end
	end
	-- For hits
	for player, spell, afflictee, damage in string.gfind(arg1, ECDC_ABILITY_HITS) do
		if (ECDC_GetSkillCooldown(spell) ~= ECDC_ErrCountdown) then
			table.insert(ECDC_UsedSkills, {player = player, skill = spell, info = ECDC_GetInfo(spell), texture = ECDC_GetTexture(spell), countdown = ECDC_GetSkillCooldown(spell), started = time()});
		end
	end
	-- For crits
	for player, spell, afflictee, damage in string.gfind(arg1, ECDC_ABILITY_CRITS) do
		if (ECDC_GetSkillCooldown(spell) ~= ECDC_ErrCountdown) then
			table.insert(ECDC_UsedSkills, {player = player, skill = spell, info = ECDC_GetInfo(spell), texture = ECDC_GetTexture(spell), countdown = ECDC_GetSkillCooldown(spell), started = time()});
		end
	end
	-- For absorbs
	for player, spell, afflictee in string.gfind(arg1, ECDC_ABILITY_ABSORB) do
		if (ECDC_GetSkillCooldown(spell) ~= ECDC_ErrCountdown) then
			table.insert(ECDC_UsedSkills, {player = player, skill = spell, info = ECDC_GetInfo(spell), texture = ECDC_GetTexture(spell), countdown = ECDC_GetSkillCooldown(spell), started = time()});
		end
	end
	-- For charge (Warriors)
	for player, rage, player in string.gfind(arg1, ECDC_ABILITY_CHARGE) do
		if (ECDC_GetSkillCooldown("Charge") ~= ECDC_ErrCountdown) then
			table.insert(ECDC_UsedSkills, {player = player, skill = "Charge", info = ECDC_GetInfo("Charge"), texture = ECDC_GetTexture("Charge"), countdown = ECDC_GetSkillCooldown("Charge"), started = time()});
		end
	end
	-- For casts
	for player, spell in string.gfind(arg1, ECDC_ABILITY_CAST) do
		if (ECDC_GetSkillCooldown(spell) ~= ECDC_ErrCountdown) then
			table.insert(ECDC_UsedSkills, {player = player, skill = spell, info = ECDC_GetInfo(spell), texture = ECDC_GetTexture(spell), countdown = ECDC_GetSkillCooldown(spell), started = time()});
		end
	end
end

function ECDC_OnUpdate(elapsed)
	ECDC_TimeSinceLastUpdate = ECDC_TimeSinceLastUpdate + elapsed;
	if (ECDC_TimeSinceLastUpdate > ECDC_UpdateInterval) then
		ECDC_TimeSinceLastUpdate = 0;
		-- Spit out the infoz
		local i = 1;
		for k, v in pairs(ECDC_UsedSkills) do
			local timeleft = (v.countdown - (time() - v.started));
			--	  Only show CD for our target if there is time left on the CD      Loop through Stuff           Warrior enrage isnt a CD, Druid Enrage is!
			if ((v.player == UnitName("target")) and (timeleft > 0) and (timeleft ~= nil) and (i < 11) and not(UnitClass("target") == "Warrior" and v.skill == "Enrage") and (ECDC_ToolTips[(i-1)] ~= v.skill)) then
				ECDC_ToolTips[i] = v.skill;
				ECDC_ToolTipDetails[i] = v.info;
				if (timeleft > 60) then
					timeleft = floor((timeleft/60)*10)/10;
					getglobal("ECDC_CD"..i):SetTextColor(0, 1, 0);
				else
					getglobal("ECDC_CD"..i):SetTextColor(1, 1, 0);
				end
				getglobal("ECDC_CD"..i):SetText(timeleft);
				getglobal("ECDC_Tex"..i):SetTexture("Interface\\Icons\\"..v.texture);
				getglobal("ECDC_Frame"..i):Show();
				getglobal("ECDC_CD"..i):Show();
				getglobal("ECDC_Tex"..i):Show();
				i = i + 1;
			end
		end
		while (i < 11) do
			getglobal("ECDC_Frame"..i):Hide();
			getglobal("ECDC_CD"..i):Hide();
			getglobal("ECDC_Tex"..i):Hide();
			i = i + 1;
		end
	end
end

function ECDC_GetTexture(skill)
	for k, v in pairs(ECDC_Skills) do 
		if (v.name == skill) then
			SkillTexture = v.icon;
		end
	end;
	return SkillTexture;	
end

function ECDC_GetInfo(skill)
	for k, v in pairs(ECDC_Skills) do 
		if (v.name == skill) then
			SkillInfo = v.desc;
		end
	end;
	return SkillInfo;	
end

function ECDC_GetSkillCooldown(skill)
	local SkillCountdown = 30;
	for k, v in pairs(ECDC_Skills) do 
		if (v.name == skill) then
			SkillCountdown = v.cooldown;
			break;
		else
			SkillCountdown = ECDC_ErrCountdown;
		end
	end;
	return SkillCountdown;
end

function ECDC_OnDragStart()
	ECDC:StartMoving()
end

function ECDC_OnDragStop()
	ECDC:StopMovingOrSizing()
end

function ECDC_LoadSkills()
	ECDC_Skills = {
		-- Exclusively Talent Cooldowns
		{name = "Blade Flurry", cooldown = 120, desc = "Unknown!", icon = "Temp"},
		{name = "Adrenaline Rush", cooldown = (6*60), desc = "Unknown!", icon = "Temp"},
		{name = "Preparation", cooldown = 600, desc = "Unknown!", icon = "Temp"},
		{name = "Ghostly Strike", cooldown = 20, desc = "Unknown!", icon = "Temp"},
		{name = "Premeditation", cooldown = 60, desc = "Unknown!", icon = "Temp"},
		{name = "Cold Blood", cooldown = 180, desc = "Unknown!", icon = "Temp"},

		{name = "Bestial Wrath", cooldown = 120, desc = "Unknown!", icon = "Temp"},
		{name = "Intimidation", cooldown = 60, desc = "Unknown!", icon = "Temp"},
		{name = "Detterance", cooldown = (5*60), desc = "Unknown!", icon = "Temp"},
		{name = "Scattershot", cooldown = 30, desc = "Unknown!", icon = "Temp"},

		{name = "Last Stand", cooldown = 600, desc = "Unknown!", icon = "Temp"},

		{name = "Inner Focus", cooldown = 180, desc = "Unknown!", icon = "Temp"},
		{name = "Power Infusion", cooldown = 180, desc = "Unknown!", icon = "Temp"},
		{name = "Silence", cooldown = 45, desc = "Unknown!", icon = "Temp"},

		{name = "Elemental Mastery", cooldown = 180, desc = "Unknown!", icon = "Temp"},
		{name = "Stormstrike", cooldown = 20, desc = "Unknown!", icon = "Temp"},
		{name = "Nature's Swiftness", cooldown = 180, desc = "Unknown!", icon = "Temp"},

		{name = "Fel Domination", cooldown = (15*60), desc = "Unknown!", icon = "Temp"},

		{name = "Divine Favor", cooldown = 120, desc = "Unknown!", icon = "Temp"},
		{name = "Holy Shock", cooldown = 30, desc = "Unknown!", icon = "Temp"},
		{name = "Holy Shield", cooldown = 10, desc = "Unknown!", icon = "Temp"},
		{name = "Repentance", cooldown = 60, desc = "Unknown!", icon = "Temp"},

		{name = "Innervate", cooldown = (6*60), desc = "Unknown!", icon = "Temp"},
		{name = "Faerie Fire (Feral)", cooldown = 6, desc = "Unknown!", icon = "Temp"},
		{name = "Feral Charge", cooldown = 15, desc = "Unknown!", icon = "Temp"},
		{name = "Swiftmend", cooldown = 15, desc = "Unknown!", icon = "Temp"},

		{name = "Presence of Mind", cooldown = 180, desc = "Unknown!", icon = "Temp"},
		{name = "Arcane Power", cooldown = 180, desc = "Unknown!", icon = "Spell_Nature_Lightning"},
		{name = "Combustion", cooldown = 180, desc = "Unknown!", icon = "Temp"},
		{name = "Cold Snap", cooldown = (10*60), desc = "Unknown!", icon = "Temp"},
		{name = "Ice Block", cooldown = (5*60), desc = "Unknown!", icon = "Temp"},

		-- Trinkets & Racials
		{name = "Will of the Forsaken", cooldown = 120, desc = "Unknown!", icon = "Spell_Shadow_RaiseDead"},
		{name = "Perception", cooldown = 180, desc = "Unknown!", icon = "Spell_Nature_Sleep"},
		{name = "War Stomp", cooldown = 120, desc = "Unknown!", icon = "Ability_WarStomp"},
		{name = "Stoneform", cooldown = 180, desc = "Unknown!", icon = "Spell_Shadow_UnholyStrength"},

		{name = "Brittle Armor", cooldown = 120, desc = "Unknown!", icon = "Spell_Shadow_GrimWard"},
		{name = "Unstable Power", cooldown = 120, desc = "Unknown!", icon = "Spell_Lightning_LightningBolt01"},
		{name = "Restless Strength", cooldown = 120, desc = "Unknown!", icon = "Spell_Shadow_GrimWard"},
		{name = "Ephemeral Power", cooldown = 90, desc = "Unknown!", icon = "Spell_Holy_MindVision"},
		{name = "Massive Destruction", cooldown = 180, desc = "Unknown!", icon = "Spell_Fire_WindsofWoe"},
		{name = "Arcane Potency", cooldown = 180, desc = "Unknown!", icon = "Spell_Arcane_StarFire"},
		{name = "Energized Shield", cooldown = 180, desc = "Unknown!", icon = "Spell_Nature_CallStorm"},
		{name = "Brilliant Light", cooldown = 180, desc = "Unknown!", icon = "Spell_Holy_MindVision"},
		{name = "Mar'li's Brain Boost", cooldown = 180, desc = "Unknown!", icon = "INV_ZulGurubTrinket"},
		{name = "Gift of Life", cooldown = 300, desc = "Unknown!", icon = "INV_Misc_Gem_Pearl_05"},
		{name = "Nature Aligned", cooldown = 300, desc = "Unknown!", icon = "Spell_Nature_SpiritArmor"},
		{name = "Earthstrike", cooldown = 120, desc = "Unknown!", icon = "Spell_Nature_AbolishMagic"},

		{name = "Frost Recleftor", cooldown = 300, desc = "Unknown!", icon = "Spell_Frost_FrostWard"},
		{name = "Shadow Reflector", cooldown = 300, desc = "Unknown!", icon = "Spell_Shadow_AntiShadow"},
		{name = "Fire Reflector", cooldown = 300, desc = "Unknown!", icon = "Spell_Fire_SealOfFire"},

		{name = "First Aid", cooldown = 60, desc = "Unknown!", icon = "Spell_Holy_Heal"},

		-- Warriors
		{name = "Charge", cooldown = 15, desc = "Charge an enemy, generate 15 rage, and stun it for 1 sec. Cannot be used in combat.", icon = "Ability_Warrior_Charge"},
		{name = "Mocking Blow", cooldown = 120, desc = "A mocking attack that causes 93 damage, a moderate amount of threat and forces the target to focus attacks on you for 6 sec.", icon = "Ability_Warrior_PunishingBlow"},
		{name = "Mortal Strike", cooldown = 6, desc = "A vicious strike that deals weapon damage plus 160 and wounds the target, reducing the effectiveness of any healing by 50% for 10 sec.", icon = "Ability_Warrior_SavageBlow"},
		{name = "Overpower", cooldown = 5, desc = "Instantly overpower the enemy, causing weapon damage plus 35. Only useable after the target dodges. The Overpower cannot be blocked, dodged or parried.", icon = "Ability_MeleeDamage"},
		{name = "Retaliation", cooldown = (30*60), desc = "Instantly counterattack any enemy that strikes you in melee for 15 sec. Melee attacks made from behind cannot be counterattacked. A maximum of 30 attacks will cause retaliation.", icon = "Ability_Warrior_Challange"},
		{name = "Thunder Clap", cooldown = 4, desc = "Blasts nearby enemies with thunder slowing their attack speed by 10% for 30 sec and doing 103 damage to them. Will affect up to 4 targets.", icon = "Spell_Nature_ThunderClap"},
		{name = "Berserker Rage", cooldown = 30, desc = "The warrior enters a berserker rage, becoming immune to Fear and Incapacitate effects and generating extra rage when taking damage. Lasts 10 sec.", icon = "Spell_Nature_AncestralGuardian"},
		{name = "Bloodthirst", cooldown = 6, desc = "Instantly attack the target causing damage equal to 45% of your attack power. In addition, the next 5 successful melee attacks will restore 20 health. This effect lasts 8 sec.", icon = "Spell_Nature_BloodLust"},
		{name = "Challenging Shout", cooldown = 600, desc = "Forces all nearby enemies to focus attacks on you for 6 sec.", icon = "Ability_BullRush"},
		{name = "Intercept Stun", cooldown = 30, desc = "Charge an enemy, causing 65 damage and stunning it for 3 sec.", icon = "Ability_Rogue_Sprint"},
		{name = "Intimidating Shout", cooldown = 180, desc = "The warrior shouts, causing the targeted enemy to cower in fear. Up to 5 total nearby enemies will flee in fear. Lasts 8 sec.", icon = "Ability_GolemThunderClap"},
		{name = "Pummel", cooldown = 10, desc = "Pummel the target for 50 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.", icon = "INV_Gauntlets_04"},
		{name = "Recklessness", cooldown = (30*60), desc = "The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.", icon = "Ability_CriticalStrike"},
		{name = "Whirlwind", cooldown = 10, desc = "In a whirlwind of steel you attack up to 4 enemies within 8 yards, causing weapon damage to each enemy.", icon = "Ability_Whirlwind"},
		{name = "Bloodrage", cooldown = 60, desc = "Generates 10 rage at the cost of health, and then generates an additional 10 rage over 10 sec. The warrior is considered in combat for the duration.", icon = "Ability_Racial_BloodRage"},
		{name = "Disarm", cooldown = 60, desc = "Disarm the enemy's weapon for 10 sec.", icon = "Ability_Warrior_Disarm"},
		{name = "Revenge", cooldown = 5, desc = "Instantly counterattack an enemy for 81 to 99 damage and a high amount of threat. Revenge must follow a block, dodge or parry.", icon = "Ability_Warrior_Revenge"},
		{name = "Shield Bash", cooldown = 12, desc = "Bashes the target with your shield for 45 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 6 sec.", icon = "Ability_Warrior_ShieldBash"},
		{name = "Shield Block", cooldown = 5, desc = "Increases chance to block by 75% for 5 sec, but will only block 1 attack.", icon = "Ability_Defend"},
		{name = "Shield Slam", cooldown = 6, desc = "Slam the target with your shield, causing 342 to 358 damage, modified by your shield block value, and has a 50% chance of dispelling 1 magic effect on the target. Also causes a high amount of threat.", icon = "INV_Shield_05"},
		{name = "Shield Wall", cooldown = (30*60), desc = "Reduces the damage taken from melee attacks, ranged attacks and spells by 75% for 10 sec.", icon = "Ability_Warrior_ShieldWall"},

		-- Paladin
		{name = "Consecration", cooldown = 8, desc = "Consecrates the land beneath Paladin, doing 384 Holy damage over 8 sec to enemies who enter the area.", icon = "Spell_Holy_InnerFire"},
		{name = "Exorcism", cooldown = 15, desc = "Causes 505 to 563 Holy damage to an Undead or Demon target.", icon = "Spell_Holy_Excorcism_02"},
		{name = "Hammer of Wrath", cooldown = 6, desc = "Hurls a hammer that strikes an enemy for 304 to 336 Holy damage. Only usable on enemies that have 20% or less health.", icon = "Ability_ThunderClap"},
		{name = "Holy Wrath", cooldown = 60, desc = "Sends bolts of holy power in all directions, causing 490 to 576 Holy damage to all Undead and Demon targets within 20 yds.", icon = "Spell_Holy_Excorcism"},
		{name = "Lay on Hands", cooldown = (60*60), desc = "Heals a friendly target for an amount equal to the Paladin's maximum health and restores 550 of their mana. Drains all of the Paladin's remaining mana when used.", icon = "Spell_Holy_LayOnHands"},
		{name = "Turn Undead", cooldown = 30, desc = "The targeted undead enemy will be compelled to flee for up to 20 sec. Damage caused may interrupt the effect. Only one target can be turned at a time.", icon = "Spell_Holy_TurnUndead"},
		{name = "Blessing of Freedom", cooldown = 20, desc = "Places a Blessing on the friendly target, granting immunity to movement impairing effects for 10 sec. Players may only have one Blessing on them per Paladin at any one time.", icon = "Spell_Holy_SealOfValor"},
		{name = "Blessing of Protection", cooldown = (5*60), desc = "A targeted party member is protected from all physical attacks for 10 sec, but during that time they cannot attack or use physical abilities. Players may only have one Blessing on them per Paladin at any one time. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_SealOfProtection"},
		{name = "Divine Intervention", cooldown = (60*60), desc = "The paladin sacrifices himself to remove the targeted party member from harms way. Enemies will stop attacking the protected party member, who will be immune to all harmful attacks but cannot take any action for 3 min.", icon = "Spell_Nature_TimeStop"},
		{name = "Divine Protection", cooldown = (5*60), desc = "You are protected from all physical attacks and spells for 8 sec, but during that time you cannot attack or use physical abilities yourself. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_Restoration"},
		{name = "Divine Shield", cooldown = (5*60), desc = "Protects the paladin from all damage and spells for 12 sec, but reduces attack speed by 50%. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.", icon = "Spell_Holy_DivineIntervention"},
		{name = "Hammer of Justice", cooldown = 60, desc = "Stuns the target for 6 sec.", icon = "Spell_Holy_SealOfMight"},
		{name = "Judgement", cooldown = 10, desc = "Unleashes the energy of a Seal spell upon an enemy. Refer to individual Seals for Judgement effect.", icon = "Spell_Holy_RighteousFury"},

		-- Mage
		{name = "Blink", cooldown = 15, desc = "Teleports the caster 20 yards forward, unless something is in the way. Also frees the caster from stuns and bonds.", icon = "Spell_Arcane_Blink"},
		{name = "Portal: Darnassus", cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Darnassus.", icon = "Spell_Arcane_PortalDarnassus"},
		{name = "Portal: Ironforge", cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Ironforge.", icon = "Spell_Arcane_PortalIronForge"},
		{name = "Portal: Orgrimmar", cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Orgrimmar.", icon = "Spell_Arcane_PortalOrgrimmar"},
		{name = "Portal: Stormwind", cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Stormwind.", icon = "Spell_Arcane_PortalStormWind"},
		{name = "Portal: Thunder Bluff", cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Thunder Bluff.", icon = "Spell_Arcane_PortalThunderBluff"},
		{name = "Portal: Undercity", cooldown = 60, desc = "Creates a portal, teleporting group members that use it to Undercity.", icon = "Spell_Arcane_PortalUnderCity"},
		{name = "Blast Wave", cooldown = 45, desc = "A wave of flame radiates outward from the caster, damaging all enemies caught within the blast for 462 to 544 Fire damage, and dazing them for 6 sec.", icon = "Spell_Holy_Excorcism_02"},
		{name = "Fire Blast", cooldown = 8, desc = "Blasts the enemy for 431 to 509 Fire damage.", icon = "Spell_Fire_Fireball"},
		{name = "Fire Ward", cooldown = 30, desc = "Absorbs 920 Fire damage. Lasts 30 sec.", icon = "Spell_Fire_FireArmor"},
		{name = "Cone of Cold", cooldown = 10, desc = "Targets in a cone in front of the caster take 335 to 365 Frost damage and are slowed by 50% for 8 sec.", icon = "Spell_Frost_Glacier"},
		{name = "Frost Nova", cooldown = 25, desc = "Blasts enemies near the caster for 71 to 79 Frost damage and freezes them in place for up to 8 sec. Damage caused may interrupt the effect.", icon = "Spell_Frost_FrostNova"},
		{name = "Frost Ward", cooldown = 30, desc = "Absorbs 920 Frost damage. Lasts 30 sec.", icon = "Spell_Frost_FrostWard"},
		{name = "Ice Barrier", cooldown = 30, desc = "Instantly shields you, absorbing 818 damage. Lasts 1 min. While the shield holds, spells will not be interrupted.", icon = "Spell_Ice_Lament"},

		-- Rogues
		{name = "Kidney Shot", cooldown = 20, desc = "Finishing move that stuns the target. Lasts longer per combo point.", icon = "Ability_Rogue_KidneyShot"},
		{name = "Evasion", cooldown = (5*60), desc = "The rogue's dodge chance will increase by 50% for 15 sec.", icon = "Spell_Shadow_ShadowWard"},
		{name = "Feint", cooldown = 10, desc = "Performs a feint, causing no damage but lowering your threat by a large amount, making the enemy less likely to attack you.", icon = "Ability_Rogue_Feint"},
		{name = "Gouge", cooldown = 6, desc = "Causes 75 damage, incapacitating the opponent for 4 sec, and turns off your attack. Target must be facing you. Any damage caused will revive the target. Awards 1 combo point.", icon = "Ability_Gouge"},
		{name = "Kick", cooldown = 10, desc = "A quick kick that injures a single foe for 80 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 5 sec.", icon = "Ability_Kick"},
		{name = "Sprint", cooldown = (5*60), desc = "Increases the rogue's movement speed by 70% for 15 sec. Does not break stealth.", icon = "Ability_Rogue_Sprint"},
		{name = "Blind", cooldown = (5*60), desc = "Blinds the target, causing it to wander disoriented for up to 10 sec. Any damage caused will remove the effect.", icon = "Spell_Shadow_MindSteal"},
		{name = "Distract", cooldown = 30, desc = "Throws a distraction, attracting the attention of all nearby monsters for 10 seconds. Does not break stealth.", icon = "Ability_Rogue_Distract"},
		{name = "Stealth", cooldown = 10, desc = "Allows the rogue to sneak around, but reduces your speed by 30%. Lasts until cancelled.", icon = "Ability_Stealth"},
		{name = "Vanish", cooldown = (5*60), desc = "Allows the rogue to vanish from sight, entering an improved stealth mode for 10 sec. Also breaks movement impairing effects. More effective than Vanish (Rank 1).", icon = "Ability_Vanish"},

		-- Shaman
		{name = "Chain Lightning", cooldown = 6, desc = "Hurls a lightning bolt at the enemy, dealing 493 to 551 Nature damage and then jumping to additional nearby enemies. Each jump reduces the damage by 30%. Affects 3 total targets.", icon = "Spell_Nature_ChainLightning"},
		{name = "Earth Shock", cooldown = 6, desc = "Instantly shocks the target with concussive force, causing 517 to 545 Nature damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 2 sec. Causes a high amount of threat.", icon = "Spell_Nature_EarthShock"},
		{name = "Earthbind Totem", cooldown = 15, desc = "Summons an Earthbind Totem with 5 health at the feet of the caster for 45 sec that slows the movement speed of enemies within 10 yards.", icon = "Spell_Nature_StrengthOfEarthTotem02"},
		{name = "Fire Nova Totem", cooldown = 15, desc = "Summons a Fire Nova Totem that has 5 health and lasts 5 sec. Unless it is destroyed within 4 sec., the totem inflicts 396 to 442 fire damage to enemies within 10 yd.", icon = "Spell_Fire_SealOfFire"},
		{name = "Flame Shock", cooldown = 6, desc = "Instantly sears the target with fire, causing 292 Fire damage immediately and 320 Fire damage over 12 sec.", icon = "Spell_Fire_FlameShock"},
		{name = "Frost Shock", cooldown = 6, desc = "Instantly shocks the target with frost, causing 486 to 514 Frost damage and slowing movement speed by 50%. Lasts 8 sec.", icon = "Spell_Frost_FrostShock"},
		{name = "Stoneclaw Totem", cooldown = 30, desc = "Summons a Stoneclaw Totem with 480 health at the feet of the caster for 15 sec that taunts creatures within 8 yards to attack it.", icon = "Spell_Nature_StoneClawTotem"},
		{name = "Astral Recall", cooldown = (15*60), desc = "Yanks the caster through the twisting nether back to [home]. Speak to an Innkeeper in a different place to change your home location.", icon = "Spell_Nature_AstralRecal"},
		{name = "Grounding Totem", cooldown = 15, desc = "Summons a Grounding Totem with 5 health at the feet of the caster that will redirect one harmful spell cast on a nearby party member to itself every 10 seconds. Will not redirect area of effect spells. Lasts 45 sec.", icon = "Spell_Nature_GroundingTotem"},
		{name = "Mana Tide Totem", cooldown = (5*60), desc = "Summons a Mana Tide Totem with 5 health at the feet of the caster for 12 sec that restores 290 mana every 3 seconds to group members within 20 yards.", icon = "Spell_Frost_SummonWaterElemental"},

		-- Hunters
		{name = "Scare Beast", cooldown = 30, desc = "Scares a beast, causing it to run in fear for up to 20 sec. Damage caused may interrupt the effect. Only one beast can be feared at a time.", icon = "Ability_Druid_Cower"},
		{name = "Tranquilizing Shot", cooldown = 20, desc = "Attempts to remove 1 Frenzy effect from an enemy creature.", icon = "Spell_Nature_Drowsy"},
		{name = "Arcane Shot", cooldown = 6, desc = "An instant shot that causes 183 Arcane damage.", icon = "Ability_ImpalingBolt"},
		{name = "Concussive Shot", cooldown = 12, desc = "Dazes the target, slowing movement speed by 50% for 4 sec.", icon = "Spell_Frost_Stun"},
		{name = "Distracting Shot", cooldown = 8, desc = "Distract the target, causing threat.", icon = "Spell_Arcane_Blink"},
		{name = "Flare", cooldown = 15, desc = "Exposes all hidden and invisible enemies within 10 yards of the targeted area for 30 sec.", icon = "Spell_Fire_Flare"},
		{name = "Multi-Shot", cooldown = 10, desc = "Fires several missiles, hitting 3 targets for an additional 150 damage.", icon = "Ability_UpgradeMoonGlaive"},
		{name = "Rapid Fire", cooldown = (5*60), desc = "Increases ranged attack speed by 40% for 15 sec.", icon = "Ability_Hunter_RunningShot"},
		{name = "Volley", cooldown = 60, desc = "Continuously fires a volley of ammo at the target area, causing 80 Arcane damage to enemy targets within 8 yards every second for 6 sec.", icon = "Ability_Marksmanship"},
		{name = "Counterattack", cooldown = 5, desc = "A strike that becomes active after parrying an opponent's attack. This attack deals 110 damage and immobilizes the target for 5 sec. Counterattack cannot be blocked, dodged, or parried.", icon = "Ability_Warrior_Challange"},
		{name = "Disengage", cooldown = 5, desc = "Attempts to disengage from the target, reducing threat. More effective than Disengage (Rank 2). Character exits combat mode.", icon = "Ability_Rogue_Feint"},
		{name = "Explosive Trap", cooldown = 15, desc = "Place a fire trap that explodes when an enemy approaches, causing 201 to 257 Fire damage and 330 additional Fire damage over 20 sec to all within 10 yards. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Fire_SelfDestruct"},
		{name = "Feign Death", cooldown = 30, desc = "Feign death which may trick enemies into ignoring you. Lasts up to 6 min.", icon = "Ability_Rogue_FeignDeath"},
		{name = "Freezing Trap", cooldown = 15, desc = "Place a frost trap that freezes the first enemy that approaches, preventing all action for up to 20 sec. Any damage caused will break the ice. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Frost_ChainsOfIce"},
		{name = "Frost Trap", cooldown = 15, desc = "Place a frost trap that creates an ice slick around itself for 30 sec when the first enemy approaches it. All enemies within 10 yards will be slowed by 60% while in the area of effect. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Frost_FreezingBreath"},
		{name = "Immolation Trap", cooldown = 15, desc = "Place a fire trap that will burn the first enemy to approach for 690 Fire damage over 15 sec. Trap will exist for 1 min. Traps can only be placed when out of combat. Only one trap can be active at a time.", icon = "Spell_Fire_FlameShock"},
		{name = "Mongoose Bite", cooldown = 5, desc = "Counterattack the enemy for 115 damage. Can only be performed after you dodge.", icon = "Ability_Hunter_SwiftStrike"},
		{name = "Raptor Strike", cooldown = 6, desc = "A strong attack that increases melee damage by 140.", icon = "Ability_MeleeDamage"},
		{name = "Wyvern Sting", cooldown = 120, desc = "A stinging shot that puts the target to sleep for 12 sec. Any damage will cancel the effect. When the target wakes up, the Sting causes 600 Nature damage over 12 sec. Only usable out of combat. Only one Sting per Hunter can be active on the target at a time.", icon = "INV_Spear_02"},

		-- Warlocks
		{name = "Curse of Doom", cooldown = 60, desc = "Curses the target with impending doom, causing 3200 Shadow damage after 1 min. If the target dies from this damage, there is a chance that a Doomguard will be summoned. Cannot be cast on players.", icon = "Spell_Shadow_AuraOfDarkness"},
		{name = "Death Coil", cooldown = 120, desc = "Causes the enemy target to run in horror for 3 sec and causes 470 Shadow damage. The caster gains 100% of the damage caused in health.", icon = "Spell_Shadow_DeathCoil"},
		{name = "Howl of Terror", cooldown = 40, desc = "Howl, causing 5 enemies within 10 yds to flee in terror for 15 sec. Damage caused may interrupt the effect.", icon = "Spell_Shadow_DeathScream"},
		{name = "Inferno", cooldown = (60*60), desc = "Summons a meteor from the Twisting Nether, causing 200 Fire damage and stunning all enemy targets in the area for 2 sec. An Infernal rises from the crater, under the command of the caster for 5 min. Once control is lost, the Infernal must be Enslaved to maintain control. Can only be used outdoors.", icon = "Spell_Shadow_SummonInfernal"},
		{name = "Ritual of Doom", cooldown = (60*60), desc = "Begins a ritual that sacrifices a random participant to summon a doomguard. The doomguard must be immediately enslaved or it will attack the ritual participants. Requires the caster and 4 additional party members to complete the ritual. In order to participate, all players must right-click the portal and not move until the ritual is complete.", icon = "Spell_Shadow_AntiMagicShell"},
		{name = "Shadow Ward", cooldown = 30, desc = "Absorbs 920 shadow damage. Lasts 30 sec.", icon = "Spell_Shadow_AntiShadow"},
		{name = "Conflagrate", cooldown = 10, desc = "Ignites a target that is already afflicted by Immolate, dealing 447 to 557 Fire damage and consuming the Immolate spell.", icon = "Spell_Fire_Fireball"},
		{name = "Shadowburn", cooldown = 15, desc = "Instantly blasts the target for 450 to 502 Shadow damage. If the target dies within 5 sec of Shadowburn, and yields experience or honor, the caster gains a Soul Shard.", icon = "Spell_Shadow_ScourgeBuild"},
		{name = "Soul Fire", cooldown = 60, desc = "Burn the enemy's soul, causing 703 to 881 Fire damage.", icon = "Spell_Fire_Fireball02"},
		{name = "Devour Magic", cooldown = 8, desc = "Purges 1 harmful magic effect from a friend or 1 beneficial magic effect from an enemy. If an effect is devoured, the Felhunter will be healed for 579.", icon = "Spell_Nature_Purge"},
		{name = "Spell Lock", cooldown = 30, desc = "Silences the enemy for 3 sec. If used on a casting target, it will counter the enemy's spellcast, preventing any spell from that school of magic from being cast for 8 sec.", icon = "Spell_Shadow_MindRot"},
		{name = "Lash of Pain", cooldown = 12, desc = "An instant attack that lashes the target, causing 99 Shadow damage.", icon = "Spell_Shadow_Curse"},
		{name = "Soothing Kiss", cooldown = 4, desc = "Soothes the target, increasing the chance that it will attack something else. More effective than Soothing Kiss (Rank 3).", icon = "Spell_Shadow_SoothingKiss"},

		-- Priest
		{name = "Elune's Grace", cooldown = (5*60), desc = "Reduces ranged damage taken by 95 and increases chance to dodge by 10% for 15 sec.", icon = "Spell_Holy_ElunesGrace"},
		{name = "Feedback", cooldown = (3*60), desc = "The priest becomes surrounded with anti-magic energy. Any successful spell cast against the priest will burn 105 of the attacker's Mana, causing 1 Shadow damage for each point of Mana burned. Lasts 15 sec.", icon = "Spell_Shadow_RitualOfSacrifice"},
		{name = "Power Word: Shield", cooldown = 4, desc = "Draws on the soul of the party member to shield them, absorbing 942 damage. Lasts 30 sec. While the shield holds, spellcasting will not be interrupted by damage. Once shielded, the target cannot be shielded again for 15 sec.", icon = "Spell_Holy_PowerWordShield"},
		{name = "Desperate Prayer", cooldown = 600, desc = "Instantly heals the caster for 1324 to 1562.", icon = "Spell_Holy_Restoration"},
		{name = "Fear Ward", cooldown = 30, desc = "Wards the friendly target against Fear. The next Fear effect used against the target will fail, using up the ward. Lasts 10 min.", icon = "Spell_Holy_Excorcism"},
		{name = "Devouring Plague", cooldown = 180, desc = "Afflicts the target with a disease that causes 904 Shadow damage over 24 sec. Damage caused by the Devouring Plague heals the caster.", icon = "Spell_Shadow_BlackPlague"},
		{name = "Fade", cooldown = 30, desc = "Fade out, discouraging enemies from attacking you for 10 sec. More effective than Fade (rank 5).", icon = "Spell_Magic_LesserInvisibilty"},
		{name = "Mind Blast", cooldown = 8, desc = "Blasts the target for 503 to 531 Shadow damage, but causes a high amount of threat.", icon = "Spell_Shadow_UnholyFrenzy"},
		{name = "Psychic Scream", cooldown = 30, desc = "The caster lets out a psychic scream, causing 5 enemies within 8 yards to flee for 8 sec. Damage caused may interrupt the effect.", icon = "Spell_Shadow_PsychicScream"},
		
		-- Druid
		{name = "Barkskin", cooldown = 60, desc = "The druid's skin becomes as tough as bark. Physical damage taken is reduced by 20%. While protected, damaging attacks will not cause spellcasting delays but non-instant spells take 1 sec longer to cast and melee combat is slowed by 20%. Lasts 15 sec.", icon = "Spell_Nature_StoneClawTotem"},
		{name = "Faerie Fire", cooldown = 6, desc = "Decrease the armor of the target by 505 for 40 sec. While affected, the target cannot stealth or turn invisible.", icon = "Spell_Nature_FaerieFire"},
		{name = "Hurricane", cooldown = 60, desc = "Creates a violent storm in the target area causing 134 Nature damage to enemies every 1 sec, and reducing the attack speed of enemies by 20%. Lasts 10 sec. Druid must channel to maintain the spell.", icon = "Spell_Nature_Cyclone"},
		{name = "Nature's Grasp", cooldown = 60, desc = "While active, any time an enemy strikes the caster they have a 35% chance to become afflicted by Entangling Roots (Rank 6). Only useable outdoors. 1 charge. Lasts 45 sec.", icon = "Spell_Nature_NaturesWrath"},
		{name = "Bash", cooldown = 60, desc = "Stuns the target for 4 sec.", icon = "Ability_Druid_Bash"},
		{name = "Challenging Roar", cooldown = 600, desc = "Forces all nearby enemies to focus attacks on you for 6 sec.", icon = "Ability_Druid_ChallangingRoar"},
		{name = "Cower", cooldown = 10, desc = "Cower, causing no damage but lowering your threat a large amount, making the enemy less likely to attack you.", icon = "Ability_Druid_Cower"},
		{name = "Dash", cooldown = 300, desc = "Increases movement speed by 60% for 15 sec. Does not break prowling.", icon = "Ability_Druid_Dash"},
		{name = "Enrage", cooldown = 60, desc = "Generates 20 rage over 10 sec, but reduces base armor by 27% in Bear Form and 16% in Dire Bear Form. The druid is considered in combat for the duration.", icon = "Ability_Druid_Enrage"},
		{name = "Frenzied Regeneration", cooldown = 180, desc = "Converts up to 10 rage per second into health for 10 sec. Each point of rage is converted into 20 health.", icon = "Ability_BullRush"},
		{name = "Prowl", cooldown = 10, desc = "Allows the Druid to prowl around, but reduces your movement speed by 30%. Lasts until cancelled.", icon = "Ability_Ambush"},
		{name = "Tiger's Fury", cooldown = 1, desc = "Increases damage done by 40 for 6 sec.", icon = "Ability_Mount_JungleTiger"},
		{name = "Rebirth", cooldown = (30*60), desc = "Returns the spirit to the body, restoring a dead target to life with 2200 health and 2800 mana.", icon = "Spell_Nature_Reincarnation"},
		{name = "Tranquility", cooldown = (5*60), desc = "Regenerates all nearby group members for 294 every 2 seconds for 10 sec. Druid must channel to maintain the spell.", icon = "Spell_Nature_Tranquility"}
	};
end

SLASH_ECDC1 = '/ecdc'
function SlashCmdList.ECDC()
	ECDC_Locked = not ECDC_Locked
	if ECDC_Locked then
		ECDC_Button:Hide()
	else
		ECDC_Button:Show()
	end
end