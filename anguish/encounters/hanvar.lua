--[[
Warden_Hanvar (317002)
Chains of Anguish: 5682 45s
Feedback Dispersion: 5681 30s
Wail of Anguish: 5678 45s

- 5 adds spawn at 100, 75, 50, 25 and you cannot dps him down until the adds are dead.
-adds re-spawn 2 minutes after they die

a_seasoned_guard  (317017)
a_veteran_guard   (317015)	
a_weathered_guard (317016)
an_elite_guard    (317018)
--]]
local min_hp=100;

function Hanvar_Spawn(e)
    min_hp=100;
end

function Hanvar_Combat(e)
  if (e.joined == true) then
    --e.self:Say("");
	Spawn_Adds(e);
	eq.set_timer("adds", 120 * 1000);	
	eq.set_timer("chains", math.random(10,45) * 1000);
	eq.set_timer("feedback", math.random(10,30) * 1000);
	eq.set_timer("wail", math.random(10,45) * 1000);
	eq.set_timer("check_hp", 1000);
	eq.stop_timer("reset");
  else
    eq.set_timer("reset", 300 * 1000);
	eq.stop_timer("adds");
	eq.stop_timer("chains");
	eq.stop_timer("feedback");
	eq.stop_timer("wail");
	eq.stop_timer("check_hp");
  end
end

function Spawn_Adds(e)
	--spawn 5 adds
	eq.spawn2(eq.ChooseRandom(317015,317016,317017,317018),0,0, 297, 4347, 209.9, 64);
	eq.spawn2(eq.ChooseRandom(317015,317016,317017,317018),0,0, 297, 4427, 209.9, 64);
	eq.spawn2(eq.ChooseRandom(317015,317016,317017,317018),0,0, 458, 4490, 209.9, 148);
	eq.spawn2(eq.ChooseRandom(317015,317016,317017,317018),0,0, 381, 4394, 209.9, 64);
	eq.spawn2(eq.ChooseRandom(317015,317016,317017,317018),0,0, 456, 4322, 209.9, 246);
	local npc_list =  eq.get_entity_list():GetNPCList();
	for npc in npc_list.entries do
		if (npc.valid and (npc:GetNPCTypeID() == 317015 or npc:GetNPCTypeID() == 317016 or npc:GetNPCTypeID() == 317017 or npc:GetNPCTypeID() == 317018)) then
			npc:AddToHateList(e.self:GetHateRandom(),1);
		end
	end		
end

function Guard_Death(e)
  min_hp=min_hp-5;
end

function Hanvar_Timer(e)
	if (e.timer == "check_hp") then
		if (e.self:GetHPRatio() < min_hp) then
			local new_hp = e.self:GetMaxHP() * (min_hp/100);
			-- eq.zone_emote(15, e.self:GetNPCTypeID() .. " Boss HP PCT: " .. boss_hp .. " new_hp: " .. new_hp);
			e.self:SetHP(min_hp);		
		end	
	elseif (e.timer == "chains") then
		e.self:CastSpell(5682, e.self:GetTarget():GetID());
		eq.set_timer("chains",45*1000); 
	elseif (e.timer == "feedback") then
		e.self:CastSpell(5681, e.self:GetTarget():GetID());
		eq.set_timer("feedback",30*1000); 
	elseif (e.timer == "wail") then
		e.self:CastSpell(5678, e.self:GetTarget():GetID());
		eq.set_timer("wail",45*1000); 
	elseif (e.timer == "adds") then		
		Spawn_Adds(e);
	elseif (e.timer == "reset") then
		min_hp=100;
		eq.depop_all(317015);
		eq.depop_all(317016);
		eq.depop_all(317017);
		eq.depop_all(317018);
    end
end

function Hanvar_Death(e)

end

function event_encounter_load(e)
  eq.register_npc_event('hanvar', Event.spawn,          317002, Hanvar_Spawn); 
  eq.register_npc_event('hanvar', Event.combat,         317002, Hanvar_Combat); 
  eq.register_npc_event('hanvar', Event.timer,          317002, Hanvar_Timer);
  eq.register_npc_event('hanvar', Event.death_complete, 317002, Hanvar_Death);
  eq.register_npc_event('hanvar', Event.death_complete, 317015, Guard_Death);  
  eq.register_npc_event('hanvar', Event.death_complete, 317016, Guard_Death);
  eq.register_npc_event('hanvar', Event.death_complete, 317017, Guard_Death);
  eq.register_npc_event('hanvar', Event.death_complete, 317018, Guard_Death);  
end

function event_encounter_unload(e)
end