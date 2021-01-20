/obj/structure/punching_bag
	name = "punching bag"
	desc = "A punching bag. Can you get to speed level 4???"
	icon = 'icons/obj/fitness.dmi'
	icon_state = "punchingbag"
	anchored = 1
	layer = ABOVE_DOOR_LAYER
	var/list/hit_sounds = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg',\
	'sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')

/obj/structure/punching_bag/attack_hand(mob/user as mob)
	flick("[icon_state]2", src)
	playsound(src.loc, pick(src.hit_sounds), 25, 1, -1)
	if(user.statcheck(user.stats[STAT_ST], 13, "You miss all your punches, and they feel weak and wimpy.  You need more training.", STAT_ST))
		var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
		to_chat(user, "[finishmessage]")

/obj/structure/stacklifter
	name = "Weight Machine"
	desc = "Just looking at this thing makes you feel tired."
	icon = 'icons/obj/fitness.dmi'
	icon_state = "fitnesslifter"
	density = 1
	anchored = 1

/obj/structure/stacklifter/attack_hand(var/mob/living/user)
	if(in_use)
		to_chat(user, "It's already in use - wait a bit.")
		return
	else
		in_use = 1
		icon_state = "fitnesslifter2"
		user.facedir(SOUTH)
		user.Stun(4)
		user.adjustStaminaLoss(rand(20,40))
		user.loc = src.loc
		var/lifts = 0
		while (lifts++ < 6)
			if (user.loc != src.loc)
				break
			sleep(3)
			animate(user, pixel_y = -2, time = 3)
			sleep(3)
			animate(user, pixel_y = -4, time = 3)
			sleep(3)
			playsound(user, 'sound/effects/spring.ogg', 60, 1)

		playsound(user, 'sound/machines/click.ogg', 60, 1)
		in_use = 0
		user.pixel_y = 0
		if(user.statcheck(user.stats[STAT_ST], 13, "You're not swole enough to lift these weight.  You should train more.", STAT_ST))
			var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
			to_chat(user, "[finishmessage]")
		icon_state = "fitnesslifter"	
		if(prob(1))
			user.adjustStrength(1)

/obj/structure/weightlifter
	name = "Weight Machine"
	desc = "Just looking at this thing makes you feel tired."
	icon = 'icons/obj/fitness.dmi'
	icon_state = "fitnessweight"
	density = 1
	anchored = 1

/obj/structure/weightlifter/attack_hand(var/mob/living/user)
	if(in_use)
		to_chat(user, "It's already in use - wait a bit.")
		return
	else
		in_use = 1
		icon_state = "fitnessweight-c"
		user.facedir(SOUTH)
		user.Stun(4)
		user.adjustStaminaLoss(rand(20,40))
		user.loc = src.loc
		var/image/W = image('icons/obj/fitness.dmi',"fitnessweight-w")
		W.plane = ABOVE_HUMAN_PLANE
		W.layer = ABOVE_HUMAN_LAYER
		overlays += W
		var/reps = 0
		user.pixel_y = 5
		while (reps++ < 6)
			if (user.loc != src.loc)
				break

			for (var/innerReps = max(reps, 1), innerReps > 0, innerReps--)
				sleep(3)
				animate(user, pixel_y = (user.pixel_y == 3) ? 5 : 3, time = 3)

			playsound(user, 'sound/effects/spring.ogg', 60, 1)

		sleep(3)
		animate(user, pixel_y = 2, time = 3)
		sleep(3)
		playsound(user, 'sound/machines/click.ogg', 60, 1)
		in_use = 0
		animate(user, pixel_y = 0, time = 3)
		if(user.statcheck(user.stats[STAT_ST], 13, "You're not swole enough to lift these weight.  You should train more.", STAT_ST))
			var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
			to_chat(user, "[finishmessage]")
		icon_state = "fitnessweight"
		overlays -= W
		if(prob(1))
			user.adjustStrength(1)