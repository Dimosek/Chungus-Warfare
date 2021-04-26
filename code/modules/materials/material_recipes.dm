/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/material/proc/generate_recipes()
	recipes = list()

	// If is_brittle() returns true, these are only good for a single strike.
	recipes += new/datum/stack_recipe("[display_name] baseball bat", /obj/item/weapon/material/twohanded/baseballbat, 10, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")

	if(hardness>50)
		recipes += new/datum/stack_recipe("[display_name] knife", /obj/item/weapon/material/kitchen/utensil/knife/plastic, 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] blade", /obj/item/weapon/material/butterflyblade, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")

/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60)
	recipes += new/datum/stack_recipe("[display_name] door", /obj/machinery/door/unpowered/simple, 10, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade/steel, 5, time = 25, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] wall", /obj/structure/barricade/wall/steel, 10, time = 25, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	
	recipes += new/datum/stack_recipe("Wood Dispenser", /obj/structure/dispenser, 20, time = 250, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("Breaching charge", /obj/item/weapon/plastique, 5, time = 100, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")


/material/wood/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/machinery/door/unpowered/simple, 10, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 25, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] wall", /obj/structure/barricade/wall, 10, time = 25, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
