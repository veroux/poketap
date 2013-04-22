note
	description: "Boucle de jeu {GAMES}"
	author: "Tommy Teasdale et V�ronique Blais"
	date: "28 f�vrier 2013"
	revision: ""

class
	GAMES
create
	make_serveur,
	make_client

feature -- Access
	make_serveur
		local
			l_marteau:MARTEAU
			l_marmotte:MARMOTTE
			l_init:NATURAL_32
			l_ctr, l_pointage, l_disable, l_poll_event:INTEGER
			l_screen, l_event, l_memory_manager:POINTER
			l_fond:FOND_ECRAN
			l_quit_bool:BOOLEAN
			l_mousemotion,l_mousedown, l_quit:NATURAL_8
			l_trou:TROU
			l_cl_pointage:STRING

			l_database:DATABASE
			l_font:STRING
			l_c_font, l_c_text:C_STRING
			font:POINTER
			l_font_surface:POINTER
			l_color:POINTER
			l_texte_pointage:TEXTE
			l_texte_cl_pointage:TEXTE

			l_reseau_serveur:RESEAU_SERVEUR
			l_reseau_client:RESEAU_CLIENT
			l_texte_nom:TEXTE
		do
			-- Initialiser la fen�tre et SDL
--			l_init := init_video
--			l_ctr := init(l_init)
			l_screen := set_video_mode
			l_disable := disable
			l_ctr := show_cursor_disable(l_disable)
			create {FOND_ECRAN} l_fond.make(l_screen)
			create {DATABASE} bdd.make
			create{RESEAU_SERVEUR} l_reseau_serveur.make


			--create l_c_text.make ("19472 points")

			-- Create Player
			print("Entrez votre nom : ")
			io.readLine
			create  l_marteau.make(l_screen,io.last_string,bdd)

			create l_texte_pointage.make (l_screen)
			l_texte_pointage.set_texte("0 point")
			l_texte_pointage.set_x(265)
			l_texte_pointage.set_y(560)
			create l_texte_nom.make(l_screen)
			l_texte_nom.set_texte(l_marteau.get_nom)
			l_texte_nom.set_x(25)
			l_texte_nom.set_y(560)

			-- Create client
			create l_texte_cl_pointage.make(l_screen)
			l_texte_cl_pointage.set_texte("0 point")
			l_texte_cl_pointage.set_x(725)
			l_texte_cl_pointage.set_y(560)

			-- Create an ennemy
			create  l_trou.make(l_screen)
			create l_marmotte.make(l_screen)

			-- Allow memory for events
			create l_memory_manager.default_create
			l_event:=l_memory_manager.memory_alloc ({SDL_WRAPPER}.sizeof_SDL_Event)

			l_mousemotion:= mouse_motion
			l_mousedown:= {SDL_WRAPPER}.SDL_MOUSEBUTTONDOWN

			--l_marteau.get_best_pointage()

			from
				l_quit:={SDL_WRAPPER}.SDL_QUIT
				l_quit_bool:=false
			until
				l_quit_bool=true
			loop

				from
					l_poll_event:=poll_event(l_event)
				until
					l_poll_event/=1
				loop
					-- Quit event
					if {SDL_WRAPPER}.get_SDL_Event_Type(l_event) = l_quit then
						l_quit_bool:= true
					end
					-- Mouse movement event
					if {SDL_WRAPPER}.get_SDL_Event_Type(l_event) = l_mousemotion then

						l_marteau.x:=mouse_x(l_event)
						l_marteau.y:=mouse_y(l_event)
					end
					-- Mouse click event
					if {SDL_WRAPPER}.get_SDL_Event_Type(l_event) = l_mousedown then
						l_pointage:= l_marteau.get_pointage
						l_pointage:=l_pointage+1

						l_marteau.set_pointage(l_pointage)
						l_marteau.update_pointage
						l_texte_pointage.set_texte(l_pointage.out+" points")
						print(l_pointage)
						print("%N")
					end
					l_poll_event:=poll_event(l_event)
				end
				l_cl_pointage:=l_reseau_serveur.recoit
				l_texte_cl_pointage.set_texte(l_cl_pointage+" points")
				-- Display images
				l_fond.affiche_image
				l_trou.affiche_image
				l_marmotte.animation_marmotte
				--l_font_surface:={SDL_TTF}.TTF_RenderText_Solid(font,l_c_text.item,l_color)
				--affiche_texte(l_font_surface, l_screen)
				l_texte_pointage.affiche_texte
				l_texte_cl_pointage.affiche_texte
				l_texte_nom.affiche_texte
				l_marteau.affiche_image
				-- Wait 17ms (for 60fps)
				delay(1)
				-- Display a frame
				l_ctr := flip(l_screen)

			end
			l_reseau_serveur.close
			--l_fond.destroy()
			exit()


		end

make_client
		local
			l_marteau:MARTEAU
			l_marmotte:MARMOTTE
			l_init:NATURAL_32
			l_ctr, l_pointage, l_disable, l_poll_event:INTEGER
			l_screen, l_event, l_memory_manager:POINTER
			l_fond:FOND_ECRAN
			l_quit_bool:BOOLEAN
			l_mousemotion,l_mousedown, l_quit:NATURAL_8
			l_trou:TROU

			l_database:DATABASE
			l_font:STRING
			l_c_font, l_c_text:C_STRING
			font:POINTER
			l_font_surface:POINTER
			l_color:POINTER
			l_texte_pointage:TEXTE
			l_texte_nom:TEXTE
			l_reseau_client:RESEAU_CLIENT

		do
			-- Initialiser la fen�tre et SDL
			l_init := init_video
			l_ctr := init(l_init)
			l_screen := set_video_mode
			l_disable := disable
			l_ctr := show_cursor_disable(l_disable)
			create {FOND_ECRAN} l_fond.make(l_screen)
			create {DATABASE} bdd.make
			create  {RESEAU_CLIENT}l_reseau_client.make

			--create l_c_text.make ("19472 points")

			-- Create Player
			print("Entrez votre nom : ")
			io.readLine
			create  l_marteau.make(l_screen,io.last_string,bdd)

			create l_texte_pointage.make (l_screen)
			l_texte_pointage.set_texte("0 point")
			l_texte_pointage.set_x(725)
			l_texte_pointage.set_y(560)
			create l_texte_nom.make(l_screen)
			l_texte_nom.set_texte(l_marteau.get_nom)
			l_texte_nom.set_x(490)
			l_texte_nom.set_y(560)

			-- Create an ennemy
			create  l_trou.make(l_screen)
			create l_marmotte.make(l_screen)

			-- Allow memory for events
			create l_memory_manager.default_create
			l_event:=l_memory_manager.memory_alloc ({SDL_WRAPPER}.sizeof_SDL_Event)

			l_mousemotion:= mouse_motion
			l_mousedown:= {SDL_WRAPPER}.SDL_MOUSEBUTTONDOWN

			--l_marteau.get_best_pointage()

			from
				l_quit:={SDL_WRAPPER}.SDL_QUIT
				l_quit_bool:=false
			until
				l_quit_bool=true
			loop

				from
					l_poll_event:=poll_event(l_event)
				until
					l_poll_event/=1
				loop
					-- Quit event
					if {SDL_WRAPPER}.get_SDL_Event_Type(l_event) = l_quit then
						l_quit_bool:= true
					end
					-- Mouse movement event
					if {SDL_WRAPPER}.get_SDL_Event_Type(l_event) = l_mousemotion then

						l_marteau.x:=mouse_x(l_event)
						l_marteau.y:=mouse_y(l_event)
					end
					-- Mouse click event
					if {SDL_WRAPPER}.get_SDL_Event_Type(l_event) = l_mousedown then
						l_pointage:= l_marteau.get_pointage
						l_pointage:=l_pointage+1

						l_marteau.set_pointage(l_pointage)
						l_marteau.update_pointage
						l_texte_pointage.set_texte(l_pointage.out+" points")
						print(l_pointage)
						print("%N")
					end
					l_poll_event:=poll_event(l_event)
				end
				l_reseau_client.envoye(l_pointage.out)
				-- Display images
				l_fond.affiche_image
				l_trou.affiche_image
				l_marmotte.animation_marmotte
				--l_font_surface:={SDL_TTF}.TTF_RenderText_Solid(font,l_c_text.item,l_color)
				--affiche_texte(l_font_surface, l_screen)
				l_texte_pointage.affiche_texte
				l_texte_nom.affiche_texte
				l_marteau.affiche_image
				-- Wait 17ms (for 60fps)
				delay(17)
				-- Display a frame
				l_ctr := flip(l_screen)

			end
			l_reseau_client.close
			--l_fond.destroy()
			exit()


		end

feature{NONE} --Routine

	init_video : NATURAL_32
		--initialisation de la video
		do
			result:={SDL_WRAPPER}.SDL_INIT_VIDEO
		end
	init(l_init:NATURAL_32): INTEGER
		--initialisation
		do
			result:= {SDL_WRAPPER}.SDL_Init(l_init)
		end
	set_video_mode : POINTER
		--set les propri�t�s de la fen�tre
		do
			result:={SDL_WRAPPER}.SDL_SetVideoMode(914,680, 32, {SDL_WRAPPER}.SDL_SWSURFACE)
		end
	disable: INTEGER
		--faire disparaitre la souris
		do
			result:={SDL_WRAPPER}.SDL_DISABLE
		end
	show_cursor_disable(l_disable:INTEGER) : INTEGER
		--faire disparaitre/apparaitre la souris
		do
			result:={SDL_WRAPPER}.SDL_ShowCursor(l_disable)
		end
	poll_event(l_event:POINTER): INTEGER
		--Poll event
		do
			result:={SDL_WRAPPER}.SDL_PollEvent(l_event)
		end

	flip(l_screen:POINTER) : INTEGER
		--Flip surface
		do
			result:={SDL_WRAPPER}.SDL_Flip(l_screen)
		end

	delay(temp:NATURAL_32)
		--Delai d'image seconde
		do
			{SDL_WRAPPER}.SDL_Delay(temp)
		end
	exit()
		--Quitter
		do
			{SDL_WRAPPER}.SDL_Exit()
		end
	mouse_motion : NATURAL_8
		--Deplacement de la souris
		do
			result:={SDL_WRAPPER}.SDL_MOUSEMOTION
		end
	mouse_x(l_event:POINTER):INTEGER_16
		--getter de la position de la souris
	do
		result:={SDL_WRAPPER}.get_SDL_MouseMotionEvent_x(l_event)
	end
	mouse_y(l_event:POINTER):INTEGER_16
		--getter de la position de la souris
	do
		result:={SDL_WRAPPER}.get_SDL_MouseMotionEvent_y(l_event)
	end

id:INTEGER
pointage:INTEGER
nom:STRING
bdd:DATABASE
reseau:RESEAU_CLIENT


end
