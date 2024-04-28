-- ========== THIS IS AN AUTOMATICALLY GENERATED FILE! ==========


function RatoEO_Patch()
	FragGrenade.BaseDamage = 31
	FragGrenade.r_shrap_num = 500
	FragGrenade.AreaOfEffect = 3
	FragGrenade.ThrowMaxRange = 19
	FragGrenade.BaseRange = 8
	FragGrenade.PenetrationClass = 4
	FragGrenade.is_ied = false
	FragGrenade.r_concussive_force = 4
	FragGrenade.r_mass = 540
	FragGrenade.r_timer = 6500
	FragGrenade.r_shape = "Stick_like"
	FragGrenade.CanBounce = true
	FragGrenade.r_soft_surface = false
	FragGrenade.CanAppearInShop = true
	FragGrenade.Cost = 400

	HE_Grenade.BaseDamage = 31
	HE_Grenade.r_shrap_num = 1000
	HE_Grenade.AreaOfEffect = 3
	HE_Grenade.ThrowMaxRange = 19
	HE_Grenade.BaseRange = 8
	HE_Grenade.PenetrationClass = 4
	HE_Grenade.is_ied = false
	HE_Grenade.r_concussive_force = 4
	HE_Grenade.r_mass = 570
	HE_Grenade.r_timer = 4500
	HE_Grenade.r_shape = "Spherical"
	HE_Grenade.CanBounce = true
	HE_Grenade.r_soft_surface = false
	HE_Grenade.CanAppearInShop = true
	HE_Grenade.Cost = 600

	HE_Grenade_1.BaseDamage = 40
	HE_Grenade_1.r_shrap_num = 500
	HE_Grenade_1.AreaOfEffect = 3
	HE_Grenade_1.ThrowMaxRange = 19
	HE_Grenade_1.BaseRange = 8
	HE_Grenade_1.PenetrationClass = 4
	HE_Grenade_1.is_ied = false
	HE_Grenade_1.r_concussive_force = 5
	HE_Grenade_1.r_mass = 400
	HE_Grenade_1.r_timer = 4500
	HE_Grenade_1.r_shape = "Cylindrical"
	HE_Grenade_1.CanBounce = true
	HE_Grenade_1.r_soft_surface = false
	HE_Grenade_1.CanAppearInShop = true
	HE_Grenade_1.Cost = 400

	ShapedCharge.BaseDamage = 39
	ShapedCharge.r_shrap_num = 500
	ShapedCharge.AreaOfEffect = 8
	ShapedCharge.ThrowMaxRange = 15
	ShapedCharge.BaseRange = 4
	ShapedCharge.PenetrationClass = 4
	ShapedCharge.is_ied = false
	ShapedCharge.r_concussive_force = 4
	ShapedCharge.r_mass = 1070
	ShapedCharge.r_shape = "Stick_like"
	ShapedCharge.CanBounce = false
	ShapedCharge.r_soft_surface = false
	ShapedCharge.CanAppearInShop = false
	ShapedCharge.Cost = 1500

	NailBomb_IED.BaseDamage = 15
	NailBomb_IED.r_shrap_num = 1000
	NailBomb_IED.AreaOfEffect = 3
	NailBomb_IED.ThrowMaxRange = 19
	NailBomb_IED.BaseRange = 8
	NailBomb_IED.PenetrationClass = 3
	NailBomb_IED.is_ied = false
	NailBomb_IED.r_concussive_force = 2
	NailBomb_IED.r_mass = 400
	NailBomb_IED.r_timer = 3000
	NailBomb_IED.r_shape = "Can"
	NailBomb_IED.CanBounce = true
	NailBomb_IED.r_soft_surface = false
	NailBomb_IED.CanAppearInShop = false
	NailBomb_IED.Cost = 400

	PipeBomb.AttackAP = 3000
	PipeBomb.r_shrap_num = 300
	PipeBomb.ThrowMaxRange = 14
	PipeBomb.BaseRange = 4
	PipeBomb.is_ied = true
	PipeBomb.r_concussive_force = 4
	PipeBomb.r_mass = 980
	PipeBomb.r_shape = "Long"
	PipeBomb.CanBounce = true
	PipeBomb.r_soft_surface = false
	PipeBomb.CanAppearInShop = false
	PipeBomb.Cost = 300

	Pipe_IED.AttackAP = 3000
	Pipe_IED.r_shrap_num = 300
	Pipe_IED.ThrowMaxRange = 14
	Pipe_IED.BaseRange = 4
	Pipe_IED.is_ied = true
	Pipe_IED.r_concussive_force = 4
	Pipe_IED.r_mass = 980
	Pipe_IED.r_timer = 5000
	Pipe_IED.r_shape = "Long"
	Pipe_IED.CanBounce = true
	Pipe_IED.r_soft_surface = false
	Pipe_IED.CanAppearInShop = true
	Pipe_IED.Cost = 100

	ProximityC4.AttackAP = 7000
	ProximityC4.r_shrap_num = 80
	ProximityC4.is_ied = false
	ProximityC4.r_concussive_force = 5
	ProximityC4.r_mass = 2000
	ProximityC4.r_shape = "Brick"
	ProximityC4.CanBounce = true
	ProximityC4.r_soft_surface = true
	ProximityC4.CanAppearInShop = true
	ProximityC4.Cost = 1200

	ProximityPETN.AttackAP = 7000
	ProximityPETN.r_shrap_num = 80
	ProximityPETN.is_ied = false
	ProximityPETN.r_concussive_force = 5
	ProximityPETN.r_mass = 1800
	ProximityPETN.r_shape = "Brick"
	ProximityPETN.CanBounce = true
	ProximityPETN.r_soft_surface = true
	ProximityPETN.CanAppearInShop = true
	ProximityPETN.Cost = 1500

	ProximityTNT.AttackAP = 7000
	ProximityTNT.r_shrap_num = 80
	ProximityTNT.is_ied = false
	ProximityTNT.r_concussive_force = 5
	ProximityTNT.r_mass = 1500
	ProximityTNT.r_shape = "Long"
	ProximityTNT.CanBounce = true
	ProximityTNT.r_soft_surface = true
	ProximityTNT.CanAppearInShop = true
	ProximityTNT.Cost = 850

	RemoteC4.AttackAP = 4000
	RemoteC4.r_shrap_num = 80
	RemoteC4.is_ied = false
	RemoteC4.r_concussive_force = 5
	RemoteC4.r_mass = 2000
	RemoteC4.r_shape = "Brick"
	RemoteC4.CanBounce = true
	RemoteC4.r_soft_surface = true
	RemoteC4.CanAppearInShop = true
	RemoteC4.Cost = 800

	RemotePETN.AttackAP = 4000
	RemotePETN.r_shrap_num = 80
	RemotePETN.is_ied = false
	RemotePETN.r_concussive_force = 5
	RemotePETN.r_mass = 1800
	RemotePETN.r_shape = "Brick"
	RemotePETN.CanBounce = true
	RemotePETN.r_soft_surface = true
	RemotePETN.CanAppearInShop = true
	RemotePETN.Cost = 800

	RemoteTNT.AttackAP = 4000
	RemoteTNT.r_shrap_num = 80
	RemoteTNT.is_ied = false
	RemoteTNT.r_concussive_force = 5
	RemoteTNT.r_mass = 1500
	RemoteTNT.r_shape = "Long"
	RemoteTNT.CanBounce = true
	RemoteTNT.r_soft_surface = true
	RemoteTNT.CanAppearInShop = true
	RemoteTNT.Cost = 600

	TNTBolt_IED.AttackAP = 3000
	TNTBolt_IED.BaseDamage = 36
	TNTBolt_IED.r_shrap_num = 500
	TNTBolt_IED.AreaOfEffect = 4
	TNTBolt_IED.ThrowMaxRange = 15
	TNTBolt_IED.BaseRange = 4
	TNTBolt_IED.PenetrationClass = 4
	TNTBolt_IED.is_ied = true
	TNTBolt_IED.r_concussive_force = 5
	TNTBolt_IED.r_mass = 750
	TNTBolt_IED.r_shape = "Long"
	TNTBolt_IED.CanBounce = true
	TNTBolt_IED.r_soft_surface = true
	TNTBolt_IED.CanAppearInShop = false
	TNTBolt_IED.Cost = 400

	TearGasGrenade.AttackAP = 4000
	TearGasGrenade.ThrowMaxRange = 19
	TearGasGrenade.BaseRange = 8
	TearGasGrenade.PenetrationClass = 1
	TearGasGrenade.is_ied = false
	TearGasGrenade.r_mass = 500
	TearGasGrenade.r_timer = 4000
	TearGasGrenade.r_shape = "Cylindrical"
	TearGasGrenade.CanBounce = true
	TearGasGrenade.r_soft_surface = false
	TearGasGrenade.CanAppearInShop = true
	TearGasGrenade.Cost = 800

	TearGasGrenade_IED.AttackAP = 4000
	TearGasGrenade_IED.ThrowMaxRange = 19
	TearGasGrenade_IED.BaseRange = 8
	TearGasGrenade_IED.PenetrationClass = 1
	TearGasGrenade_IED.is_ied = true
	TearGasGrenade_IED.r_mass = 600
	TearGasGrenade_IED.r_timer = 4000
	TearGasGrenade_IED.r_shape = "Can"
	TearGasGrenade_IED.CanBounce = true
	TearGasGrenade_IED.r_soft_surface = false
	TearGasGrenade_IED.CanAppearInShop = true
	TearGasGrenade_IED.Cost = 800

	TimedC4.AttackAP = 4000
	TimedC4.r_shrap_num = 80
	TimedC4.is_ied = false
	TimedC4.r_concussive_force = 5
	TimedC4.r_mass = 2000
	TimedC4.r_shape = "Brick"
	TimedC4.CanBounce = true
	TimedC4.r_soft_surface = true
	TimedC4.CanAppearInShop = true
	TimedC4.Cost = 1200

	TimedPETN.AttackAP = 4000
	TimedPETN.r_shrap_num = 80
	TimedPETN.is_ied = false
	TimedPETN.r_concussive_force = 5
	TimedPETN.r_mass = 1800
	TimedPETN.r_shape = "Brick"
	TimedPETN.CanBounce = true
	TimedPETN.r_soft_surface = true
	TimedPETN.CanAppearInShop = true
	TimedPETN.Cost = 1500

	TimedTNT.AttackAP = 4000
	TimedTNT.r_shrap_num = 80
	TimedTNT.is_ied = false
	TimedTNT.r_concussive_force = 5
	TimedTNT.r_mass = 1500
	TimedTNT.r_shape = "Long"
	TimedTNT.CanBounce = true
	TimedTNT.r_soft_surface = true
	TimedTNT.CanAppearInShop = true
	TimedTNT.Cost = 850

	ConcussiveGrenade.AttackAP = 4000
	ConcussiveGrenade.AreaOfEffect = 3
	ConcussiveGrenade.ThrowMaxRange = 20
	ConcussiveGrenade.BaseRange = 10
	ConcussiveGrenade.is_ied = true
	ConcussiveGrenade.r_mass = 397
	ConcussiveGrenade.r_timer = 3000
	ConcussiveGrenade.r_shape = "Cylindrical"
	ConcussiveGrenade.CanBounce = true
	ConcussiveGrenade.r_soft_surface = false
	ConcussiveGrenade.CanAppearInShop = true
	ConcussiveGrenade.Cost = 800

	ConcussiveGrenade_IED.AttackAP = 4000
	ConcussiveGrenade_IED.AreaOfEffect = 3
	ConcussiveGrenade_IED.ThrowMaxRange = 19
	ConcussiveGrenade_IED.BaseRange = 9
	ConcussiveGrenade_IED.is_ied = false
	ConcussiveGrenade_IED.r_mass = 420
	ConcussiveGrenade_IED.r_timer = 3000
	ConcussiveGrenade_IED.r_shape = "Long"
	ConcussiveGrenade_IED.CanBounce = true
	ConcussiveGrenade_IED.r_soft_surface = false
	ConcussiveGrenade_IED.CanAppearInShop = false
	ConcussiveGrenade_IED.Cost = 800

	FlareStick.AttackAP = 4000
	FlareStick.AreaOfEffect = 4
	FlareStick.ThrowMaxRange = 19
	FlareStick.BaseRange = 9
	FlareStick.is_ied = false
	FlareStick.r_mass = 580
	FlareStick.r_shape = "Long"
	FlareStick.CanBounce = true
	FlareStick.r_soft_surface = false
	FlareStick.CanAppearInShop = true
	FlareStick.Cost = 200

	GlowStick.AttackAP = 2000
	GlowStick.AreaOfEffect = 2
	GlowStick.ThrowMaxRange = 22
	GlowStick.BaseRange = 11
	GlowStick.is_ied = false
	GlowStick.r_mass = 250
	GlowStick.r_shape = "Long"
	GlowStick.CanBounce = true
	GlowStick.r_soft_surface = false
	GlowStick.CanAppearInShop = true
	GlowStick.Cost = 100

	IncendiaryGrenade.AttackAP = 4000
	IncendiaryGrenade.ThrowMaxRange = 19
	IncendiaryGrenade.BaseRange = 8
	IncendiaryGrenade.is_ied = false
	IncendiaryGrenade.r_mass = 500
	IncendiaryGrenade.r_timer = 5000
	IncendiaryGrenade.r_shape = "Cylindrical"
	IncendiaryGrenade.CanBounce = true
	IncendiaryGrenade.r_soft_surface = false
	IncendiaryGrenade.CanAppearInShop = true
	IncendiaryGrenade.Cost = 300

	Molotov.AttackAP = 4000
	Molotov.AreaOfEffect = 3
	Molotov.ThrowMaxRange = 12
	Molotov.BaseRange = 4
	Molotov.is_ied = true
	Molotov.r_mass = 980
	Molotov.r_timer = 7000
	Molotov.r_shape = "Bottle"
	Molotov.CanBounce = false
	Molotov.r_soft_surface = false
	Molotov.CanAppearInShop = false
	Molotov.Cost = 300

	SmokeGrenade.AttackAP = 4000
	SmokeGrenade.ThrowMaxRange = 19
	SmokeGrenade.BaseRange = 8
	SmokeGrenade.is_ied = false
	SmokeGrenade.r_mass = 500
	SmokeGrenade.r_timer = 3500
	SmokeGrenade.r_shape = "Cylindrical"
	SmokeGrenade.CanBounce = true
	SmokeGrenade.r_soft_surface = false
	SmokeGrenade.CanAppearInShop = true
	SmokeGrenade.Cost = 600

	SmokeGrenade_IED.AttackAP = 4000
	SmokeGrenade_IED.ThrowMaxRange = 19
	SmokeGrenade_IED.BaseRange = 8
	SmokeGrenade_IED.is_ied = true
	SmokeGrenade_IED.r_mass = 600
	SmokeGrenade_IED.r_timer = 3500
	SmokeGrenade_IED.r_shape = "Can"
	SmokeGrenade_IED.CanBounce = true
	SmokeGrenade_IED.r_soft_surface = false
	SmokeGrenade_IED.CanAppearInShop = false
	SmokeGrenade_IED.Cost = 600

	ToxicGasGrenade.AttackAP = 4000
	ToxicGasGrenade.ThrowMaxRange = 19
	ToxicGasGrenade.BaseRange = 8
	ToxicGasGrenade.is_ied = false
	ToxicGasGrenade.r_mass = 600
	ToxicGasGrenade.r_timer = 4000
	ToxicGasGrenade.r_shape = "Cylindrical"
	ToxicGasGrenade.CanBounce = true
	ToxicGasGrenade.r_soft_surface = false
	ToxicGasGrenade.CanAppearInShop = false
	ToxicGasGrenade.Cost = 1500

	TNT.BaseDamage = 45
	TNT.Cost = 200

	C4.BaseDamage = 50
	C4.Cost = 400

	PETN.BaseDamage = 65
	PETN.Cost = 500

	BlackPowder.BaseDamage = 40
	BlackPowder.Cost = 400

	_40mmFragGrenade.BaseDamage = 36
	_40mmFragGrenade.r_shrap_num = 500
	_40mmFragGrenade.PenetrationClass = 4
	_40mmFragGrenade.r_concussive_force = 5

	Warhead_Frag.BaseDamage = 43
	Warhead_Frag.r_shrap_num = 500
	Warhead_Frag.PenetrationClass = 4
	Warhead_Frag.r_concussive_force = 5

	MortarShell_HE.BaseDamage = 36
	MortarShell_HE.r_shrap_num = 500
	MortarShell_HE.PenetrationClass = 4
	MortarShell_HE.r_concussive_force = 5

end