
function place_explosion_FXs()
    local fx_list = rat_HE_fxs()

    local actor_list = {
        "HE_Grenade_1",
        "Frag_IED",
		"Pipe_IED",
		"NailBomb_IED",
    }

    for _, actor in ipairs(actor_list) do
        for class, class_fxs in pairs(fx_list) do
            for _, fx in ipairs(class_fxs) do
                fx.Actor = actor
                fx.id = rat_generate_random_id()
                fx = PlaceObj(class, fx)
                AddInRules(fx)
                --print(fx)
            end
        end
    end
end

function rat_generate_random_id()

    return tostring(math.random(1000000000000000, 9999999999999999))
end

function rat_HE_fxs()
		local fx_list ={

		['ActionFXParticles'] = {
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "CORE FX",
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 455),
				Particles = "Explosion_HE_Grenade",
				Scale = 120,
				Source = "ActionPos",
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "6523549185783937501",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "Explosion Initial FX",
				GameTime = true,
				Moment = "start",
				Particles = "Explosion_InitialBang_Strong",
				Scale = 150,
				Source = "ActionPos",
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "7103071729447705331",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "additional explosion fx",
				Delay = 50,
				DetailLevel = 40,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 51,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "1868517799759800352",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "additional explosion fx",
				Delay = 50,
				DetailLevel = 40,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 61,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "3815331936918468559",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "additional explosion fx",
				Delay = 50,
				DetailLevel = 40,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 62,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "8779848199932345952",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "additional explosion fx",
				Delay = 50,
				DetailLevel = 40,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 52,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "4537009262445626112",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "additional explosion fx",
				Delay = 50,
				DetailLevel = 40,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 50,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "2163871728011540567",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "additional explosion fx",
				Delay = 50,
				DetailLevel = 40,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 30,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "2437282998086356003",
			},
			
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				Comment = "additional explosion fx",
				Delay = 50,
				DetailLevel = 40,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 40,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "7496647274379672702",
			},
		
		},
		['ActionFXLight'] = {
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				CastShadows = true,
				Color = 4293958703,
				Delay = 100,
				FadeOut = 400,
				FadeOutColor = 4293958703,
				GameTime = true,
				Intensity = 40,
				Moment = "start",
				Offset = point(0, 0, 1500),
				Radius = 10000,
				Source = "ActionPos",
				StartColor = 4293958703,
				StartIntensity = 60,
				Time = 460,
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "8044135075875360789",
			},
		},
	
		['ActionFXDecal'] = {
			{
				Action = "Explosion",
				Actor = "HE_Grenade",
				ColorModifier = 4280953386,
				Delay = 100,
				FxId = "decexpl_generic",
				GameTime = true,
				Moment = "start",
				Object = "DecExplosion_01",
				Object2 = "DecExplosion_02",
				Offset = point(0, 0, -400),
				OffsetDir = "OrientByTerrainWithRandomAngle",
				Orientation = "OrientByTerrainWithRandomAngle",
				Scale = 75,
				SortPriority = 3,
				Source = "ActionPos",
				group = "Explosion - Grenade - HE_Grenade VFX",
				id = "8447712806556387303",
			},
		},
		['ActionFXSound'] = {
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Delay = 100,
			Moment = "start",
			Sound = "Grenade_explosion-debris",
			Source = "ActionPos",
			Target = "Surface:Dirt",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1312628877825191189",
		},
		
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Delay = 200,
			Moment = "start",
			Sound = "Grenade_explosion-debris",
			Source = "ActionPos",
			Target = "Surface:Mud",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3736605208508553056",
		},
		
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Delay = 50,
			Moment = "start",
			Sound = "Grenade_explosion-mud",
			Source = "ActionPos",
			Target = "Surface:Mud",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "7051239901387089586",
		},
		
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Delay = 200,
			Moment = "start",
			Sound = "Grenade_explosion-debris",
			Source = "ActionPos",
			Target = "Surface:Sand",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "2282475158514230329",
		},
		
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Delay = 300,
			Moment = "start",
			Sound = "Grenade_explosion-sand",
			Source = "ActionPos",
			Target = "Surface:Sand",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "5555880228454395715",
		},
		
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Delay = 100,
			Moment = "start",
			Sound = "Grenade_explosion-water",
			Source = "ActionPos",
			Target = "Surface:ShallowWater",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "SoU66m5M",
		},
		
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Delay = 100,
			Moment = "start",
			Sound = "Grenade_explosion-water",
			Source = "ActionPos",
			Target = "Surface:Water",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1325426294982888988",
		},
		
		{
			Action = "Explosion",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeHE_explosion",
			Source = "ActionPos",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "2479492486365584202",
		},
		
		{
			Action = "GrenadeActivate",
			Actor = "HE_Grenade",
			Delay = 100,
			Moment = "start",
			Sound = "GrenadeBasic_activate",
			Source = "ActionPos",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "156834469390846366",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Asphalt",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1613683329509455402",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Bone_Prop",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1736438260992984012",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Bone_Solid",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "8132329597277440841",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Brick",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "6873366162527048977",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Brick_Inv",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3644837388602072793",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Brick_Prop",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3578785970234278264",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Brick_Solid",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1761026094869534006",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Carpet_Solid",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "8801133055507505429",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Ceramic_Prop",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "5962769360290534706",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:ClayBrick",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "6491201572508396897",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Concrete",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "6782826824458779514",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:ConcreteThin",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3586315166399529394",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Debris",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "8803279287006438947",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Dirt",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3285067477951500909",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Fencewire",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3609869941082275091",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Grain",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1972778044043904609",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Grass",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "7509343839315368989",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Logs",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "7727030657200773013",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-mud",
			Target = "Surface:Meat",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "130718898687388460",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metal",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3089631187758849516",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metal_Inv_Imp",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "6187991976678613315",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metal_Inv_Penetrable",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3776264936984150067",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metal_Props",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1357452368443319579",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metal_Props_Hard",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "7894133188982632332",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metal_Solid",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "317859635310548041",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metal_Solid_Hard",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "538439609513676165",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metalrods",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1129050814576918838",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Metalsheets",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "9007521689910086229",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-mud",
			Target = "Surface:Mud",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "4341305341632607711",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Planks",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "7212249001620262137",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Plywood",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "8695633640033120600",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Rock",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3377171355556462170",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Sand",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "2192376270460092391",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Sandbag",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "6489453767156378459",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-water",
			Target = "Surface:ShallowWater",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "uHuBLCiD",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Slats",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "2840385621990404146",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Sticks",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "4668957730620865172",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Sticks_Props",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1125478235086568102",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Sticks_Solids",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3856146467962241703",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Stone",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "2122459296356525475",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-dirt",
			Target = "Surface:Tiles",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "4395943690197708264",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Tin",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "9143450562670398347",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-metal",
			Target = "Surface:Tin_Props",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "8803571294575959400",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Trees",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "9183689220407862805",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-water",
			Target = "Surface:Water",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "7547392294363882928",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Wood",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "1775718244970083474",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Wood_Props",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "3002399941628091421",
		},
		
		{
			Action = "GrenadeDrop",
			Actor = "HE_Grenade",
			Moment = "start",
			Sound = "GrenadeBasic_drop-wood",
			Target = "Surface:Wood_inv",
			group = "Explosion - Grenade - HE_Grenade SFX",
			id = "41289272059160210",
		},
	},
		['ActionFXWindMod'] = {
			{
				Action = "Explosion",
				Actor = "FragGrenade",
				Comment = "explosion impact wind",
				HalfHeight = 100,
				HarmonicConst = 15000,
				HarmonicDamping = 500,
				Moment = "start",
				ObjHalfHeight = 100,
				ObjOuterRange = 10000,
				ObjRange = 600,
				ObjStrength = 25000,
				Offset = point(0, 0, 1000),
				OnTerrainOnly = false,
				OuterRange = 6000,
				Range = 100,
				Source = "ActionPos",
				Strength = 0,
				group = "Explosion - Grenade - Frag VFX",
				id = "7379194038559926423",
			},
		},
				
	
	
	}
	
	return fx_list
end