
note
	description: "mouvement de l'os"
	author: "Tommy Teasdale & V�ronique Blais"
	date: "28 mars 2013"
	revision: "4 avril 2013"

class
	MARTEAU

inherit
	IMAGE
	COLLISION
create
	make
feature -- Access
	make(a_screen:POINTER a_nom:STRING)
		do
			screen:=a_screen
			creer_image("images/garagara_os.png")

			set_x(0)
			set_y(0)
				--Setup player name
			set_nom(a_nom)

				-- Connection to database	
			create {DATABASE} bdd.make()
				-- Create an entry in the database for the player
				-- with is name and empty score. Return an ID.
			id:=bdd.insert_new_pointage(0,nom)
				-- Print ID
			print(id)
			print("%N")
		end
	set_nom(a_nom:STRING)
		do
			nom:=a_nom
		end
	get_nom:STRING
		do
			Result:=nom
		end
	set_pointage(a_pointage:INTEGER)
		do
			pointage:=a_pointage
		end
	get_pointage:INTEGER
		do
			Result:=pointage
		end
	get_best_pointage()
		do
			bdd.get_best_pointage ()
		end
	insert_new_pointage(a_pointage:INTEGER a_nom:STRING):INTEGER
		do
			Result:=bdd.insert_new_pointage (a_pointage, a_nom)
		end
	update_pointage
		do
			bdd.update_pointage (id, pointage, nom)
		end

bdd:DATABASE
id:INTEGER
pointage:INTEGER
nom:STRING
end
