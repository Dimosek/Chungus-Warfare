/obj/item/weapon/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	storage_slots = 7
	max_w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")

/obj/item/weapon/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	use_alt_layer = !use_alt_layer
	update_icon()

/obj/item/weapon/storage/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()


/obj/item/weapon/storage/belt/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(slot == slot_belt_str && contents.len)
		for(var/obj/item/I in contents)
			ret.overlays += image("icon" = 'icons/mob/onmob/belt.dmi', "icon_state" = "[I.item_state ? I.item_state : I.icon_state]")
	return ret