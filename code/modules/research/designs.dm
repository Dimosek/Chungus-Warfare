/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/datum/design						//Datum for object designs, used in construction
	var/name = null					//Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc = null					//Description of the created object. If null it will use group_desc and name where applicable.
	var/item_name = null			//An item name before it is modified by various name-modifying procs
	var/id = "id"					//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols.
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.
	var/build_type = null			//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of chemicals.
	var/build_path = null			//The path of the object that gets created.
	var/time = 10					//How many ticks it requires to build
	var/category = null 			//Primarily used for Mech Fabricators, but can be used for anything.
	var/sort_string = "ZZZZZ"		//Sorting order

/datum/design/New()
	..()
	item_name = name
	AssembleDesignInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc)

/datum/design/item
	build_type = PROTOLATHE

/datum/design/item/disk/AssembleDesignName()
	..()
	name = "Storage disk ([item_name])"

/datum/design/item/disk/design
	name = "research design"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 10)
	build_path = /obj/item/weapon/disk/design_disk
	sort_string = "AAAAA"

/datum/design/item/disk/tech
	name = "technology data"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 10)
	build_path = /obj/item/weapon/disk/tech_disk
	sort_string = "AAAAB"

/datum/design/item/stock_part
	build_type = PROTOLATHE

/datum/design/item/stock_part/AssembleDesignName()
	..()
	name = "Component design ([item_name])"

/datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/item/stock_part/basic_capacitor
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor
	sort_string = "CAAAA"

/datum/design/item/stock_part/adv_capacitor
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	sort_string = "CAAAB"

/datum/design/item/stock_part/super_capacitor
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50, "gold" = 20)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	sort_string = "CAAAC"

/datum/design/item/stock_part/micro_mani
	id = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator
	sort_string = "CAABA"

/datum/design/item/stock_part/nano_mani
	id = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	sort_string = "CAABB"

/datum/design/item/stock_part/pico_mani
	id = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	sort_string = "CAABC"

/datum/design/item/stock_part/basic_matter_bin
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	sort_string = "CAACA"

/datum/design/item/stock_part/adv_matter_bin
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	sort_string = "CAACB"

/datum/design/item/stock_part/super_matter_bin
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	sort_string = "CAACC"

/datum/design/item/stock_part/basic_micro_laser
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	sort_string = "CAADA"

/datum/design/item/stock_part/high_micro_laser
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	sort_string = "CAADB"

/datum/design/item/stock_part/ultra_micro_laser
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20, "uranium" = 10)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	sort_string = "CAADC"

/datum/design/item/stock_part/basic_sensor
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "CAAEA"

/datum/design/item/stock_part/adv_sensor
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "CAAEB"

/datum/design/item/stock_part/phasic_sensor
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20, "silver" = 10)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "CAAEC"

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 5000)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "CBAAA"
