#define CHUNGUS_TEAM "Chungus"
#define NOOB_TEAM "Noob"
var/global/noob_tickets
var/global/chungus_tickets
SUBSYSTEM_DEF(ticket)
	name = "Ticket"
	flags = SS_KEEP_TIMING
	wait = 20                       //time to wait (in deciseconds) between each call to fire(). Must be a positive integer.
	var/c_points = 0
	var/n_points = 0
	var/counter = 100

/datum/controller/subsystem/ticket/Initialize()
	. = ..()
	chungus_tickets = 500
	noob_tickets = 500


/datum/controller/subsystem/ticket/fire()
	c_points = 0
	n_points = 0
	for(var/obj/capturebt/B in capture_point_list)
		if(B.team == CHUNGUS_TEAM)
			c_points++
		else if (B.team == NOOB_TEAM)
			n_points++
	if(c_points>n_points)
		noob_tickets += n_points - c_points
	else if(n_points>c_points)
		chungus_tickets += c_points - n_points

	if(noob_tickets<=0)
		end(CHUNGUS_TEAM)
		return
	else if(chungus_tickets<=0)
		end(NOOB_TEAM)
		return

	counter--
	if(counter<= 0)
		display_tickets()
		counter=100




/datum/controller/subsystem/ticket/proc/display_tickets()
	to_chat(world, "<br><br><H1>CURRENT SCORE:</H1>")
	to_chat(world, "<br><br><H1>Chungus Tickets:[chungus_tickets] Noob Tickets:[noob_tickets]</H1>")




/datum/controller/subsystem/ticket/proc/end(var/winteam)
	display_tickets()
	sleep(1)
	to_chat(world, "<br><br><H1>[winteam] team has won!</H1>")
	sleep(10)
	SSticker.force_ending = 1
	ticker.current_state = GAME_STATE_FINISHED
	Master.SetRunLevel(RUNLEVEL_POSTGAME)
	spawn
		ticker.declare_completion()
	log_and_message_admins("initiated a game ending.")
	sleep(450)
	world.Reboot()