//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/debug_controller(controller as null|anything in list("Master","Ticker","Ticker Process","Air","Jobs","Sun","Radio","Supply","Shuttles","Evacuation","Configuration","pAI", "Cameras", "Transfer Controller", "Gas Data","Event","Plants","Alarm","Nano","Wireless","Observation","Alt Appearance Manager","Datacore","Military Branches"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder || !controller)
		return

	switch(controller)
		if("Master")
			debug_variables(master_controller)
			feedback_add_details("admin_verb","DMC")
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Jobs")
			debug_variables(job_master)
			feedback_add_details("admin_verb","DJobs")
		if("Sun")
			debug_variables(GLOB.sun)
			feedback_add_details("admin_verb","DSun")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")

		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
		if("Cameras")
			debug_variables(cameranet)
			feedback_add_details("admin_verb","DCameras")
		if("Transfer Controller")
			debug_variables(transfer_controller)
			feedback_add_details("admin_verb","DAutovoter")
		if("Gas Data")
			debug_variables(gas_data)
			feedback_add_details("admin_verb","DGasdata")
		if("Event")
			debug_variables(GLOB.event_manager)
			feedback_add_details("admin_verb", "DEvent")
		if("Nano")
			debug_variables(GLOB.nanomanager)
			feedback_add_details("admin_verb", "DNano")
		if("Alt Appearance Manager")
			debug_variables(appearance_manager)
			feedback_add_details("admin_verb", "DAltAppearanceManager")
		if("Military Branches")
			debug_variables(mil_branches)
			feedback_add_details("admin_verb", "DMilBranches")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
