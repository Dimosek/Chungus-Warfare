var/datum/antagonist/raider/raiders

/datum/antagonist/raider
	id = MODE_RAIDER
	role_text = "Raider"
	role_text_plural = "Raiders"
	antag_indicator = "hudmutineer"
	landmark_id = "voxstart"
	welcome_text = "Use :H to talk on your encrypted channel."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudmutineer"

	hard_cap = 6
	hard_cap_round = 6
	initial_spawn_req = 2
	initial_spawn_target = 4
	min_player_age = 14

	id_type = /obj/item/weapon/card/id/syndicate

	faction = "pirate"

	// Heist overrides check_victory() and doesn't need victory or loss strings/tags.
	var/list/raider_uniforms = list(
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/pirate,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/serviceoveralls,
		/obj/item/clothing/under/captain_fly,
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/color/brown,
		)

	var/list/raider_shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/laceup
		)

	var/list/raider_glasses = list(
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/glasses/thermal/plain/eyepatch,
		/obj/item/clothing/glasses/thermal/plain/monocle
		)

	var/list/raider_helmets = list(
		/obj/item/clothing/head/bearpelt,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/mask/bandana/red,
		/obj/item/clothing/head/hgpiratecap,
		)

	var/list/raider_suits = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/hgpirate,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/hoodie,
		/obj/item/clothing/suit/storage/toggle/hoodie/black,
		/obj/item/clothing/suit/unathi/mantle,
		/obj/item/clothing/suit/poncho/colored,
		)

	var/list/raider_guns = list(
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/retro,
		/obj/item/weapon/gun/energy/xray,
		/obj/item/weapon/gun/energy/xray/pistol,
		/obj/item/weapon/gun/energy/mindflayer,
		/obj/item/weapon/gun/energy/toxgun,
		/obj/item/weapon/gun/energy/stunrevolver,
		/obj/item/weapon/gun/energy/ionrifle,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/gun/energy/crossbow/largecrossbow,
		/obj/item/weapon/gun/launcher/crossbow,
		/obj/item/weapon/gun/launcher/grenade/loaded,
		/obj/item/weapon/gun/launcher/pneumatic,
		/obj/item/weapon/gun/projectile/automatic/mini_uzi,
		/obj/item/weapon/gun/projectile/automatic/c20r,
		/obj/item/weapon/gun/projectile/automatic/wt550,
		/obj/item/weapon/gun/projectile/automatic/sts35,
		/obj/item/weapon/gun/projectile/silenced,
		/obj/item/weapon/gun/projectile/shotgun/pump,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/weapon/gun/projectile/colt,
		/obj/item/weapon/gun/projectile/sec,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		)

	var/list/raider_holster = list(
		/obj/item/clothing/accessory/holster/armpit,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/clothing/accessory/holster/hip
		)

/datum/antagonist/raider/New()
	..()
	raiders = src

/datum/antagonist/raider/create_global_objectives()

	if(!..())
		return 0

	var/i = 1
	var/max_objectives = pick(2,2,2,2,3,3,3,4)
	global_objectives = list()
	while(i<= max_objectives)
		var/list/goals = list("kidnap","loot","salvage")
		var/goal = pick(goals)
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		global_objectives |= O

		i++

	global_objectives |= new /datum/objective/heist/preserve_crew
	return 1

/datum/antagonist/raider/check_victory()
	// Totally overrides the base proc.
	var/win_type = "Major"
	var/win_group = "Crew"
	var/win_msg = ""

	//No objectives, go straight to the feedback.
	if(config.objectives_disabled == CONFIG_OBJECTIVE_NONE || !global_objectives.len)
		return

	var/success = global_objectives.len
	//Decrease success for failed objectives.
	for(var/datum/objective/O in global_objectives)
		if(!(O.check_completion())) success--
	//Set result by objectives.
	if(success == global_objectives.len)
		win_type = "Major"
		win_group = "Raider"
	else if(success > 2)
		win_type = "Minor"
		win_group = "Raider"
	else
		win_type = "Minor"
		win_group = "Crew"
	//Now we modify that result by the state of the vox crew.
	if(antags_are_dead())
		win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Raiders have been wiped out!</B>"
	else if(is_raider_crew_safe())
		if(win_group == "Crew" && win_type == "Minor")
			win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Raiders have left someone behind!</B>"
	else
		if(win_group == "Raider")
			if(win_type == "Minor")
				win_type = "Major"
			win_msg += "<B>The Raiders escaped!</B>"
		else
			win_msg += "<B>The Raiders were repelled!</B>"

	to_world("<span class='danger'><font size = 3>[win_type] [win_group] victory!</font></span>")
	to_world("[win_msg]")
	feedback_set_details("round_end_result","heist - [win_type] [win_group]")

/datum/antagonist/raider/proc/is_raider_crew_safe()

	if(!current_antagonists || current_antagonists.len == 0)
		return 0

	for(var/datum/mind/player in current_antagonists)
		if(!player.current || get_area(player.current) != locate(/area/skipjack_station/start))
			return 0
	return 1


/datum/antagonist/raider/proc/equip_weapons(var/mob/living/carbon/human/player)
	var/new_gun = pick(raider_guns)
	var/new_holster = pick(raider_holster) //raiders don't start with any backpacks, so let's be nice and give them a holster if they can use it.
	var/turf/T = get_turf(player)

	var/obj/item/primary = new new_gun(T)
	var/obj/item/clothing/accessory/holster/holster = null

	//Give some of the raiders a pirate gun as a secondary

	if(primary.slot_flags & SLOT_HOLSTER)
		holster = new new_holster(T)
		holster.holstered = primary
		primary.forceMove(holster)
	else if(!player.belt && (primary.slot_flags & SLOT_BELT))
		player.equip_to_slot_or_del(primary, slot_belt)
	else if(!player.back && (primary.slot_flags & SLOT_BACK))
		player.equip_to_slot_or_del(primary, slot_back)
	else
		player.put_in_any_hand_if_possible(primary)

	//If they got a projectile gun, give them a little bit of spare ammo
	equip_ammo(player, primary)

	if(holster)
		var/obj/item/clothing/under/uniform = player.w_uniform
		if(istype(uniform) && uniform.can_attach_accessory(holster))
			uniform.attackby(holster, player)
		else
			player.put_in_any_hand_if_possible(holster)

/datum/antagonist/raider/proc/equip_ammo(var/mob/living/carbon/human/player, var/obj/item/weapon/gun/gun)
	if(istype(gun, /obj/item/weapon/gun/projectile))
		var/obj/item/weapon/gun/projectile/bullet_thrower = gun
		if(bullet_thrower.magazine_type)
			player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_l_store)
			if(prob(20)) //don't want to give them too much
				player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_r_store)
		else if(bullet_thrower.ammo_type)
			var/obj/item/weapon/storage/box/ammobox = new(get_turf(player.loc))
			for(var/i in 1 to rand(3,5) + rand(0,2))
				new bullet_thrower.ammo_type(ammobox)
			player.put_in_any_hand_if_possible(ammobox)
		return

/datum/antagonist/raider/proc/equip_vox(var/mob/living/carbon/human/player)

	var/uniform_type = pick(list(/obj/item/clothing/under/vox/vox_robes,/obj/item/clothing/under/vox/vox_casual))

	player.equip_to_slot_or_del(new uniform_type(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(player), slot_shoes) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/vox(player), slot_gloves) // AS ABOVE.
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat/vox(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight(player), slot_r_store)

	player.internal = locate(/obj/item/weapon/tank) in player.contents
	if(istype(player.internal,/obj/item/weapon/tank) && player.internals)
		player.internals.icon_state = "internal1"

	return 1

