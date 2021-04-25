var/global/datum/controller/gameticker/ticker

/datum/controller/gameticker
	var/const/restart_timeout = 600
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/post_game = 0
	var/event_time = null
	var/event = 0

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/Bible_icon_state	// icon_state the chaplain has chosen for his bible
	var/Bible_item_state	// item_state the chaplain has chosen for his bible
	var/Bible_name			// name of the bible
	var/Bible_deity_name

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of traitor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = 0
	var/gamemode_voted = 0

	var/delay_end = 0	//if set to nonzero, the round will not restart on it's own

	var/triai = 0//Global holder for Triumvirate

	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	var/list/antag_pool = list()
	var/looking_for_antags = 0

/datum/controller/gameticker/proc/pregame()
	do
		if(!gamemode_voted)
			pregame_timeleft = 60
		else
			pregame_timeleft = 15
			if(!isnull(secondary_mode))
				master_mode = secondary_mode
				secondary_mode = null
			else if(!isnull(tertiary_mode))
				master_mode = tertiary_mode
				tertiary_mode = null
			else
				master_mode = "extended"

		to_world("<b>Trying to start [master_mode]...</b>")
		to_world("<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>")
		to_world("Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds")

		while(current_state == GAME_STATE_PREGAME)
			for(var/i=0, i<10, i++)
				sleep(1)
				vote.process()
			if(round_progressing)
				pregame_timeleft--
			if(pregame_timeleft == config.vote_autogamemode_timeleft && !gamemode_voted)
				gamemode_voted = 1
				if(!vote.time_remaining)
					vote.autogamemode()	//Quit calling this over and over and over and over.
					while(vote.time_remaining)
						for(var/i=0, i<10, i++)
							sleep(1)
							vote.process()
			if(pregame_timeleft <= 0 || ((initialization_stage & INITIALIZATION_NOW_AND_COMPLETE) == INITIALIZATION_NOW_AND_COMPLETE))
				current_state = GAME_STATE_SETTING_UP
				Master.SetRunLevel(RUNLEVEL_SETUP)

	while (!setup())


/datum/controller/gameticker/proc/setup()

	//todopossibly use gamemode

	GLOB.using_map.setup_economy()
	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)
	create_characters() //Create player characters and transfer them
	collect_minds()

	equip_characters()

	callHook("roundstart")

	spawn(0)//Forking here so we dont have to wait for this to finish
		to_world("<FONT color='blue'><B>Enjoy the game!</B></FONT>")
		sound_to(world, sound(GLOB.using_map.welcome_sound))

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2adminirc("Round has started with no admins online.")


	processScheduler.start()

	if(config.sql_enabled)
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return 1

/datum/controller/gameticker
	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
	proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
		if( cinematic )	return	//already a cinematic in progress!

		//initialise our cinematic screen object
		cinematic = new(src)
		cinematic.icon = 'icons/effects/station_explosion.dmi'
		cinematic.icon_state = "station_intact"
		cinematic.plane = HUD_PLANE
		cinematic.layer = HUD_ABOVE_ITEM_LAYER
		cinematic.mouse_opacity = 0
		cinematic.screen_loc = "1,0"

		var/obj/structure/bed/temp_buckle = new(src)
		//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
		if(station_missed)
			for(var/mob/living/M in GLOB.living_mob_list_)
				M.buckled = temp_buckle				//buckles the mob so it can't do anything
				if(M.client)
					M.client.screen += cinematic	//show every client the cinematic
		else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
			for(var/mob/living/M in GLOB.living_mob_list_)
				M.buckled = temp_buckle
				if(M.client)
					M.client.screen += cinematic

				switch(M.z)
					if(0)	//inside a crate or something
						var/turf/T = get_turf(M)
						if(T && T.z in GLOB.using_map.station_levels)				//we don't use M.death(0) because it calls a for(/mob) loop and
							M.health = 0
							M.set_stat(DEAD)
					if(1)	//on a z-level 1 turf.
						M.health = 0
						M.set_stat(DEAD)

		
		sleep(300)

		if(cinematic)	qdel(cinematic)		//end the cinematic
		if(temp_buckle)	qdel(temp_buckle)	//release everybody
		return


	proc/create_characters()
		for(var/mob/new_player/player in GLOB.player_list)
			if(player && player.ready && player.mind)
				if(!player.mind.assigned_role)
					continue
				else
					var/mob/living/carbon/human/char = player.create_character(get_turf(job_master.get_roundstart_spawnpoint(player.mind.assigned_role)))
					if(char)
						char.fully_replace_character_name(char.client.prefs.real_name)
						qdel(player)


	proc/collect_minds()
		for(var/mob/living/player in GLOB.player_list)
			if(player.mind)
				ticker.minds += player.mind


	proc/equip_characters()
		var/captainless=1
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(player && player.mind && player.mind.assigned_role)
				if(player.mind.assigned_role == "Captain")
					captainless=0
		if(captainless)
			for(var/mob/M in GLOB.player_list)
				if(!istype(M,/mob/new_player))
					to_chat(M, "Captainship not forced on anyone.")


	proc/process()
		if(current_state != GAME_STATE_PLAYING)
			return 0


		return 1
