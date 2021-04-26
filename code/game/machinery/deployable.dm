/*
CONTAINS:

Deployable items
Barricades

for reference:

	access_security = 1
	access_brig = 2
	access_armory = 3
	access_forensics_lockers= 4
	access_medical = 5
	access_morgue = 6
	access_tox = 7
	access_tox_storage = 8
	access_genetics = 9
	access_engine = 10
	access_engine_equip= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emergency_storage = 14
	access_change_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_storage = 23
	access_atmospherics = 24
	access_bar = 25
	access_janitor = 26
	access_crematorium = 27
	access_kitchen = 28
	access_robotics = 29
	access_rd = 30
	access_cargo = 31
	access_construction = 32
	access_chemistry = 33
	access_cargo_bot = 34
	access_hydroponics = 35
	access_manufacturing = 36
	access_library = 37
	access_lawyer = 38
	access_virology = 39
	access_cmo = 40
	access_qm = 41
	access_court = 42
	access_clown = 43
	access_mime = 44

*/

//Barricades!
/obj/structure/barricade
	name = "wooden barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = 1.0
	density = 1
	health = 150
	maxhealth = 150
	atom_flags = ATOM_FLAG_CLIMBABLE
	var/material_name = "wood"
	var/material/material
/obj/structure/barricade/steel
	name = "steel barricade"
	health = 500
	maxhealth = 500

/obj/structure/barricade/New(var/newloc, var/new_material_name)
	..(newloc)
	material_name = new_material_name
	if(!material_name && !material)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	color = material.icon_colour

/obj/structure/bullet_act(obj/item/projectile/P)
	src.health -= P.damage * 1

	if (src.health <= 0)
		visible_message("<span class='danger'>The [name] is smashed apart!</span>")
		dismantle()
		return
	..()
/obj/structure/attackby(obj/item/W as obj, mob/user as mob)
	src.health -= W.force * 1

	if (src.health <= 0)
		visible_message("<span class='danger'>The [name] is smashed apart!</span>")
		dismantle()
		return
	..()
/obj/structure/proc/dismantle()
	qdel(src)
/obj/structure/barricade/dismantle()
	material.place_dismantled_product(get_turf(src))
	qdel(src)
	return

/obj/structure/barricade/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("<span class='danger'>\The [src] is blown apart!</span>")
			qdel(src)
			return
		if(2.0)
			src.health -= 500
			if (src.health <= 0)
				visible_message("<span class='danger'>\The [src] is blown apart!</span>")
				dismantle()
			return

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0

/obj/structure/barricade/wall
	name = "wooden wall"
	desc = "This space is blocked off by a wall."
	health = 1000
	maxhealth = 1000
	opacity = 1
	icon_state = "wall"

/obj/structure/barricade/wall/steel
	name = "steel wall"
	health = 2000
	maxhealth = 2000

