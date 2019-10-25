//called when we get cuffed/uncuffed
/mob/living/carbon/proc/update_handcuffed(obj/item/restraints/handcuffs/restraints)
	if(restraints)
		drop_all_held_items()
		stop_pulling()
		handcuffed = restraints
		handcuffed.RegisterSignal(src, COMSIG_LIVING_DO_RESIST, /obj/item/restraints/.proc/resisted_against)
	else if(handcuffed)
		handcuffed.UnregisterSignal(src, COMSIG_LIVING_DO_RESIST)
		handcuffed = null
	update_inv_handcuffed()

/mob/living/carbon/proc/update_legcuffed(obj/item/restraints/legcuffs/restraints)
	if(restraints)
		if(m_intent != MOVE_INTENT_WALK)
			m_intent = MOVE_INTENT_WALK
			if(hud_used?.move_intent)
				hud_used.move_intent.icon_state = "walking"
		legcuffed = restraints
		legcuffed.RegisterSignal(src, COMSIG_LIVING_DO_RESIST, /obj/item/restraints/.proc/resisted_against)
		SEND_SIGNAL(src, COMSIG_LIVING_LEGCUFFED, restraints)
	else if (legcuffed)
		legcuffed.UnregisterSignal(src, COMSIG_LIVING_DO_RESIST)
		legcuffed = null
	update_inv_legcuffed()


/mob/living/carbon/doUnEquip(obj/item/I)
	. = ..()
	if(.)
		return
	if(I == back)
		back = null
		update_inv_back()
		return ITEM_UNEQUIP_UNEQUIPPED
	else if (I == wear_mask)
		wear_mask = null
		wear_mask_update(I)
		return ITEM_UNEQUIP_UNEQUIPPED
	else if(I == handcuffed)
		update_handcuffed(null)
		return ITEM_UNEQUIP_UNEQUIPPED
	else if(I == legcuffed)
		update_legcuffed(null)
		return ITEM_UNEQUIP_UNEQUIPPED


/mob/living/carbon/proc/wear_mask_update(obj/item/I, equipping = FALSE)
	if(!equipping && internal)
		if(hud_used?.internals)
			hud_used.internals.icon_state = "internal0"
		internal = null
	update_tint()
	update_inv_wear_mask()


//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/equip_to_slot(obj/item/I, slot)
	if(!slot)
		return
	if(!istype(I))
		return

	var/index = get_held_index_of_item(I)
	if(index)
		held_items[index] = null

	if(I.pulledby)
		I.pulledby.stop_pulling()

	I.screen_loc = null
	if(client)
		client.screen -= I
	if(observers && observers.len)
		for(var/M in observers)
			var/mob/dead/observe = M
			if(observe.client)
				observe.client.screen -= I
	I.forceMove(src)
	I.layer = ABOVE_HUD_LAYER
	I.plane = ABOVE_HUD_PLANE
	I.appearance_flags |= NO_CLIENT_COLOR
	var/not_handled = FALSE
	switch(slot)
		if(SLOT_BACK)
			back = I
			update_inv_back()
		if(SLOT_WEAR_MASK)
			wear_mask = I
			wear_mask_update(I, toggle_off = 0)
		if(SLOT_HEAD)
			head = I
			head_update(I)
		if(SLOT_NECK)
			wear_neck = I
			update_inv_neck(I)
		if(SLOT_HANDCUFFED)
			handcuffed = I
			update_handcuffed()
		if(SLOT_LEGCUFFED)
			legcuffed = I
			update_inv_legcuffed()
		if(SLOT_HANDS)
			put_in_hands(I)
			update_inv_hands()
		if(SLOT_IN_BACKPACK)
			if(!back || !SEND_SIGNAL(back, COMSIG_TRY_STORAGE_INSERT, I, src, TRUE))
				not_handled = TRUE
		else
			not_handled = TRUE

	//Item has been handled at this point and equipped callback can be safely called
	//We cannot call it for items that have not been handled as they are not yet correctly
	//in a slot (handled further down inheritance chain, probably living/carbon/human/equip_to_slot
	if(!not_handled)
		I.equipped(src, slot)

	return not_handled

