#define INTERACT_REQUIRES_DEXTERITY		(1<<0)
#define INTERACT_CHECK_INCAPACITATED	(1<<1)
#define INTERACT_UI_INTERACT			(1<<2)
#define INTERACT_SILICON_ALLOWED		(1<<3)


#define INTERACT_MACHINE_NOSILICON	(INTERACT_REQUIRES_DEXTERITY|INTERACT_CHECK_INCAPACITATED)
#define INTERACT_MACHINE_DEFAULT	(INTERACT_REQUIRES_DEXTERITY|INTERACT_CHECK_INCAPACITATED|INTERACT_SILICON_ALLOWED)
#define INTERACT_MACHINE_TGUI		(INTERACT_REQUIRES_DEXTERITY|INTERACT_CHECK_INCAPACITATED|INTERACT_SILICON_ALLOWED|INTERACT_UI_INTERACT)
#define INTERACT_OBJ_DEFAULT		(INTERACT_REQUIRES_DEXTERITY|INTERACT_CHECK_INCAPACITATED)
#define INTERACT_OBJ_TGUI			(INTERACT_REQUIRES_DEXTERITY|INTERACT_CHECK_INCAPACITATED|INTERACT_UI_INTERACT)
