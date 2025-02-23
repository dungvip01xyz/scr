getgenv().ConfigsKaitun = {
	["Safe Mode"] = false, -- Will be pass all anti cheat (but slow farm)
	
	["Melee"] = {
		["Death Step"] = true,
		["Electric Claw"] = true,
		["Dragon Talon"] = true,
		["Sharkman Karate"] = true,
		["Superhuman"] = true,
		["God Human"] = true,
	},

	["Sword"] = {
		-- : World 1
		["Saber"] = true,
		["Pole"] = false,
		-- : World 2
		["Midnight Blade"] = true,
		["Shisui"] = true,
		["Saddi"] = true,
		["Wando"] = true,
		["Rengoku"] = true,
		["True Triple Katana"] = true,
		-- : World 3
		["Yama"] = true,
		["Tushita"] = true,
		["Canvander"] = true,
		["Buddy Sword"] = true,
		["Twin Hooks"] = true,
		["Hallow Scythe"] = true,
		["Cursed Dual Katana"] = true,
	},

	["Gun"] = {
		-- : World 2
		["Kabucha"] = true,
		-- : World 3
		["Venom Bow"] = true,
		["Skull Guitar"] = true,
	},

	["Mastery"] = {
		["Melee"] = true,
		["Sword"] = true,
		["Devil Fruits"] = true,

		["Configs"] = {
			["Selected All Sword"] = true,
			["Select Sword"] = {"Saber","Cursed Dual Katana"},
		}
	},

	["Race"] = {
		["v2"] = true,
		["v3"] = true,
		["Locked"] = {
			["Mink"] = true,
			["Human"] = true,
			["Skypiea"] = true,
			["Fishman"] = true,
		},
	},

	["Fruit"] = {
		["Main Fruit"] = {"Dough-Dough"},
		["Sec Fruit"] = {"Flame-Flame", "Ice-Ice", "Quake-Quake", "Light-Light", "Dark-Dark", "Spider-Spider", "Rumble-Rumble", "Magma-Magma", "Buddha-Buddha"},
		["Safe Fruit"] = {
			"Dough-Dough",
			"Dragon-Dragon"
		},
	},

	["Quest"] = {
		["Rainbow Haki"] = true,
		["Pull Lever"] = true,
		["Musketeer Hat"] = true,
		["Dough Mirror"] = true,
		["Shark Anchor"] = {
			["Enable"] = true,
			["Money"] = 25_000_000,
		},
	},

	["Currency"] = {
		["Lock Fragment"] = 30_000,
	},

	["Performance"] = {
		["White Screen"] = false,
		["Booster FPS"] = false,
		["Lock FPS"] = 240,
		["AFK Timeout"] = 150,
	},
}
loadstring(game:HttpGet("https://api.realaya.xyz/v1/files/l/73mkp0aqyfo4ypy8hvl0nz10lq49fey5.lua"))()
