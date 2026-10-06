SUBSYSTEM_DEF(librarian)
	name = "Librarian"
	init_order = INIT_ORDER_PATH
	flags = SS_NO_FIRE
	var/list/books = list()

/datum/controller/subsystem/librarian/proc/get_book(input)
	if(!input)
		return list()
	if(books.Find(input))
		return books[input]
	books[input] = file2book(input)
	return books[input]

/proc/file2book(filename)
	if(!filename)
		return list()
	var/json_file = file("strings/books/[filename]")
	testing("filebegin")
	if(fexists(json_file))
		testing("file1")
		var/list/configuration = json_decode(file2text(json_file))
		var/list/contents = configuration["Contents"]
		if(isnull(contents))
			testing("file2")
			return list()
		return contents
	testing("file4")
	return list()

/datum/controller/subsystem/librarian/proc/playerbook2file(input, book_title = "Unknown", author = "Unknown", author_ckey = "Unknown", icon = "basic_book")
	if(!input)
		return "书中没有文字！"
	if(fexists("data/player_generated_books/[url_encode(book_title)].json"))
		return "已经有一本同名的书了！"
	if(!(istext(input) && istext(book_title) && istext(author) && istext(author_ckey) && istext(icon)))
		return "这本书的格式不正确！"

	testing("playerbook2file1")
	var/list/contents = list("book_title" = "[book_title]", "author" = "[author]", "author_ckey" = "[author_ckey]", "icon" = "[icon]",  "text" = "[input]")
	//url_encode should escape all the characters that do not belong in a file name. If not, god help us
	var/file_name = "data/player_generated_books/[url_encode(book_title)].json"
	text2file(json_encode(contents), file_name)

	if(fexists("data/player_generated_books/_book_titles.json"))
		testing("playerbook2file2")
		var/list/_book_titles_contents = json_decode(file2text("data/player_generated_books/_book_titles.json"))
		_book_titles_contents += "[url_encode(book_title)]"
		fdel("data/player_generated_books/_book_titles.json")
		text2file(json_encode(_book_titles_contents), "data/player_generated_books/_book_titles.json")
		message_admins("Book [book_title] has been saved to the player book database by [author_ckey]([author])")
		return "你觉得这本新写的书会在档案中保存很长时间……"
	else
		message_admins("!!! _book_titles.json no longer exists, previous book title list has been lost. making a new one without old books... !!!")
		text2file(json_encode(list(book_title)), "data/player_generated_books/_book_titles.json")
		return "_book_titles.json已不存在，请通知服务器维护者：部分书籍已丢失！"

/datum/controller/subsystem/librarian/proc/file2playerbook(filename)
	if(!filename)
		return list()
	var/json_file = file("data/player_generated_books/[filename].json")
	testing("playerfilebegin")
	if(fexists(json_file))
		testing("playerfile1")
		var/list/contents = json_decode(file2text(json_file))
		if(isnull(contents))
			testing("playerfile2")
			return list()
		return contents
	testing("playerfile4")
	return list()

/datum/controller/subsystem/librarian/proc/del_player_book(book_title)
	testing("delplayerbook")
	if(!book_title)
		return FALSE
	var/json_file = file("data/player_generated_books/[book_title].json")
	if(!fexists(json_file))
		return FALSE
	if(fexists("data/player_generated_books/_book_titles.json"))
		fdel(json_file)
		var/list/_book_titles_contents = json_decode(file2text("data/player_generated_books/_book_titles.json"))
		_book_titles_contents -= "[book_title]"
		fdel("data/player_generated_books/_book_titles.json")
		text2file(json_encode(_book_titles_contents), "data/player_generated_books/_book_titles.json")
		return TRUE
	else
		message_admins("!!! _book_titles.json no longer exists, previous book title list has been lost. !!!")
		return FALSE


/datum/controller/subsystem/librarian/proc/pull_player_book_titles()
	testing("pullplayerbook")
	if(fexists(file("data/player_generated_books/_book_titles.json")))
		var/json_file = file("data/player_generated_books/_book_titles.json")
		var/json_list = json_decode(file2text(json_file))
		return json_list
	else
		message_admins("!!! _book_titles.json no longer exists, previous book title list has been lost. !!!")

/datum/controller/subsystem/librarian/proc/amend_player_book(book_title, amend_type, amend_text)
	testing("amendplayerbook")
	if(!book_title || !amend_type || !amend_text)
		return FALSE
	if(fexists("data/player_generated_books/_book_titles.json"))
		var/list/contents = file2playerbook(book_title)
		del_player_book(book_title)
		contents[amend_type] = amend_text
		if(playerbook2file(contents["text"], book_title = contents["book_title"], author = contents["author"], author_ckey = contents["author_ckey"], icon = contents["icon"]) == "你觉得这本新写的书会在档案中保存很长时间……")
			return TRUE
		return FALSE
	else
		message_admins("!!! _book_titles.json no longer exists, previous book title list has been lost. !!!")
		return FALSE
