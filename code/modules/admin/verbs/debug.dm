/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if(!check_rights(R_DEBUG))	return

	if(Debug2)
		Debug2 = 0
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		Debug2 = 1
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

	feedback_add_details("admin_verb","DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

// callproc moved to code/modules/admin/callproc


/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = mob.loc

	if (!( istype(T, /turf) ))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = "<span class='notice'>Coordinates: [T.x],[T.y],[T.z]</span>\n"
	t += "<span class='warning'>Temperature: [env.temperature]</span>\n"
	t += "<span class='warning'>Pressure: [env.return_pressure()]kPa</span>\n"
	for(var/g in env.gas)
		t += "<span class='notice'>[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa</span>\n"

	usr.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/cmd_admin_animalize(var/mob/M in SSmobs.mob_list)
	set category = "Fun"
	set name = "Make Simple Animal"

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(istype(M, /mob/new_player))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()



/client/proc/cmd_admin_slimeize(var/mob/M in SSmobs.mob_list)
	set category = "Fun"
	set name = "Make slime"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has slimeized [M.key].")
		spawn(10)
			M:slimeize()
			feedback_add_details("admin_verb","MKMET") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_and_message_admins("made [key_name(M)] into a slime.")
	else
		alert("Invalid mob")

/*
/client/proc/cmd_admin_monkeyize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Monkey"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/target = M
		log_admin("[key_name(src)] is attempting to monkeyize [M.key].")
		spawn(10)
			target.monkeyize()
	else
		alert("Invalid mob")

/client/proc/cmd_admin_changelinginize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Changeling"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has made [M.key] a changeling.")
		spawn(10)
			M.absorbed_dna[M.real_name] = M.dna.Clone()
			M.make_changeling()
			if(M.mind)
				M.mind.special_role = "Changeling"
	else
		alert("Invalid mob")
*/
/*
/client/proc/cmd_admin_abominize(var/mob/M in mob_list)
	set category = null
	set name = "Make Abomination"

	to_chat(usr, "Ruby Mode disabled. Command aborted.")
	return
	if(!ticker)
		alert("Wait until the game starts.")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has made [M.key] an abomination.")

	//	spawn(10)
	//		M.make_abomination()

*/
/*
/client/proc/make_cultist(var/mob/M in mob_list) // -- TLE, modified by Urist
	set category = "Fun"
	set name = "Make Cultist"
	set desc = "Makes target a cultist"
	if(!cultwords["travel"])
		runerandom()
	if(M)
		if(M.mind in ticker.mode.cult)
			return
		else
			if(alert("Spawn that person a tome?",,"Yes","No")=="Yes")
				to_chat(M, "<span class='warning'>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie. A tome, a message from your new master, appears on the ground.</span>")
				new /obj/item/weapon/book/tome(M.loc)
			else
				to_chat(M, "<span class='warning'>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</span>")
			var/glimpse=pick("1","2","3","4","5","6","7","8")
			switch(glimpse)
				if("1")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["travel"]] is travel...</span>")
				if("2")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["blood"]] is blood...</span>")
				if("3")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["join"]] is join...</span>")
				if("4")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["hell"]] is Hell...</span>")
				if("5")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["destroy"]] is destroy...</span>")
				if("6")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["technology"]] is technology...</span>")
				if("7")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["self"]] is self...</span>")
				if("8")
					to_chat(M, "<span class='warning'>You remembered one thing from the glimpse... [cultwords["see"]] is see...</span>")

			if(M.mind)
				M.mind.special_role = "Cultist"
				ticker.mode.cult += M.mind
			to_chat(src, "Made [M] a cultist.")
*/

//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/observer, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in typesof(/obj) + typesof(/mob) - blocked
	if(hsbitem)
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				qdel(O)
		log_admin("[key_name(src)] has deleted all instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem].", 0)
	feedback_add_details("admin_verb","DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "Make Powernets"
	SSmachines.makepowernets()
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_tog_aliens()
	set category = "Server"
	set name = "Toggle Aliens"

	config.aliens_allowed = !config.aliens_allowed
	log_admin("[key_name(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].")
	message_admins("[key_name_admin(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].", 0)
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_assume_direct_control(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN))	return
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/observer/ghost/ghost = new/mob/observer/ghost(M,1)
			ghost.ckey = M.ckey
	log_and_message_admins("assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if(isghost(adminmob))
		qdel(adminmob)
	feedback_add_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!






/client/proc/cmd_admin_areatest()
	set category = "Mapping"
	set name = "Test areas"

	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for(var/area/A in world)
		if(!(A.type in areas_all))
			areas_all.Add(A.type)

	for(var/obj/machinery/power/apc/APC in world)
		var/area/A = get_area(APC)
		if(!(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/requests_console/RC in world)
		var/area/A = get_area(RC)
		if(!(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in world)
		var/area/A = get_area(L)
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in world)
		var/area/A = get_area(LS)
		if(!(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/device/radio/intercom/I in world)
		var/area/A = get_area(I)
		if(!(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in world)
		var/area/A = get_area(C)
		if(!(A.type in areas_with_camera))
			areas_with_camera.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	log_debug("<b>AREAS WITHOUT AN APC:</b>")
	for(var/areatype in areas_without_APC)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT AN AIR ALARM:</b>")
	for(var/areatype in areas_without_air_alarm)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT A REQUEST CONSOLE:</b>")
	for(var/areatype in areas_without_RC)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT ANY LIGHTS:</b>")
	for(var/areatype in areas_without_light)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT A LIGHT SWITCH:</b>")
	for(var/areatype in areas_without_LS)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT ANY INTERCOMS:</b>")
	for(var/areatype in areas_without_intercom)
		log_debug("* [areatype]")

	log_debug("<b>AREAS WITHOUT ANY CAMERAS:</b>")
	for(var/areatype in areas_without_camera)
		log_debug("* [areatype]")


/proc/dressup_human(var/mob/living/carbon/human/H, var/decl/hierarchy/outfit/outfit, var/undress = TRUE)
	if(!H || !outfit)
		return
	if(undress)
		H.delete_inventory(TRUE)
	outfit.equip(H)
	log_and_message_admins("changed the equipment of [key_name(H)] to [outfit.name].")

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(var/mob/M,var/block)
	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon))
		M.dna.SetSEState(block,!M.dna.GetSEState(block))
		domutcheck(M,null,MUTCHK_FORCED)
		M.update_mutations()
		var/state="[M.dna.GetSEState(block)?"on":"off"]"
		var/blockname=assigned_blocks[block]
		message_admins("[key_name_admin(src)] has toggled [M.key]'s [blockname] block [state]!")
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!")
	else
		alert("Invalid mob")

/datum/admins/proc/view_runtimes()
	set category = "Debug"
	set name = "View Runtimes"
	set desc = "Open the Runtime Viewer"

	if(!check_rights(R_DEBUG))
		return

	GLOB.error_cache.show_to(usr.client)

/client/proc/cmd_analyse_health_panel()
	set category = "Debug"
	set name = "Analyse Health"
	set desc = "Get an advanced health reading on a human mob."

	var/mob/living/carbon/human/H = input("Select mob.", "Analyse Health") as null|anything in GLOB.human_mob_list
	if(!H)	return

	cmd_analyse_health(H)

/client/proc/cmd_analyse_health(var/mob/living/carbon/human/H)

	if(!check_rights(R_DEBUG))
		return

	if(!H)	return

	var/dat = H.get_medical_data()

	dat += text("<BR><A href='?src=\ref[];mach_close=scanconsole'>Close</A>", usr)
	show_browser(usr, dat, "window=scanconsole;size=430x600")

/client/proc/cmd_analyse_health_context(mob/living/carbon/human/H as mob in GLOB.human_mob_list)
	set category = null
	set name = "Analyse Human Health"

	if(!check_rights(R_DEBUG))
		return
	if(!ishuman(H))	return
	cmd_analyse_health(H)
	feedback_add_details("admin_verb","ANLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/obj/effect/debugmarker
	icon = 'icons/effects/lighting_overlay.dmi'
	icon_state = "transparent"
	plane = ABOVE_TURF_PLANE
	layer = HOLOMAP_LAYER
	alpha = 127
