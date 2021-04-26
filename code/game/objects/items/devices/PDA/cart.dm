/obj/item/weapon/cartridge
	name = "generic cartridge"
	desc = "A data cartridge for portable microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = ITEM_SIZE_TINY

	var/obj/item/radio/integrated/radio = null
	var/access_security = 0
	var/access_engine = 0
	var/access_atmos = 0
	var/access_medical = 0
	var/access_clown = 0
	var/access_mime = 0
	var/access_janitor = 0
//	var/access_flora = 0
	var/access_reagent_scanner = 0
	var/access_remote_door = 0 // Control some blast doors remotely!!
	var/remote_door_id = ""
	var/access_status_display = 0
	var/access_quartermaster = 0
	var/access_detonate_pda = 0
	var/access_hydroponics = 0
	var/charges = 0
	var/mode = null
	var/menu
	var/datum/data/record/active1 = null //General
	var/datum/data/record/active2 = null //Medical
	var/datum/data/record/active3 = null //Security
	var/selected_sensor = null // Power Sensor
	var/message1	// used for status_displays
	var/message2
	var/list/stored_data = list()

/obj/item/weapon/cartridge/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/item/weapon/cartridge/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	access_engine = 1

/obj/item/weapon/cartridge/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"
	access_atmos = 1

/obj/item/weapon/cartridge/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	access_medical = 1

/obj/item/weapon/cartridge/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"
	access_reagent_scanner = 1

/obj/item/weapon/cartridge/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	access_security = 1



/obj/item/weapon/cartridge/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-s"
	access_security = 1
	access_medical = 1


/obj/item/weapon/cartridge/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	icon_state = "cart-j"
	access_janitor = 1

/obj/item/weapon/cartridge/lawyer
	name = "\improper P.R.O.V.E. cartridge"
	icon_state = "cart-s"
	access_security = 1

/obj/item/weapon/cartridge/clown
	name = "\improper Honkworks 5.0 cartridge"
	icon_state = "cart-clown"
	access_clown = 1
	charges = 5

/obj/item/weapon/cartridge/mime
	name = "\improper Gestur-O 1000 cartridge"
	icon_state = "cart-mi"
	access_mime = 1
	charges = 5
/*
/obj/item/weapon/cartridge/botanist
	name = "Green Thumb v4.20"
	icon_state = "cart-b"
	access_flora = 1
*/

/obj/item/weapon/cartridge/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."
	var/qdeled = 0

/obj/item/weapon/cartridge/signal/science
	name = "\improper Signal Ace 2 cartridge"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	access_reagent_scanner = 1
	access_atmos = 1


/obj/item/weapon/cartridge/quartermaster
	name = "\improper Space Parts & Space Vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	access_quartermaster = 1

/obj/item/weapon/cartridge/head
	name = "\improper Easy-Record DELUXE"
	icon_state = "cart-h"
	access_status_display = 1

/obj/item/weapon/cartridge/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"
	access_status_display = 1
	access_quartermaster = 1
	access_janitor = 1
	access_security = 1

/obj/item/weapon/cartridge/hos
	name = "\improper R.O.B.U.S.T. DELUXE"
	icon_state = "cart-hos"
	access_status_display = 1
	access_security = 1

/obj/item/weapon/cartridge/ce
	name = "\improper Power-On DELUXE"
	icon_state = "cart-ce"
	access_status_display = 1
	access_engine = 1
	access_atmos = 1

/obj/item/weapon/cartridge/cmo
	name = "\improper Med-U DELUXE"
	icon_state = "cart-cmo"
	access_status_display = 1
	access_reagent_scanner = 1
	access_medical = 1

/obj/item/weapon/cartridge/rd
	name = "\improper Signal Ace DELUXE"
	icon_state = "cart-rd"
	access_status_display = 1
	access_reagent_scanner = 1
	access_atmos = 1


/obj/item/weapon/cartridge/captain
	name = "\improper Value-PAK cartridge"
	desc = "Now with 200% more value!"
	icon_state = "cart-c"
	access_quartermaster = 1
	access_janitor = 1
	access_engine = 1
	access_security = 1
	access_medical = 1
	access_reagent_scanner = 1
	access_status_display = 1
	access_atmos = 1

/obj/item/weapon/cartridge/syndicate
	name = "\improper Detomatix cartridge"
	icon_state = "cart"
	access_remote_door = 1
	access_detonate_pda = 1
	remote_door_id = "smindicate" //Make sure this matches the syndicate shuttle's shield/door id!!	//don't ask about the name, testing.
	charges = 4

/obj/item/weapon/cartridge/proc/post_status(var/command, var/data1, var/data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			if(loc)
				var/obj/item/PDA = loc
				var/mob/user = PDA.fingerprintslast
				if(istype(PDA.loc,/mob/living))
					SetName(PDA.loc)
				log_admin("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")
				message_admins("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")

		if("image")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)


/*
	This generates the nano values of the cart menus.
	Because we close the UI when we insert a new cart
	we don't have to worry about null values on items
	the user can't access.  Well, unless they are href hacking.
	But in that case their UI will just lock up.
*/


/obj/item/weapon/cartridge/proc/create_NanoUI_values(mob/user as mob)
	var/values[0]

	/*		Signaler (Mode: 40)				*/


	/*		Station Display (Mode: 42)			*/

	if(mode==42)
		values["message1"] = message1 ? message1 : "(none)"
		values["message2"] = message2 ? message2 : "(none)"



	/*		Power Monitor (Mode: 43 / 433)			*/

	if(mode==43 || mode==433)
		var/list/sensors = list()
		var/obj/machinery/power/sensor/MS = null

		for(var/obj/machinery/power/sensor/S in SSmachines.machinery)
			sensors.Add(list(list("name_tag" = S.name_tag)))
			if(S.name_tag == selected_sensor)
				MS = S
		values["power_sensors"] = sensors
		if(selected_sensor && MS)
			values["sensor_reading"] = MS.return_reading_data()





	/*	Supply Shuttle Requests Menu (Mode: 47)		*/

	if(mode==47)
		var/supplyData[0]
		var/datum/shuttle/autodock/ferry/supply/shuttle = supply_controller.shuttle
		if (shuttle)
			supplyData["shuttle_moving"] = shuttle.has_arrive_time()
			supplyData["shuttle_eta"] = shuttle.eta_minutes()
			supplyData["shuttle_loc"] = shuttle.at_station() ? "Station" : "Dock"
		var/supplyOrderCount = 0
		var/supplyOrderData[0]
		for(var/S in supply_controller.shoppinglist)
			var/datum/supply_order/SO = S

			supplyOrderData[++supplyOrderData.len] = list("Number" = SO.ordernum, "Name" = html_encode(SO.object.name), "ApprovedBy" = SO.orderedby, "Comment" = rhtml_encode(SO.comment))
		if(!supplyOrderData.len)
			supplyOrderData[++supplyOrderData.len] = list("Number" = null, "Name" = null, "OrderedBy"=null)

		supplyData["approved"] = supplyOrderData
		supplyData["approved_count"] = supplyOrderCount

		var/requestCount = 0
		var/requestData[0]
		for(var/S in supply_controller.requestlist)
			var/datum/supply_order/SO = S
			requestCount++
			requestData[++requestData.len] = list("Number" = SO.ordernum, "Name" = html_encode(SO.object.name), "OrderedBy" = SO.orderedby, "Comment" = rhtml_encode(SO.comment))
		if(!requestData.len)
			requestData[++requestData.len] = list("Number" = null, "Name" = null, "orderedBy" = null, "Comment" = null)

		supplyData["requests"] = requestData
		supplyData["requests_count"] = requestCount


		values["supply"] = supplyData



	return values



