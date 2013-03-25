note
	description: "Base de donn�e {DATABASE}."
	author: "V�ronique Blais"
	date: "mars 2013"
	revision: ""

class
	DATABASE

inherit

	SQLITE_SHARED_API

create
	make

feature {NONE} -- Initialization

	make
		local

				-- Initialization for `Current'.
			table_present: BOOLEAN
		do

				--			from
				--				allo_liste.start
				--			until
				--				allo_liste.exhausted
				--			loop
				--				-- Queque chose avec allo_liste
				--				allo_liste.forth
				--			end

				--			tous_valid:=across allo_liste as l_element all l_element.is_valid end
				-- Open/create a Database.
			create l_db.make_create_read_write ("meilleur_pointage")
			create l_query.make ("SELECT name FROM sqlite_master ORDER BY name;", l_db)
			table_present := false
			across
				l_query.execute_new as l_cursor
			loop
				print (" - table: " + l_cursor.item.string_value (1) + "%N")
				if l_cursor.item.string_value (1).is_equal ("pointage") then
					table_present := true
				end
			end
				-- Create a new table
			if table_present = false then
				create l_modify.make ("CREATE TABLE `pointage` (`score` INTEGER PRIMARY KEY, `name` TEXT);", l_db)
				l_modify.execute
			end
		end

feature

	insert_pointage (a_pointage: INTEGER a_nom: STRING)
		do
				-- Create a insert statement with variables
			create l_insert.make ("INSERT INTO pointage (score,name) VALUES (?1, ?2);", l_db)
			check
				l_insert_is_compiled: l_insert.is_compiled
			end
			l_db.begin_transaction (False)

				-- Execute the INSERT statement with the argument list.
			l_insert.execute_with_arguments ([create {SQLITE_INTEGER_ARG}.make ("?1", a_pointage), create {SQLITE_STRING_ARG}.make ("?2", a_nom)])
			l_db.commit
		end
feature
	get_pointage
		do
			create l_query.make ("SELECT name, max(score) FROM pointage;", l_db)
			l_query.execute (agent  (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					j, j_count: NATURAL
				do
						--					print ("> Row " + ia_row.index.out + ": ")

					from
						j := 1
						j_count := ia_row.count
					until
						j > j_count
					loop
						print (ia_row.column_name (j))
						print (", ")
						print (ia_row.string_value (j))
						print ("%N")
							-- Print the column name.
							--	print (ia_row.column_name (j))
							--	print (":")

							-- Print the text value, regardless of type.
							--	if not ia_row.is_null (j) then
							--		print (ia_row.string_value (j))
							--	else
							--		print ("<NULL>")
							--	end

							--	if j < j_count then
							--		print (", ")
							--	end
						j := j + 1
					end
					print ("%N")

						-- Cut processing after 5 rows of data have been returned
						--Result := (ia_row.index \\ 5) = 0
						--if Result then
						--	print ("--> We have 5 results, lets forget the rest%N")
						--end
				end)
		end

	l_db: SQLITE_DATABASE

	l_modify: SQLITE_MODIFY_STATEMENT

	l_insert: SQLITE_INSERT_STATEMENT

	l_query: SQLITE_QUERY_STATEMENT

end