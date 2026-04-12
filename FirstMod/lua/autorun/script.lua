hook.Add("PlayerSay", "CommandSuperPouvoir", function(ply, text)

	local message = string.lower(text)

	if message == "!super" then

		ply:SetHealth(500)
		ply:SetMaxHealth(500)
		ply:SetArmor(200)
		ply:SetRunSpeed(1000)
		ply:SetJumpPower(600)
		ply:SetGravity(0.5)

		ply:Give("weapon_shotgun")

		ply:ChatPrint("MODE SUPER HÉRO ACTIVÉ !")
		
		return ""
	end

	if message == "!normal" then
		ply:SetHealth(100)
		ply:SetMaxHealth(100)
		ply:SetArmor(0)
		ply:SetRunSpeed(400)
		ply:SetJumpPower(200)
		ply:SetGravity(1)
		ply:StripWeapon("weapon_shotgun")

		ply:ChatPrint("Retour à la normale...")
		return ""
	end

	if message == "!more_ammo" then
		ply:GiveAmmo(10, "item_box_buckshot", 0)
		ply:ChatPrint("item_box_buckshot", "donné")
		return ""
	end

	if message == "!take" then
		ply:SetHealth(ply:Health() - 10)
		ply:ChatPrint("damage taken")
		return ""
	end

end)

hook.Add("OnDamagedByExplosion")

hook.Add("PlayerSay", "FaireApparaitreBaril", function(ply, text)
	
	local message = string.lower(text)

	if (message == "!boom") then
		
		local trace = ply:GetEyeTrace()

		local baril = ents.Create("prop_physics")

		if not IsValid(baril) then return "" end
		
		baril:SetModel("models/props_c17/oildrum001_explosive.mdl")

		baril:SetPos(trace.HitPos + Vector(0, 0, 15))
		
		baril:Spawn()

		baril:Ignite(3)

		timer.Simple(3, function ()
			if (IsValid(baril)) then
				ply:EmitSound("all_sound/faaah.wav")
				baril:TakeDamage(100, ply, ply)
			end
		end)

		ply:ChatPrint("Cadeau !")

		return ""
	end

end)

if SERVER then
    resource.AddFile("resource/fonts/GalaferaMedium-V4xze.ttf")

    hook.Add("GetFallDamage", "PlayFallSound", function(ply, speed)
        ply:EmitSound("all_sound/classic_hurt.wav")
    end)
end

if (CLIENT) then
	
	surface.CreateFont ("Galafera_Med", {
			font = "Galafera Med",
			size = 35,
			weight = 800,
			antialias = true,
			shadow = false,
			outline = false
		})

	local elementsCaches = {
		["CHudHealth"] = true,
		["CHudBattery"] = true,
	}

	hook.Add("HUDShouldDraw", "CacherHudDeBase", function(nomDeLElement)
	
		if (elementsCaches[nomDeLElement]) then
			return false
		end
	end)

	hook.Add("HUDPaint", "MaBarreDeViePerso", function()
		
		local ply = LocalPlayer()

		
		surface.SetFont("Galafera Med")

		if not IsValid(ply) or not ply:Alive() then return end

		local pv = ply:Health()
		local max_pv = ply:GetMaxHealth()

		pv = math.Clamp(pv, 0, max_pv)

		local couleurVie
		if (pv > 25) then
			couleurVie = Color(50, 200, 50, 255)
		else
			couleurVie = Color(255, 50, 50, 255)
		end

		draw.RoundedBox(8, 50, ScrH() - 100, 300, 30, Color(0, 0, 0, 150))

		local pourcentage = pv / max_pv
		local largeur_rouge = 300 * pourcentage

		draw.RoundedBox(8, 50, ScrH() - 100, largeur_rouge, 30, couleurVie)

		draw.SimpleText("Santé: " .. pv,  "Galafera_Med", 200, ScrH() - 85 , Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end