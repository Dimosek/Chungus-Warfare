/obj/item/radio/integrated
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/device/pda/hostpda = null

	var/on = 0 //Are we currently active??
	var/menu_message = ""

	New()
		..()
		if (istype(loc.loc, /obj/item/device/pda))
			hostpda = loc.loc

	proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)

//		log_debug("Post: [freq]: [key]=[value], [key2]=[value2]")

		var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

		if(!frequency) return

		var/datum/signal/signal = new()
		signal.source = src
		signal.transmission_method = 1
		signal.data[key] = value
		if(key2)
			signal.data[key2] = value2
		if(key3)
			signal.data[key3] = value3

		frequency.post_signal(src, signal, filter = s_filter)

		return

	proc/generate_menu()
