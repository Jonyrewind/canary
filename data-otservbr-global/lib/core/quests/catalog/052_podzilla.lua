local quest = {
	name = "Podzilla",
	startStorageId = Storage.Quest.U13_40.Podzilla.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Rise of Podzilla",
			storageId = Storage.Quest.U13_40.Podzilla.TheRiseofPodzilla.Questline,
			missionId = 10505,
			startValue = 1,
			endValue = 10,
			states = {
				[1] = "Tell Caiptain Seahorse in Edron that Gunther sent you, to embark to the rendezvous point with the explorer society ships.",
				[2] = "You won't be able to fight that giant plant from the outside. Your only desperate option seems to be to find a way to enter the plant.",
				[3] = "Find any clues about what is happening with this strange giant plant and how it can be stopped. \n\n (If you need to leave the area, use the steering wheel of the ship you arived on.)",
				[4] = function(player)
					local storage = Storage.Quest.U13_40.Podzilla.TheRiseofPodzilla.Rooteaten
					local eaten = math.max(player:getStorageValue(storage), 0)

					return string.format(
						"You are in Need of allies. Find a demon root and use it to talk to the strange plant people. It's your only option to make your way to Marrow.\nDemon root eaten: %s/1 \n\n (If you need to leave the area, use the steering wheel of the ship you arived on.)",
						eaten
					)
				end,
				[5] = function(player)
					local storage = Storage.Quest.U13_40.Podzilla.TheRiseofPodzilla.HandledRoots
					local handled = math.max(player:getStorageValue(storage), 0)

					return string.format(
						"Find a way to destroy the disruptive plant the creature Petaloid call \"Crimson Death Blossom\" and reduce the growth of its evergrowing roots. \nThe creatures in this microcosm use special amber tools to tend and cut the roots within them against the corrupting blossom. \nHandled roots: %s/10",
						handled
					)
				end,
			},
		},
	},
}

return quest
