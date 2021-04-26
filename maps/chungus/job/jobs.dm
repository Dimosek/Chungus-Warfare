/datum/map/chungus
	allowed_jobs = list(
						/datum/job/reddit/chungus,
						/datum/job/reddit/waifu,
						/datum/job/reddit/moderator,
						/datum/job/roblox/noob,
						/datum/job/roblox/noob_medic,
						/datum/job/roblox/builderman,
						)

/datum/job/reddit
	department = "Reddit"
	total_positions = -1
	spawn_positions = -1
	supervisors = "Keanu Reaves"
	team = CHUNGUS_TEAM
	department_flag = RED
/datum/job/reddit/chungus
	title = "Chungus"
	selection_color = "#515151"
	alt_titles = list("Medium Chungus","Small Chungus")
	sprite ='icons/mob/human_races/r_chungus.dmi'
	outfit_type = /decl/hierarchy/outfit/job/battle_kit


	equip(var/mob/living/carbon/human/H)
		H.generate_stats(STAT_HT)
		H.generate_skills(list("melee"))
		..()
		H.total_health = 500
		H.maxHealth = 500
/datum/job/reddit/moderator
	title = "Reddit Moderator"
	selection_color = "#f5851d"
	sprite ='icons/mob/human_races/r_mod.dmi'
	outfit_type = /decl/hierarchy/outfit/job/engineer


	equip(var/mob/living/carbon/human/H)
		H.generate_stats(STAT_HT)
		H.generate_skills(list("engineering"))
		..()



/datum/job/reddit/waifu
	title = "Waifu"
	selection_color = "#ca4acf"
	sprite ='icons/mob/human_races/r_waifu.dmi'
	outfit_type = /decl/hierarchy/outfit/job/chungus_medic


	equip(var/mob/living/carbon/human/H)
		H.generate_stats(STAT_IQ)
		H.generate_skills(list("medical"))
		..()
		H.gender = MALE

/datum/job/roblox
	department = "Roblox"
	total_positions = -1
	spawn_positions = -1
	supervisors = "Builder Club Leader"
	team = NOOB_TEAM
	department_flag = ROB

	equip(mob/living/carbon/human/H)
		..()
		H.scream_sfx = 'sound/voice/oof.ogg'


/datum/job/roblox/noob
	title = "Noob"
	selection_color = "#FFFF00"
	alt_titles = list("Guest")
	outfit_type = /decl/hierarchy/outfit/job/battle_kit
	sprite = 'icons/mob/human_races/r_roblox.dmi'

	equip(var/mob/living/carbon/human/H)

		H.generate_stats(STAT_DX)
		H.generate_skills(list("ranged"))
		..()

/datum/job/roblox/builderman
	title = "Builderman"
	selection_color = "#ffa600"
	alt_titles = list("Guest")
	outfit_type = /decl/hierarchy/outfit/job/engineer
	sprite = 'icons/mob/human_races/r_roblox.dmi'

	equip(var/mob/living/carbon/human/H)

		H.generate_stats(STAT_DX)
		H.generate_skills(list("engineering"))
		..()



/datum/job/roblox/noob_medic
	title = "Big Tiddy Guest GF"
	selection_color = "#e6e6e6"
	outfit_type = /decl/hierarchy/outfit/job/noob_medic
	sprite = 'icons/mob/human_races/r_roblox_gf.dmi'

	equip(var/mob/living/carbon/human/H)

		H.generate_skills(list("medical"))
		H.generate_stats(STAT_IQ)
		..()
		H.gender = FEMALE
/decl/hierarchy/outfit/job/battle_kit
	name = OUTFIT_JOB_NAME("solider")
	backpack_contents = list(/obj/item/weapon/gun/projectile/automatic/machine_pistol = 1,/obj/item/ammo_magazine/c45uzi = 2, )


/decl/hierarchy/outfit/job/noob_medic
	name = OUTFIT_JOB_NAME("medic")
	uniform = /obj/item/clothing/under/roblox
	shoes = /obj/item/clothing/shoes/socks
	head = /obj/item/clothing/head/nurse
	belt = /obj/item/weapon/defibrillator/compact
	backpack_contents = list(/obj/item/medkit=1,/obj/item/weapon/gun/projectile/colt/officer=1, /obj/item/ammo_magazine/c45m = 2)

/decl/hierarchy/outfit/job/noob_medic/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL


/decl/hierarchy/outfit/job/chungus_medic
	name = OUTFIT_JOB_NAME("medic")
	uniform = /obj/item/clothing/under/waifu
	shoes = /obj/item/clothing/shoes/socks
	head = /obj/item/clothing/head/nurse
	belt = /obj/item/weapon/defibrillator/compact
	backpack_contents = list(/obj/item/medkit=1,/obj/item/weapon/gun/projectile/colt/officer=1, /obj/item/ammo_magazine/c45m = 2)



/decl/hierarchy/outfit/job/chungus_medic/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL




/decl/hierarchy/outfit/job/engineer
	name = OUTFIT_JOB_NAME("engineer")
	backpack_contents = list(/obj/item/weapon/gun/projectile/revolver = 1,/obj/item/ammo_magazine/a357 = 2, /obj/item/stack/material/steel/ten = 2)
	head = /obj/item/clothing/head/hardhat
		