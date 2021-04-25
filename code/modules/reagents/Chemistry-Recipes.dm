//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
// It is filtered into multiple lists within a list.
// For example:
// chemical_reaction_list[/datum/reagent/toxin/phoron] is a list of all reactions relating to phoron
// Note that entries in the list are NOT duplicated. So if a reaction pertains to
// more than one chemical it will still only appear in only one of the sublists.
/proc/initialize_chemical_reactions()
	var/paths = typesof(/datum/chemical_reaction) - /datum/chemical_reaction
	chemical_reactions_list = list()

	for(var/path in paths)
		var/datum/chemical_reaction/D = new path()
		if(D.required_reagents && D.required_reagents.len)
			var/reagent_id = D.required_reagents[1]
			if(!chemical_reactions_list[reagent_id])
				chemical_reactions_list[reagent_id] = list()
			chemical_reactions_list[reagent_id] += D

/datum/chemical_reaction
	var/name = null
	var/result = null
	var/list/required_reagents = list()
	var/list/catalysts = list()
	var/list/inhibitors = list()
	var/result_amount = 0

	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'

	var/log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.

/datum/chemical_reaction/proc/can_happen(var/datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	return 1

// This proc returns a list of all reagents it wants to use; if the holder has several reactions that use the same reagent, it will split the reagent evenly between them
/datum/chemical_reaction/proc/get_used_reagents()
	. = list()
	for(var/reagent in required_reagents)
		. += reagent

/datum/chemical_reaction/proc/process(var/datum/reagents/holder, var/limit)
	var/data = send_data(holder)

	var/reaction_volume = holder.maximum_volume
	for(var/reactant in required_reagents)
		var/A = holder.get_reagent_amount(reactant) / required_reagents[reactant] / limit // How much of this reagent we are allowed to use
		if(reaction_volume > A)
			reaction_volume = A

	for(var/reactant in required_reagents)
		holder.remove_reagent(reactant, reaction_volume * required_reagents[reactant], safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_volume
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced)

//called when a reaction processes
/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume)
	return

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		var/turf/T = get_turf(container)
		var/list/seen = viewers(4, T)
		for(var/mob/M in seen)
			M.show_message("<span class='notice'>\icon[container] [mix_message]</span>", 1)
		playsound(T, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null

/* Common reactions */

/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	result = /datum/reagent/inaprovaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/carbon = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	result = /datum/reagent/dylovene
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/potassium = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	result = /datum/reagent/tramadol
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/ethanol = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	result = /datum/reagent/paracetamol
	required_reagents = list(/datum/reagent/tramadol = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	result = /datum/reagent/tramadol/oxycodone
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/tramadol = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	result = /datum/reagent/sterilizine
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/dylovene = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	result = /datum/reagent/silicate
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	result = /datum/reagent/mutagen
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/thermite
	name = "Thermite"
	result = /datum/reagent/thermite
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/iron = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	result = /datum/reagent/space_drugs
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/sugar = 1, /datum/reagent/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	result = /datum/reagent/lube
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /datum/reagent/acid/polyacid
	required_reagents = list(/datum/reagent/acid = 3, /datum/reagent/acid/hydrochloric = 6, /datum/reagent/potassium = 10, /datum/reagent/toxin/potassium_chlorophoride = 1, /datum/reagent/surfactant = 5)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	result = /datum/reagent/synaptizine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/lithium = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	result = /datum/reagent/hyronalin
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	result = /datum/reagent/arithrazine
	required_reagents = list(/datum/reagent/hyronalin = 1, /datum/reagent/hydrazine = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	result = /datum/reagent/impedrezene
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	result = /datum/reagent/kelotane
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	result = /datum/reagent/peridaxon
	required_reagents = list(/datum/reagent/bicaridine = 2, /datum/reagent/clonexadone = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	result = /datum/reagent/nutriment/virus_food
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/drink/milk = 1)
	result_amount = 5

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	result = /datum/reagent/leporazine
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/copper = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	result = /datum/reagent/cryptobiolin
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	result = /datum/reagent/alkysine
	required_reagents = list(/datum/reagent/acid/hydrochloric = 1, /datum/reagent/ammonia = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	result = /datum/reagent/dexalin
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/toxin/phoron = 0.1)
	inhibitors = list(/datum/reagent/water = 1) // Messes with cryox
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	result = /datum/reagent/dermaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/phosphorus = 1, /datum/reagent/kelotane = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	result = /datum/reagent/dexalinp
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/carbon = 1, /datum/reagent/iron = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	result = /datum/reagent/bicaridine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/carbon = 1)
	inhibitors = list(/datum/reagent/sugar = 1) // Messes up with inaprovaline
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	result = /datum/reagent/hyperzine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1, /datum/reagent/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	result = /datum/reagent/ryetalyn
	required_reagents = list(/datum/reagent/arithrazine = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	result = /datum/reagent/cryoxadone
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/water = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	result = /datum/reagent/clonexadone
	required_reagents = list(/datum/reagent/cryoxadone = 1, /datum/reagent/sodium = 1, /datum/reagent/toxin/phoron = 0.1)
	result_amount = 2

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	result = /datum/reagent/spaceacillin
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	name = "Imidazoline"
	result = /datum/reagent/imidazoline
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	result = /datum/reagent/ethylredoxrazine
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/dylovene = 1, /datum/reagent/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/soporific
	name = "Soporific"
	result = /datum/reagent/soporific
	required_reagents = list(/datum/reagent/chloralhydrate = 1, /datum/reagent/sugar = 4)
	inhibitors = list(/datum/reagent/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	result = /datum/reagent/chloralhydrate
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/acid/hydrochloric = 3, /datum/reagent/water = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	result = /datum/reagent/toxin/potassium_chloride
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/potassium = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	result = /datum/reagent/toxin/potassium_chlorophoride
	required_reagents = list(/datum/reagent/toxin/potassium_chloride = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/chloralhydrate = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /datum/reagent/toxin/zombiepowder
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/soporific = 5, /datum/reagent/copper = 5)
	result_amount = 2

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	result = /datum/reagent/mindbreaker
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	result = /datum/reagent/lipozine
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/ethanol = 1, /datum/reagent/radium = 1)
	result_amount = 3

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /datum/reagent/surfactant
	required_reagents = list(/datum/reagent/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/acid = 1)
	result_amount = 5

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	result = /datum/reagent/diethylamine
	required_reagents = list (/datum/reagent/ammonia = 1, /datum/reagent/ethanol = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /datum/reagent/space_cleaner
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /datum/reagent/toxin/plantbgone
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /datum/reagent/foaming_agent
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrazine = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/nutriment/cornoil = 3, /datum/reagent/acid = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /datum/reagent/sodiumchloride
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /datum/reagent/capsaicin/condensed
	required_reagents = list(/datum/reagent/capsaicin = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	result = /datum/reagent/coolant
	required_reagents = list(/datum/reagent/tungsten = 1, /datum/reagent/acetone = 1, /datum/reagent/water = 1)
	result_amount = 3
	log_is_important = 1

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	result = /datum/reagent/rezadone
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 1, /datum/reagent/cryptobiolin = 1, /datum/reagent/copper = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	result = /datum/reagent/lexorin
	required_reagents = list(/datum/reagent/toxin/phoron = 1, /datum/reagent/hydrazine = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	result = /datum/reagent/methylphenidate
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/citalopram
	name = "Citalopram"
	result = /datum/reagent/citalopram
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/carbon = 1)
	result_amount = 3


/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	result = /datum/reagent/paroxetine
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/acetone = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 3

/datum/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /datum/reagent/toxin/hair_remover
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/potassium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/noexcutite
	name = "Noexcutite"
	result = /datum/reagent/noexcutite
	required_reagents = list(/datum/reagent/tramadol/oxycodone = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/* Solidification */

/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/frostoil = 5, /datum/reagent/toxin/phoron = 20)
	result_amount = 1

/datum/chemical_reaction/phoronsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)

/datum/chemical_reaction/plastication
	name = "Plastic"
	result = null
	required_reagents = list(/datum/reagent/acid/polyacid = 1, /datum/reagent/toxin/plasticide = 2)
	result_amount = 1

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)

/* Grenade reactions */

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	result = null
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
	result_amount = 2
	mix_message = null

/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	result = null
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1 )
	result_amount = null

/datum/chemical_reaction/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 3)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Stun(5)

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	result = null
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	result = /datum/reagent/nitroglycerin
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/acid/polyacid = 1, /datum/reagent/acid = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/nitroglycerin/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	e.start()

	holder.clear_reagents()

/datum/chemical_reaction/napalm
	name = "Napalm"
	result = null
	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/acid = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(/datum/reagent/toxin/phoron, created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	holder.del_reagent("napalm")

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	result = null
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1)
	result_amount = 0.4

/datum/chemical_reaction/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	holder.clear_reagents()

/datum/chemical_reaction/foam
	name = "Foam"
	result = null
	required_reagents = list(/datum/reagent/surfactant = 1, /datum/reagent/water = 1)
	result_amount = 2
	mix_message = "The solution violently bubbles!"

/datum/chemical_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	result = null
	required_reagents = list(/datum/reagent/aluminum = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5

/datum/chemical_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	result = null
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5

/datum/chemical_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()

/* Paint */

/datum/chemical_reaction/red_paint
	name = "Red paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/red = 1)
	result_amount = 5

/datum/chemical_reaction/red_paint/send_data()
	return "#fe191a"

/datum/chemical_reaction/orange_paint
	name = "Orange paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/orange = 1)
	result_amount = 5

/datum/chemical_reaction/orange_paint/send_data()
	return "#ffbe4f"

/datum/chemical_reaction/yellow_paint
	name = "Yellow paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/yellow = 1)
	result_amount = 5

/datum/chemical_reaction/yellow_paint/send_data()
	return "#fdfe7d"

/datum/chemical_reaction/green_paint
	name = "Green paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/green = 1)
	result_amount = 5

/datum/chemical_reaction/green_paint/send_data()
	return "#18a31a"

/datum/chemical_reaction/blue_paint
	name = "Blue paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/blue = 1)
	result_amount = 5

/datum/chemical_reaction/blue_paint/send_data()
	return "#247cff"

/datum/chemical_reaction/purple_paint
	name = "Purple paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/purple = 1)
	result_amount = 5

/datum/chemical_reaction/purple_paint/send_data()
	return "#cc0099"

/datum/chemical_reaction/grey_paint //mime
	name = "Grey paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/grey = 1)
	result_amount = 5

/datum/chemical_reaction/grey_paint/send_data()
	return "#808080"

/datum/chemical_reaction/brown_paint
	name = "Brown paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/brown = 1)
	result_amount = 5

/datum/chemical_reaction/brown_paint/send_data()
	return "#846f35"

/datum/chemical_reaction/blood_paint
	name = "Blood paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/blood = 2)
	result_amount = 5

/datum/chemical_reaction/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data("blood")
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#fe191a" // Probably red

/datum/chemical_reaction/milk_paint
	name = "Milk paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/milk = 5)
	result_amount = 5

/datum/chemical_reaction/milk_paint/send_data()
	return "#f0f8ff"

/datum/chemical_reaction/orange_juice_paint
	name = "Orange juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/orange = 5)
	result_amount = 5

/datum/chemical_reaction/orange_juice_paint/send_data()
	return "#e78108"

/datum/chemical_reaction/tomato_juice_paint
	name = "Tomato juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/tomato = 5)
	result_amount = 5

/datum/chemical_reaction/tomato_juice_paint/send_data()
	return "#731008"

/datum/chemical_reaction/lime_juice_paint
	name = "Lime juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/lime = 5)
	result_amount = 5

/datum/chemical_reaction/lime_juice_paint/send_data()
	return "#365e30"

/datum/chemical_reaction/carrot_juice_paint
	name = "Carrot juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/carrot = 5)
	result_amount = 5

/datum/chemical_reaction/carrot_juice_paint/send_data()
	return "#973800"

/datum/chemical_reaction/berry_juice_paint
	name = "Berry juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/berry = 5)
	result_amount = 5

/datum/chemical_reaction/berry_juice_paint/send_data()
	return "#990066"

/datum/chemical_reaction/grape_juice_paint
	name = "Grape juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/grape = 5)
	result_amount = 5

/datum/chemical_reaction/grape_juice_paint/send_data()
	return "#863333"

/datum/chemical_reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/toxin/poisonberryjuice = 5)
	result_amount = 5

/datum/chemical_reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/datum/chemical_reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/watermelon = 5)
	result_amount = 5

/datum/chemical_reaction/watermelon_juice_paint/send_data()
	return "#b83333"

/datum/chemical_reaction/lemon_juice_paint
	name = "Lemon juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/lemon = 5)
	result_amount = 5

/datum/chemical_reaction/lemon_juice_paint/send_data()
	return "#afaf00"

/datum/chemical_reaction/banana_juice_paint
	name = "Banana juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/banana = 5)
	result_amount = 5

/datum/chemical_reaction/banana_juice_paint/send_data()
	return "#c3af00"

/datum/chemical_reaction/potato_juice_paint
	name = "Potato juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, "potatojuice" = 5)
	result_amount = 5

/datum/chemical_reaction/potato_juice_paint/send_data()
	return "#302000"

/datum/chemical_reaction/carbon_paint
	name = "Carbon paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/carbon = 1)
	result_amount = 5

/datum/chemical_reaction/carbon_paint/send_data()
	return "#333333"

/datum/chemical_reaction/aluminum_paint
	name = "Aluminum paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/aluminum = 1)
	result_amount = 5

/datum/chemical_reaction/aluminum_paint/send_data()
	return "#f0f8ff"
