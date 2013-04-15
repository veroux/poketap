note
	description: "Summary description for {TEXTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEXTE

create
	make
feature -- Access
	make(a_screen:POINTER)
		local
			l_font:STRING
			l_c_font, l_c_text:C_STRING
			font:POINTER
			l_font_surface:POINTER
			l_color, l_memory_manager:POINTER
			l_texte_pointage:TEXTE
			l_ctr:INTEGER

		do
			screen:=a_screen
			l_ctr:={SDL_TTF}.TTF_Init
			l_font := "fonts/DejaVuSans.ttf"
			create font_name.make (l_font)
			font_size:=34
			font := {SDL_TTF}.TTF_OpenFont (font_name.item,font_size)

			create texte.make ("19472 points")
			create l_memory_manager.default_create
			color:=l_memory_manager.memory_alloc ({SDL_WRAPPER}.sizeof_SDL_Color)
			set_r(0)
			set_g(0)
			set_b(0)
			surface:={SDL_TTF}.TTF_RenderText_Solid(font,texte.item,color)
			affiche_texte()
		end

feature{NONE}
		--render
		--open_font
		set_r(a_r:INTEGER_8)
			--
			do
				{SDL_WRAPPER}.set_SDL_Color_r(color, a_r)
			end

		set_g(a_g:INTEGER_8)
			do
				{SDL_WRAPPER}.set_SDL_Color_g(color, a_g)
			end
		set_b(a_b:INTEGER_8)
			do
				{SDL_WRAPPER}.set_SDL_Color_b(color, a_b)
			end
		affiche_texte()
			local
				l_memory_manager, l_targetarea:POINTER
			do
				l_targetarea := l_memory_manager.memory_alloc ({SDL_WRAPPER}.sizeof_SDL_Rect)
				{SDL_WRAPPER}.set_SDL_Rect_x (l_targetarea, 15)
				{SDL_WRAPPER}.set_SDL_Rect_y (l_targetarea, 15)
				{SDL_WRAPPER}.set_SDL_Rect_w (l_targetarea, 100)
				{SDL_WRAPPER}.set_SDL_Rect_h (l_targetarea, 100)
				if {SDL_WRAPPER}.SDL_BlitSurface(surface, create{POINTER}, screen, l_targetarea) < 0 then
					print ("Erreur at afficher_texte")
				end

			end
texte:C_STRING
font_name:C_STRING
font_size:INTEGER
color:POINTER
screen:POINTER
surface:POINTER
end
