/mob/living/carbon/human/proc/monkeyize()
	if (transforming)
		return
	for(var/obj/item/W in src)
		if (W==w_uniform) // will be torn
			continue
		drop_from_inventory(W)
	regenerate_icons()
	transforming = 1
	canmove = 0
	stunned = 1
	icon = null
	set_invisibility(101)
	for(var/t in organs)
		qdel(t)
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null

	transforming = 0
	stunned = 0
	update_canmove()
	set_invisibility(initial(invisibility))

	if(!species.primitive_form) //If the creature in question has no primitive set, this is going to be messy.
		gib()
		return

	for(var/obj/item/W in src)
		drop_from_inventory(W)
	set_species(species.primitive_form)
	dna.SetSEState(GLOB.MONKEYBLOCK,1)
	dna.SetSEValueRange(GLOB.MONKEYBLOCK,0xDAC, 0xFFF)

	to_chat(src, "<B>You are now [species.name]. </B>")
	qdel(animation)

	return src

/mob/living/carbon/human/proc/slimeize(adult as num, reproduce as num)
	if (transforming)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	transforming = 1
	canmove = 0
	icon = null
	set_invisibility(101)
	for(var/t in organs)
		qdel(t)

	var/mob/living/carbon/slime/new_slime
	if(reproduce)
		var/number = pick(14;2,3,4)	//reproduce (has a small chance of producing 3 or 4 offspring)
		var/list/babies = list()
		for(var/i=1,i<=number,i++)
			var/mob/living/carbon/slime/M = new/mob/living/carbon/slime(loc)
			M.nutrition = round(nutrition/number)
			step_away(M,src)
			babies += M
		new_slime = pick(babies)
	else
		new_slime = new /mob/living/carbon/slime(loc)
		if(adult)
			new_slime.is_adult = 1
		else
	new_slime.key = key

	to_chat(new_slime, "<B>You are now a slime. Skreee!</B>")
	qdel(src)
	return

/mob/living/carbon/human/proc/corgize()
	if (transforming)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	transforming = 1
	canmove = 0
	icon = null
	set_invisibility(101)
	for(var/t in organs)	//this really should not be necessary
		qdel(t)

	var/mob/living/simple_animal/corgi/new_corgi = new /mob/living/simple_animal/corgi (loc)
	new_corgi.a_intent = I_HURT
	new_corgi.key = key

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
	qdel(src)
	return



//This is barely a transformation but probably best file for it.
/mob/living/carbon/human/proc/zombieze()
	ChangeToHusk()
	mutations |= CLUMSY //cause zombie
	src.visible_message("<span class='danger'>\The [src]'s flesh decays before your very eyes!</span>", "<span class='danger'>Your entire body is ripe with pain as it is consumed down to flesh and bones. You... hunger. Not only for flesh, but to spread your disease.</span>")
	if(src.mind)
		src.mind.special_role = "Zombie"
	log_admin("[key_name(src)] has transformed into a zombie!")
	Weaken(5)
	if(should_have_organ(BP_HEART))
		vessel.add_reagent(/datum/reagent/blood,species.blood_volume-vessel.total_volume)
	for(var/o in organs)
		var/obj/item/organ/organ = o
		organ.vital = 0
		organ.rejuvenate(1)
		organ.max_damage *= 5
		organ.min_broken_damage *= 5
	verbs += /mob/living/proc/breath_death
	verbs += /mob/living/proc/consume