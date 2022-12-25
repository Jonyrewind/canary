function Player:sendBossWindow(bosstimer)

-- Modal window design
	local window = ModalWindow {
		title = bosstimer.mainTitle, -- Title of the modal window
		message = bosstimer.mainMsg, -- The message to be displayed on the modal window
	}

	-- Add buttons to the window (Note: if you change the names of these you must change the functions in the modal window functionallity!)
	window:addButton("Cancel")

	-- Set what button is pressed when the player presses enter or escape
	window:setDefaultEscapeButton("Cancel")
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Cobra Bastion --")
	
	if self:getStorageValue(Storage.GraveDanger.CobraBastion.ScarlettTimer) > os.time() then
		window:addChoice("Scarlett Etzel [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.GraveDanger.CobraBastion.ScarlettTimer)) .."]")
	else
		window:addChoice("Scarlett Etzel [Ready]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Kilmaresh --")
	
	if self:getStorageValue(Storage.Kilmaresh.UrmahlulluTimer) > os.time() then
		window:addChoice("Urmahlullu [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Kilmaresh.UrmahlulluTimer)) .."]")
	else
		window:addChoice("Urmahlullu [Ready]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Falcons Bastion --")	
	
	if self:getStorageValue(Storage.TheSecretLibrary.TheOrderOfTheFalcon.OberonTimer) > os.time() then
		window:addChoice("Oberon [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.TheSecretLibrary.TheOrderOfTheFalcon.OberonTimer)) .."]")
	else
		window:addChoice("Oberon [Ready]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Lions Bastion --")
	
	if self:getStorageValue(Storage.TheOrderOfTheLion.Drume.Timer) > os.time() then
		window:addChoice("Drume [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.TheOrderOfTheLion.Drume.Timer)) .."]")
	else
		window:addChoice("Drume [Ready]")
	end
	
	
	window:addChoice("-----------------------")
	window:addChoice("-- Warzone --")
	
	if self:getStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelow) > os.time() then
		window:addChoice("The Baron From Below [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelow)) .."]")
	else
		window:addChoice("The Baron From Below [Ready]")
	end
	
	
	if self:getStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepths) > os.time() then
		window:addChoice("The Duke Of The Depths [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepths)) .."]")
	else
		window:addChoice("The Duke Of The Depths [Ready]")
	end
	
	if self:getStorageValue(Storage.BigfootBurden.BossWarzone1) > os.time() then
		window:addChoice("Deathstrike [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.BigfootBurden.BossWarzone1)) .."]")
	else
		window:addChoice("Deathstrike [Ready]")
	end
	
	if self:getStorageValue(Storage.BigfootBurden.BossWarzone2) > os.time() then
		window:addChoice("Gnomevil [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.BigfootBurden.BossWarzone2)) .."]")
	else
		window:addChoice("Gnomevil [Ready]")
	end
	
	if self:getStorageValue(Storage.BigfootBurden.BossWarzone3) > os.time() then
		window:addChoice("Abyssador [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.BigfootBurden.BossWarzone3)) .."]")
	else
		window:addChoice("Abyssador [Ready]")
	end
	
	window:addChoice("-----------------------")
	window:addChoice("-- Forgotten Knowledge --")
	
	if self:getStorageValue(Storage.ForgottenKnowledge.LadyTenebrisTimer) > os.time() then
		window:addChoice("Lady Tenebris [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.LadyTenebrisTimer)) .."]")
	else
		window:addChoice("Lady Tenebris [Ready]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.LloydTimer) > os.time() then
		window:addChoice("Lloyd [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.LloydTimer)) .."]")
	else
		window:addChoice("Lloyd [Ready]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.ThornKnightTimer) > os.time() then
		window:addChoice("Mounted Thorn Knight [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.ThornKnightTimer)) .."]")
	else
		window:addChoice("Mounted Thorn Knight [Ready]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.DragonkingTimer) > os.time() then
		window:addChoice("Dragonking Zyrtarch [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.DragonkingTimer)) .."]")
	else
		window:addChoice("Dragonking Zyrtarch [Ready]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.HorrorTimer) > os.time() then
		window:addChoice("Melting Frozen Horror [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.HorrorTimer)) .."]")
	else
		window:addChoice("Melting Frozen Horror [Ready]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.TimeGuardianTimer) > os.time() then
		window:addChoice("The Time Guardian [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.TimeGuardianTimer)) .."]")
	else
		window:addChoice("The Time Guardian [Ready]")
	end
	
	if self:getStorageValue(Storage.ForgottenKnowledge.LastLoreTimer) > os.time() then
		window:addChoice("The Last Lore Keeper [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.ForgottenKnowledge.LastLoreTimer)) .."]")
	else
		window:addChoice("The Last Lore Keeper [Ready]")
	end

	window:addChoice("-----------------------")
	window:addChoice("-- Ferumbras Ascension --")

	if self:getStorageValue(Storage.FerumbrasAscension.FerumbrasTimer) > os.time() then
		window:addChoice("Ascending Ferumbras [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.FerumbrasTimer)) .."]")
	else
		window:addChoice("Ascending Ferumbras [Ready]")
	end
	
	if self:getStorageValue(Storage.FerumbrasAscension.TarbazTimer) > os.time() then
		window:addChoice("Tarbaz [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.TarbazTimer)) .."]")
	else
		window:addChoice("Tarbaz [Ready]")
	end
	
	if self:getStorageValue(Storage.FerumbrasAscension.RazzagornTimer) > os.time() then
		window:addChoice("Razzagorn [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.RazzagornTimer)) .."]")
	else
		window:addChoice("Razzagorn [Ready]")
	end
	
	if self:getStorageValue(Storage.FerumbrasAscension.RagiazTimer) > os.time() then
		window:addChoice("Ragiaz [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.RagiazTimer)) .."]")
	else
		window:addChoice("Ragiaz [Ready]")
	end
	
	if self:getStorageValue(Storage.FerumbrasAscension.ZamuloshTimer) > os.time() then
		window:addChoice("Zamulosh [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.ZamuloshTimer)) .."]")
	else
		window:addChoice("Zamulosh [Ready]")
	end
	
	if self:getStorageValue(Storage.FerumbrasAscension.ShulgraxTimer) > os.time() then
		window:addChoice("Shulgrax [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.ShulgraxTimer)) .."]")
	else
		window:addChoice("Shulgrax [Ready]")
	end
	
	if self:getStorageValue(Storage.FerumbrasAscension.MazoranTimer) > os.time() then
		window:addChoice("Mazoran [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.MazoranTimer)) .."]")
	else
		window:addChoice("Mazoran [Ready]")
	end
	
	if self:getStorageValue(Storage.FerumbrasAscension.PlagirathTimer) > os.time() then
		window:addChoice("Plagirath [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.FerumbrasAscension.PlagirathTimer)) .."]")
	else
		window:addChoice("Plagirath [Ready]")
	end
	
	window:addChoice("-----------------------")
	window:addChoice("-- Bosses --")
	
	if self:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.FacelessBaneTime) > os.time() then
	window:addChoice("Faceless Bane [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.FacelessBaneTime)) .."]")
	else
		window:addChoice("Faceless Bane [Ready]")
	end

	if self:getStorageValue(Storage.Kilmaresh.UrmahlulluTimer) > os.time() then
	window:addChoice("Urmahlullu the Immaculate [" .. os.date('%d/%m/%Y - %H:%M:%S', self:getStorageValue(Storage.Kilmaresh.UrmahlulluTimer)) .."]")
	else
		window:addChoice("Urmahlullu the Immaculate [Ready]")
	end
	
	-- Send the window to player
	window:sendToPlayer(self)
end