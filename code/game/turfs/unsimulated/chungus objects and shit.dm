turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1

turf/unsimulated/wall/chung
	name = "Chungium Wall"
	desc= "wall made out of pure chungus"
	icon = 'icons/turf/walls.dmi'
	icon_state = "chungus"


turf/unsimulated/wall/noob
	name = "NOOBium Wall"
	desc = "wall made out of pure noob"
	icon = 'icons/turf/walls.dmi'
	icon_state = "noob"





obj/machinery/light/chungus_shrine
	name = "Shrine to big chungus"
	icon = 'icons/shrine.dmi'
	icon_state = "chungus"
	on = 1
	light_range = 100
	light_power = 100
	layer = 5
obj/machinery/light/noob_shrine
	name = "Shrine to the holy noob"
	desc = "wall made out of pure noob"
	icon = 'icons/shrine.dmi'
	icon_state = "noob"
	on = 1
	light_range = 100
	light_power = 100
	layer = 5



obj/selfdestruct
	name = "Self-Destruct Button"
	desc = "press this to blow up the townhall"
	icon = 'icons/button.dmi'
	icon_state = "butt"
	var/friendly
obj/selfdestruct/chungus
	friendly = CHUNGUS_TEAM
obj/selfdestruct/noob
	friendly = NOOB_TEAM

obj/selfdestruct/attack_hand(mob/living/carbon/human/user)
	if(user.team == friendly)
		to_chat(user,"i won't blow up my own townhall")
	else if(do_after(user, 10 SECONDS))
		visible_message("<span class='danger'>\The [src] attempts to activate \the button!</span>")
		to_chat(world, "<br><br><br><H1> [friendly] BASE HAS BEEN BLOWN UP BY [user]([user.client])</H1>")
		SSticker.force_ending = 1
		ticker.current_state = GAME_STATE_FINISHED
		Master.SetRunLevel(RUNLEVEL_POSTGAME)
		spawn
			ticker.declare_completion()
		log_and_message_admins("initiated a game ending.")
		sleep(450)
		qdel_self()
		world.Reboot()


obj/capturebt
	name = "Capture Point Button"
	desc = "Press this to capture the point"
	icon = 'icons/button.dmi'
	icon_state = "butt"
	var/team
	var/score_timer = 100


obj/capturebt/New()
	capture_point_list += src





obj/capturebt/attack_hand(mob/living/carbon/human/user)
	if(user.team == team)
		to_chat(user,"the point is already captured by our team")
	else if(do_after(user, 1 SECONDS))
		team = user.team
		to_chat(world, "<br><br><H2> [name] has been captured by [user]([user.client]) for the team: [team]</H2>")





obj/structure/dispenser
	name = "Dispenser"
	desc = "Gives engineers more resources"
	icon = 'icons/obj/structures.dmi'
	health = 25
	maxhealth =25
	icon_state = "dispenser"
	anchored = 1
	density = 1


obj/structure/dispenser/New()
	playsound(usr.loc, 'sound/items/dispenser.ogg',100)
	DispenseLoop()
	


obj/structure/dispenser/proc/DispenseLoop()
	while(TRUE)
		var/obj/item/stack/material/wood/W = new /obj/item/stack/material/wood(loc)
		W.amount = rand(1,10)
		sleep(100)