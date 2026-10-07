/**
 * Datum which holds details of a running poll loaded from the database and supplementary info.
 *
 * Used to minimize the need for querying this data every time it's needed.
 *
 */
/datum/poll_question
	///Reference list of the options for this poll, not used by text response polls.
	var/list/options = list()
	///Table id of this poll, will be null until poll has been created.
	var/poll_id
	///The type of poll to be created, must be POLLTYPE_OPTION, POLLTYPE_TEXT, POLLTYPE_RATING, POLLTYPE_MULTI or POLLTYPE_IRV.
	var/poll_type
	///Count of how many players have voted or responded to this poll.
	var/poll_votes
	///Ckey of the poll's original author
	var/created_by
	///Date and time the poll opens, timestamp format is YYYY-MM-DD HH:MM:SS.
	var/start_datetime
	///Date and time the poll will run until, timestamp format is YYYY-MM-DD HH:MM:SS.
	var/end_datetime
	///The title text of the poll, shows up on the list of polls.
	var/question
	///Supplementary text displayed only when responding to a poll.
	var/subtitle
	///Hides the poll from any client without a holder datum.
	var/admin_only
	///The number of responses allowed in a multiple-choice poll, more can be selected but won't be recorded.
	var/options_allowed
	///Hint for statbus, not used by the game; Stops the results of a poll from being displayed until the end_datetime is reached.
	var/dont_show
	///Allows a player to change their vote to a poll they've already voted on, off by default.
	var/allow_revoting
	///Indicates if a poll has been submitted or loaded from the DB so the management panel will open with edit functions.
	var/edit_ready = FALSE
	///Holds duration data when creating or editing a poll and refreshing the poll creation window.
	var/duration
	///Holds interval data when creating or editing a poll and refreshing the poll creation window.
	var/interval
	///Indicates a poll is set to not start in the future, still visible for editing but not voting on.
	var/future_poll

/**
 * Datum which holds details of a poll option loaded from the database.
 *
 * Used to minimize the need for querying this data every time it's needed.
 *
 */
/datum/poll_option
	///Reference to the poll this option belongs to
	var/datum/poll_question/parent_poll
	///Table id of this option, will be null until poll has been created.
	var/option_id
	///Description/name of this option
	var/text
	///For rating polls, the minimum selectable value allowed; Supported value range is -2147483648 to 2147483647
	var/min_val
	///For rating polls, the maximum selectable value allowed; Supported value range is -2147483648 to 2147483647
	var/max_val
	///Optional for rating polls, description shown next to the minimum value
	var/desc_min = ""
	///Optional for rating polls, description shown next to the rounded whole middle value
	var/desc_mid = ""
	///Optional for rating polls, description shown next to the maximum value
	var/desc_max = ""
	///Hint for statbus, not used by the game; If this option should be included by default when calculating the resulting percentages of all options for this poll
	var/default_percentage_calc

/**
 * Shows a list of all current and future polls and buttons to edit or delete them or create a new poll.
 *
 */
/datum/admins/proc/poll_list_panel()
	var/list/output = list("当前及尚未开始的投票<br>编辑投票或选项后，须点击提交投票才能保存更改。<br><a href='?_src_=holder;[HrefToken()];newpoll=1'>新建投票</a><a href='?_src_=holder;[HrefToken()];reloadpolls=1'>重新加载投票</a><hr>")
	for(var/p in GLOB.polls)
		var/datum/poll_question/poll = p
		output += {"[poll.question]
		<a href='?_src_=holder;[HrefToken()];editpoll=[REF(poll)]'> 编辑</a>
		<a href='?_src_=holder;[HrefToken()];deletepoll=[REF(poll)]'> 删除</a>
		"}
		if(poll.subtitle)
			output += "<br>[poll.subtitle]"
		output += "<br>[poll.future_poll ? "开始时间" : "已开始于"]：[poll.start_datetime] | 结束时间：[poll.end_datetime]"
		if(poll.admin_only)
			output += " | 仅限管理员"
		if(poll.dont_show)
			output += " | 结束前隐藏统计结果"
		output += " | 已有 [poll.poll_votes] 位玩家[poll.poll_type == POLLTYPE_TEXT ? "回复" : "投票"]<hr style='background:#000000; border:0; height:3px'>"
	var/datum/browser/panel = new(usr, "plpanel", "投票列表", 700, 400)
	panel.set_content(jointext(output, ""))
	panel.open()

/**
 * Show the options for creating a poll or editing its parameters along with its linked options.
 *
 */
/datum/admins/proc/poll_management_panel(datum/poll_question/poll)
	var/list/output = list("<form method='get' action='?src=[REF(src)]'>[HrefTokenFormField()]")
	output += {"<input type='hidden' name='src' value='[REF(src)]'>投票类型
	<div class="select">
		<select name='polltype' [poll ? " disabled": ""]>
			<option value='[POLLTYPE_OPTION]'[poll?.poll_type == POLLTYPE_OPTION ? " selected" : ""]>单选</option>
			<option value='[POLLTYPE_TEXT]'[poll?.poll_type == POLLTYPE_TEXT ? " selected" : ""]>文字回复</option>
			<option value='[POLLTYPE_RATING]'[poll?.poll_type == POLLTYPE_RATING ? " selected" : ""]>评分</option>
			<option value='[POLLTYPE_MULTI]'[poll?.poll_type == POLLTYPE_MULTI ? " selected" : ""]>多选</option>
			<option value='[POLLTYPE_IRV]'[poll?.poll_type == POLLTYPE_IRV ? " selected" : ""]>排序复选制</option>
		</select>
	</div>
	问题
	<input type='text' name='question' size='34' value='[poll?.question]'>
	多选时允许选择的选项数
	<input type='text' name='optionsallowed' size='2' value='[poll?.options_allowed]'>
	<br>
	<label class='inputlabel checkbox'>
		仅限管理员
		<input type='checkbox' id='adminonly' name='adminonly' value='1'[poll?.admin_only ? " checked" : ""]>
		<div class='inputbox'></div>
	</label>
	<label class='inputlabel checkbox'>
		结束前隐藏结果
		<input type='checkbox' id='dontshow' name='dontshow' value='1'[poll?.dont_show ? " checked" : ""]>
		<div class='inputbox'></div>
	</label>
	<label class='inputlabel checkbox'>
		允许重新投票
		<input type='checkbox' id='allowrevoting' name='allowrevoting' value='1'[poll?.allow_revoting ? " checked" : ""]>
		<div class='inputbox'></div>
	</label>
	<br>
	<div class='row'>
		<div class='column left'>
			持续时间
			<br>
			<label class='inputlabel radio'>
				持续
				<input type='radio' id='runfor' name='radioduration' value='runfor'[poll?.interval ? " checked" : ""]>
				<div class='inputbox'></div>
			</label>
			<input type='text' name='duration' size='7'[poll?.interval ? " value='[poll?.duration]''" : ""]'>
			<div class="select">
				<select name='durationtype'>
					<option value='SECOND'[poll?.interval == "SECOND" ? " selected" : ""]>秒</option>
					<option value='MINUTE'[poll?.interval == "MINUTE" ? " selected" : ""]>分钟</option>
					<option value='HOUR'[poll?.interval == "HOUR" ? " selected" : ""]>小时</option>
					<option value='DAY'[(!poll?.interval || poll?.interval == "DAY") ? " selected" : ""]>天</option>
					<option value='WEEK'[poll?.interval == "WEEK" ? " selected" : ""]>周</option>
					<option value='MONTH'[poll?.interval == "MONTH" ? " selected" : ""]>月</option>
					<option value='YEAR'[poll?.interval == "YEAR" ? " selected" : ""]>年</option>
				</select>
			</div>
			<br>
			<label class='inputlabel radio'>
				持续至
				<input type='radio' id='rununtil' name='radioduration' value='rununtil' [!poll?.interval ? " checked" : ""]>
				<div class='inputbox'></div>
			</label>
			<input type='text' name='enddatetimetext' size='24' value='[poll?.end_datetime ? "[poll.end_datetime]" : "YYYY-MM-DD HH:MM:SS"]'>
		</div>
		<div class='column'>
			开始时间
			<br>
			<label class='inputlabel radio'>
				立即
				<input type='radio' id='startnow' name='radiostart' value='startnow'[!poll?.start_datetime ? " checked" : ""]>
				<div class='inputbox'></div>
			</label>
			</div>
			<br>
			<label class='inputlabel radio'>
				指定日期时间
				<input type='radio' id='startdatetime' name='radiostart' value='startdatetime'[poll?.start_datetime ? " checked" : ""]>
				<div class='inputbox'></div>
			</label>
			<input type='text' name='startdatetimetext' size='24' value='[poll?.start_datetime ? "[poll.start_datetime]" : "YYYY-MM-DD HH:MM:SS"]'>
		</div></div>
		<div class='row'>
		<div class='column left'>
			副标题（可选）
			<br>
			<textarea class='textbox' name='subtitle'>[poll?.subtitle]</textarea>
		</div>
		<div class='column spacer'>
		"}
	var/option_count = 0
	if(!poll)
		output += {"<input type='hidden' name='initializepoll' value='1'>
		<input type='submit' value='初始化问题'>
		</div></div>
		</form>
		<hr>
		首先填写投票问题详情，然后点击初始化问题。
		<br>
		随后添加选项，点击提交投票以保存并创建问题和选项。文字回复投票无需选项。
		<br>
		<a href='[CONFIG_GET(string/wikiurl)]/Guide_to_poll_types'>应该选择哪种投票类型？</a>
		"}
	else
		output += "<input type='hidden' name='submitpoll' value='[REF(poll)]'><input type='submit' value='提交投票'>"
		if(poll.edit_ready)
			output += {"<label class='inputlabel checkbox'>编辑时清除投票记录
			<input type='checkbox' id='clearvotesedit' name='clearvotesedit' value='1' checked>
			<div class='inputbox'></div>
			</label></form>
			<br>
			"}
			if(poll.poll_type == POLLTYPE_TEXT)
				output += "<a href='?_src_=holder;[HrefToken()];clearpollvotes=[REF(poll)]'>清除投票回复</a> 已有 [poll.poll_votes] 位玩家回复"
			else
				output += "<a href='?_src_=holder;[HrefToken()];clearpollvotes=[REF(poll)]'>清除投票记录</a> 已有 [poll.poll_votes] 位玩家投票"
		if(poll.poll_type == POLLTYPE_TEXT)
			output += "</div></div>"
		else
			output += "</div></div><hr><a href='?_src_=holder;[HrefToken()];addpolloption=[REF(poll)]'>添加选项</a><br>"
			if(length(poll.options))
				for(var/o in poll.options)
					var/datum/poll_option/option = o
					option_count++
					output += {"选项 [option_count]
					<a href='?_src_=holder;[HrefToken()];editpolloption=[REF(option)];parentpoll=[REF(poll)]'> 编辑</a>
					<a href='?_src_=holder;[HrefToken()];deletepolloption=[REF(option)]'> 删除</a>
					<br>[option.text]
					"}
					if(poll.poll_type == POLLTYPE_RATING)
						output += {"<br>最小值：[option.min_val] | 最大值：[option.max_val]
						<br>最小值说明：[option.desc_min]
						<br>中间值说明：[option.desc_mid]
						<br>最大值说明：[option.desc_max]
						"}
					output += "<hr style='background:#000000; border:0; height:3px'>"
	var/datum/browser/panel = new(usr, "pmpanel", "投票管理面板", 780, 640)
	panel.add_stylesheet("admin_panelscss", 'html/admin/admin_panels.css')
	panel.add_stylesheet("admin_panelscss3", 'html/admin/admin_panels_css3.css')
	panel.set_content(jointext(output, ""))
	panel.open()

/**
 * Processes topic data from poll management panel.
 *
 * Reads through returned form data and assigns data to the poll datum, creating a new one if required, before passing it to be saved.
 * Also does some simple error checking to ensure the poll will be valid before creation.
 *
 */
/datum/admins/proc/poll_parse_href(list/href_list, datum/poll_question/poll)
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return
	var/list/error_state = list()
	var/new_poll = FALSE
	var/clear_votes = FALSE
	var/submit_ready = FALSE
	if(!poll)
		poll = new(creator = usr.client.ckey)
		new_poll = TRUE
	if(new_poll)
		poll.poll_type = href_list["polltype"]
	switch(href_list["radioduration"])
		if("runfor")
			poll.duration = text2num(href_list["duration"])
			poll.interval = href_list["durationtype"]
		if("rununtil")
			if(href_list["enddatetimetext"] != "YYYY-MM-DD HH:MM:SS")
				poll.duration = href_list["enddatetimetext"]
				if(new_poll)
					poll.end_datetime = poll.duration
	if(!poll.duration)
		error_state += "未提供持续时间。"
	switch(href_list["radiostart"])
		if("startnow")
			poll.start_datetime = null
		if("startdatetime")
			if(href_list["startdatetimetext"] && href_list["startdatetimetext"] != "YYYY-MM-DD HH:MM:SS")
				poll.start_datetime = href_list["startdatetimetext"]
			else
				error_state += "已选择指定开始日期时间，但未填写具体时间。"
	if(href_list["question"])
		poll.question = href_list["question"]
	else
		error_state += "未填写问题。"
	poll.subtitle = href_list["subtitle"]
	if(href_list["adminonly"])
		poll.admin_only = TRUE
	else
		poll.admin_only = FALSE
	if(href_list["dontshow"])
		poll.dont_show = TRUE
	else
		poll.dont_show = FALSE
	if(href_list["allowrevoting"])
		poll.allow_revoting = TRUE
	else
		poll.allow_revoting = FALSE
	if(href_list["clearvotesedit"])
		clear_votes = TRUE
	if(href_list["submitpoll"])
		submit_ready = TRUE
	if(poll.poll_type == POLLTYPE_MULTI)
		if(text2num(href_list["optionsallowed"]))
			poll.options_allowed = text2num(href_list["optionsallowed"])
			if(poll.options_allowed == 1)
				error_state += "多选投票必须允许选择多个选项，单选请使用单选投票。"
			if(poll.options_allowed < 0)
				error_state += "允许选择的选项数不能为负数。"
		else
			error_state += "已选择多选投票，但未填写允许选择的选项数。"
	if(submit_ready && poll.poll_type != POLLTYPE_TEXT && !length(poll.options))
		error_state += "此投票类型至少需要一个选项。"
	if(error_state.len)
		if(poll.edit_ready)
			to_chat(usr, span_danger("存在以下错误，部分更改未能应用：\n[error_state.Join("\n")]"))
		else
			to_chat(usr, span_danger("存在以下错误，投票未能[new_poll ? "初始化" : "提交"]：\n[error_state.Join("\n")]"))
			if(new_poll)
				qdel(poll)
		return
	if(submit_ready)
		var/db = poll.edit_ready //if the poll is new it will need its options inserted for the first time
		poll.save_poll_data(clear_votes)
		if(!db)
			poll.save_all_options()
	poll_management_panel(poll)

/datum/poll_question/New(id, polltype, starttime, endtime, question, subtitle, adminonly, multiplechoiceoptions, dontshow, allow_revoting, vote_count, creator, future, dbload = FALSE)
	poll_id = text2num(id)
	poll_type = polltype
	start_datetime = starttime
	end_datetime = endtime
	src.question = question
	src.subtitle = subtitle
	admin_only = text2num(adminonly)
	options_allowed = text2num(multiplechoiceoptions)
	dont_show = text2num(dontshow)
	src.allow_revoting = text2num(allow_revoting)
	poll_votes = text2num(vote_count) || 0
	created_by = creator
	future_poll = text2num(future)
	edit_ready = dbload
	GLOB.polls += src

/datum/poll_question/Destroy()
	GLOB.polls -= src
	return ..()

/**
 * Sets a poll and its associated data as deleted in the database.
 *
 * Calls the procedure set_poll_deleted to set the deleted column to 1 for each row in the poll_ tables matching the poll id used.
 * Then deletes each option datum and finally the poll itself.
 *
 */
/datum/poll_question/proc/delete_poll()
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return
	var/datum/DBQuery/query_delete_poll = SSdbcore.NewQuery(
		"CALL set_poll_deleted(:poll_id)",
		list("poll_id" = poll_id)
	)
	if(!query_delete_poll.warn_execute())
		qdel(query_delete_poll)
		return
	qdel(query_delete_poll)
	for(var/o in options)
		var/datum/poll_option/option = o
		qdel(option)
	GLOB.polls -= src
	qdel(src)

/**
 * Inserts or updates a poll question to the database.
 *
 * Uses INSERT ON DUPLICATE KEY UPDATE to handle both inserting and updating at once.
 * The start and end datetimes and poll id for new polls is then retrieved for the poll datum.
 * Arguments:
 * * clear_votes - When true will call clear_poll_votes() to delete all votes matching this poll id.
 *
 */
/datum/poll_question/proc/save_poll_data(clear_votes)
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return
	var/new_poll = !poll_id
	if(poll_type != POLLTYPE_MULTI)
		options_allowed = null
	var/admin_ckey = created_by
	var/admin_ip = usr.client.address

	var/end_datetime_sql
	if (interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR"))
		end_datetime_sql = "NOW() + INTERVAL :duration [interval]"
	else
		end_datetime_sql = ":duration"

	var/kn = key_name(usr)
	var/kna = key_name_admin(usr)
	var/datum/DBQuery/query_save_poll = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("poll_question")] (id, polltype, created_datetime, starttime, endtime, question, subtitle, adminonly, multiplechoiceoptions, createdby_ckey, createdby_ip, dontshow, allow_revoting)
		VALUES (:poll_id, :poll_type, NOW(), COALESCE(:start_datetime, NOW()), [end_datetime_sql], :question, :subtitle, :admin_only, :options_allowed, :admin_ckey, INET_ATON(:admin_ip), :dont_show, :allow_revoting)
		ON DUPLICATE KEY UPDATE starttime = :start_datetime, endtime = [end_datetime_sql], question = :question, subtitle = :subtitle, adminonly = :admin_only, multiplechoiceoptions = :options_allowed, dontshow = :dont_show, allow_revoting = :allow_revoting
	"}, list(
		"poll_id" = poll_id, "poll_type" = poll_type, "start_datetime" = start_datetime, "duration" = duration,
		"question" = question, "subtitle" = subtitle, "admin_only" = admin_only, "options_allowed" = options_allowed,
		"admin_ckey" = admin_ckey, "admin_ip" = admin_ip, "dont_show" = dont_show, "allow_revoting" = allow_revoting
	))
	if(!query_save_poll.warn_execute())
		qdel(query_save_poll)
		return
	if (!poll_id)
		poll_id = query_save_poll.last_insert_id
	qdel(query_save_poll)
	var/datum/DBQuery/query_get_poll_id_start_endtime = SSdbcore.NewQuery(
		"SELECT starttime, endtime, IF(starttime > NOW(), 1, 0) FROM [format_table_name("poll_question")] WHERE id = :poll_id",
		list("poll_id" = poll_id)
	)
	if(!query_get_poll_id_start_endtime.warn_execute())
		qdel(query_get_poll_id_start_endtime)
		return
	if(query_get_poll_id_start_endtime.NextRow())
		start_datetime = query_get_poll_id_start_endtime.item[1]
		end_datetime = query_get_poll_id_start_endtime.item[2]
		future_poll = text2num(query_get_poll_id_start_endtime.item[3])
	qdel(query_get_poll_id_start_endtime)
	if(clear_votes)
		clear_poll_votes()
	edit_ready = TRUE
	var/msg = "[new_poll ? "创建" : "编辑"]了[admin_only ? "仅限管理员的" : ""]服务器投票。问题：[question]"
	if(admin_only)
		log_admin_private("[kn] [msg]")
	else
		log_admin("[kn] [msg]")
	message_admins("[kna] [msg]")

/**
 * Saves all options of a poll to the database.
 *
 * Saves all the created options for a poll when it's submitted to the DB for the first time and associated an id with the options.
 * Insertion and id querying for each option is done separately to ensure data integrity; this is less performant, but not significantly.
 * Using MassInsert() would mean having to query a list of rows by poll_id or matching by fields afterwards, which doesn't guarantee accuracy.
 *
 */
/datum/poll_question/proc/save_all_options()
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return
	for(var/o in options)
		var/datum/poll_option/option = o
		option.save_option()

/**
 * Deletes all votes or text replies for this poll, depending on its type.
 *
 */
/datum/poll_question/proc/clear_poll_votes()
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return
	var/table = "poll_vote"
	if(poll_type == POLLTYPE_TEXT)
		table = "poll_textreply"
	var/datum/DBQuery/query_clear_poll_votes = SSdbcore.NewQuery(
		"UPDATE [format_table_name(table)] SET deleted = 1 WHERE pollid = :poll_id",
		list("poll_id" = poll_id)
	)
	if(!query_clear_poll_votes.warn_execute())
		qdel(query_clear_poll_votes)
		return
	qdel(query_clear_poll_votes)
	poll_votes = 0
	to_chat(usr, span_danger("投票[poll_type == POLLTYPE_TEXT ? "回复" : "记录"]已清除。"))

/**
 * Show the options for creating a poll option or editing its parameters.
 *
 */
/datum/admins/proc/poll_option_panel(datum/poll_question/poll, datum/poll_option/option)
	var/list/output = list("<form method='get' action='?src=[REF(src)]'>[HrefTokenFormField()]")
	output += {"<input type='hidden' name='src' value='[REF(src)]'>	投票 [poll.question] 的选项
	<br>
	<textarea class='textbox' name='optiontext'>[option?.text]</textarea>
	<br>
	"}
	if(poll.poll_type == POLLTYPE_RATING)
		output += {"最小值
		<input type='text' name='minval' size='3' value='[option?.min_val]'>
		最大值
		<input type='text' name='maxval' size='3' value='[option?.max_val]'>
		<div class='row'>
			<div class='column left'>
				<label class='inputlabel checkbox'>最小值说明
				<input type='checkbox' id='descmincheck' name='descmincheck' value='1'[option?.desc_min ? " checked": ""]>
				<div class='inputbox'></div></label>
				<br>
				<label class='inputlabel checkbox'>中间值说明
				<input type='checkbox' id='descmidcheck' name='descmidcheck' value='1'[option?.desc_mid ? " checked": ""]>
				<div class='inputbox'></div></label>
				<br>
				<label class='inputlabel checkbox'>最大值说明
				<input type='checkbox' id='descmaxcheck' name='descmaxcheck' value='1'[option?.desc_max ? " checked": ""]>
				<div class='inputbox'></div></label>
			</div>
			<div class='column'>
				<input type='text' name='descmintext' size='26' value='[option?.desc_min]'>
				<br>
				<input type='text' name='descmidtext' size='26' value='[option?.desc_mid]'>
				<br>
				<input type='text' name='descmaxtext' size='26' value='[option?.desc_max]'>
			</div>
		</div>
		"}
	output += {"<label class='inputlabel checkbox'>将此选项纳入投票结果百分比计算
	<input type='checkbox' id='defpercalc' name='defpercalc' value='1'[option?.default_percentage_calc ? " checked": ""]>
	<div class='inputbox'></div></label><br>
	<input type='hidden' name='submitoption' value='[REF(option)]'>
	<input type='hidden' name='submitoptionpoll' value='[REF(poll)]'>
	<input type='submit' value='添加选项'>
	"}
	var/panel_height = 180
	if(poll.poll_type == POLLTYPE_RATING)
		panel_height = 320
	var/datum/browser/panel = new(usr, "popanel", "投票选项面板", 370, panel_height)
	panel.add_stylesheet("admin_panelscss", 'html/admin/admin_panels.css')
	panel.add_stylesheet("admin_panelscss3", 'html/admin/admin_panels_css3.css')
	panel.set_content(jointext(output, ""))
	panel.open()

/**
 * Processes topic data from poll option panel.
 *
 * Reads through returned form data and assigns data to the option datum, creating a new one if required, before passing it to be saved.
 * Also does some simple error checking to ensure the option will be valid before creation.
 *
 */
/datum/admins/proc/poll_option_parse_href(list/href_list, datum/poll_question/poll, datum/poll_option/option)
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return
	var/list/error_state = list()
	var/new_option = FALSE
	if(!option)
		option = new()
		new_option = TRUE
	if(href_list["optiontext"])
		option.text = href_list["optiontext"]
	else
		error_state += "未填写选项文字。"
	if(href_list["defpercalc"])
		option.default_percentage_calc = TRUE
	else
		option.default_percentage_calc = FALSE
	if(poll.poll_type == POLLTYPE_RATING)
		var/value_in_range = text2num(href_list["minval"])
		if(href_list["minval"])
			if(ISINRANGE(value_in_range, -2147483647, 2147483647))
				option.min_val = value_in_range
			else
				error_state += "最小值超出范围。"
		else
			error_state += "未填写最小值。"
		value_in_range = text2num(href_list["maxval"])
		if(href_list["maxval"])
			if(ISINRANGE(value_in_range, -2147483647, 2147483647))
				if(value_in_range < option.min_val)
					error_state += "最大值小于最小值。"
				else
					option.max_val = value_in_range
			else
				error_state += "最大值超出范围。"
		else
			error_state += "未填写最大值。"
		if(href_list["descmincheck"])
			if(href_list["descmintext"])
				option.desc_min = href_list["descmintext"]
			else
				error_state += "已勾选最小值说明，但未填写内容。"
		else
			option.desc_min = null
		if(href_list["descmidcheck"])
			if(href_list["descmidtext"])
				option.desc_mid = href_list["descmidtext"]
			else
				error_state += "已勾选中间值说明，但未填写内容。"
		else
			option.desc_mid = null
		if(href_list["descmaxcheck"])
			if(href_list["descmaxtext"])
				option.desc_max = href_list["descmaxtext"]
			else
				error_state += "已勾选最大值说明，但未填写内容。"
		else
			option.desc_max = null
	if(error_state.len)
		if(new_option)
			to_chat(usr, span_danger("存在以下错误，选项未能添加：\n[error_state.Join("\n")]"))
			qdel(option)
		else
			to_chat(usr, span_danger("存在以下错误，部分更改未能应用：\n[error_state.Join("\n")]"))
		return
	if(new_option)
		poll.options += option
		option.parent_poll = poll
	if(poll.edit_ready)
		option.save_option()
	poll_management_panel(poll)

/datum/poll_option/New(id, text, minval, maxval, descmin, descmid, descmax, default_percentage_calc)
	option_id = text2num(id)
	src.text = text
	min_val = text2num(minval)
	max_val = text2num(maxval)
	desc_min = descmin
	desc_mid = descmid
	desc_max = descmax
	src.default_percentage_calc = text2num(default_percentage_calc)
	GLOB.poll_options += src

/datum/poll_option/Destroy()
	parent_poll.options -= src
	parent_poll = null
	GLOB.poll_options -= src
	return ..()

/**
 * Inserts or updates a poll option to the database.
 *
 * Uses INSERT ON DUPLICATE KEY UPDATE to handle both inserting and updating at once.
 * The list of columns and values is built dynamically to avoid excess data being sent when not a rating type poll.
 *
 */
/datum/poll_option/proc/save_option()
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return

	var/list/values = list("text" = text, "default_percentage_calc" = default_percentage_calc, "pollid" = parent_poll.poll_id, "id" = option_id)
	if(parent_poll.poll_type == POLLTYPE_RATING)
		values["minval"] = min_val
		values["maxval"] = max_val
		values["descmin"] = desc_min
		values["descmid"] = desc_mid
		values["descmax"] = desc_max

	var/update_data = list()
	for (var/k in values)
		update_data += "[k] = VALUES([k])"

	var/datum/DBQuery/query_update_poll_option = SSdbcore.NewQuery(
		"INSERT INTO [format_table_name("poll_option")] ([jointext(values, ",")]) VALUES (:[jointext(values, ",:")]) ON DUPLICATE KEY UPDATE [jointext(update_data, ", ")]",
		values
	)
	if(!query_update_poll_option.warn_execute())
		qdel(query_update_poll_option)
		return
	if (!option_id)
		option_id = query_update_poll_option.last_insert_id
	qdel(query_update_poll_option)

/**
 * Sets a poll option and its votes as deleted in the database then deletes its datum.
 *
 */
/datum/poll_option/proc/delete_option()
	if(!check_rights(R_POLL))
		return
	. = parent_poll
	if(option_id)
		if(!SSdbcore.Connect())
			to_chat(usr, span_danger("无法连接数据库。"))
			return
		var/datum/DBQuery/query_delete_poll_option = SSdbcore.NewQuery(
			"UPDATE [format_table_name("poll_option")] AS o INNER JOIN [format_table_name("poll_vote")] AS v ON o.id = v.optionid SET o.deleted = 1, v.deleted = 1 WHERE o.id = :option_id",
			list("option_id" = option_id)
		)
		if(!query_delete_poll_option.warn_execute())
			qdel(query_delete_poll_option)
			return
		qdel(query_delete_poll_option)
	qdel(src)

/**
 * Loads all current and future server polls and their options to store both as datums.
 *
 */
/proc/load_poll_data()
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("无法连接数据库。"))
		return
	var/datum/DBQuery/query_load_polls = SSdbcore.NewQuery("SELECT id, polltype, starttime, endtime, question, subtitle, adminonly, multiplechoiceoptions, dontshow, allow_revoting, IF(polltype='TEXT',(SELECT COUNT(ckey) FROM [format_table_name("poll_textreply")] AS t WHERE t.pollid = q.id AND deleted = 0), (SELECT COUNT(DISTINCT ckey) FROM [format_table_name("poll_vote")] AS v WHERE v.pollid = q.id AND deleted = 0)), IFNULL((SELECT byond_key FROM [format_table_name("player")] AS p WHERE p.ckey = q.createdby_ckey), createdby_ckey), IF(starttime > NOW(), 1, 0) FROM [format_table_name("poll_question")] AS q WHERE NOW() < endtime AND deleted = 0")
	if(!query_load_polls.Execute())
		qdel(query_load_polls)
		return
	var/list/poll_ids = list()
	while(query_load_polls.NextRow())
		new /datum/poll_question(query_load_polls.item[1], query_load_polls.item[2], query_load_polls.item[3], query_load_polls.item[4], query_load_polls.item[5], query_load_polls.item[6], query_load_polls.item[7], query_load_polls.item[8], query_load_polls.item[9], query_load_polls.item[10], query_load_polls.item[11], query_load_polls.item[12], query_load_polls.item[13], TRUE)
		poll_ids += query_load_polls.item[1]
	qdel(query_load_polls)
	if(length(poll_ids))
		var/datum/DBQuery/query_load_poll_options = SSdbcore.NewQuery("SELECT id, text, minval, maxval, descmin, descmid, descmax, default_percentage_calc, pollid FROM [format_table_name("poll_option")] WHERE pollid IN ([jointext(poll_ids, ",")])")
		if(!query_load_poll_options.Execute())
			qdel(query_load_poll_options)
			return
		while(query_load_poll_options.NextRow())
			var/datum/poll_option/option = new(query_load_poll_options.item[1], query_load_poll_options.item[2], query_load_poll_options.item[3], query_load_poll_options.item[4], query_load_poll_options.item[5], query_load_poll_options.item[6], query_load_poll_options.item[7], query_load_poll_options.item[8])
			var/option_poll_id = text2num(query_load_poll_options.item[9])
			for(var/q in GLOB.polls)
				var/datum/poll_question/poll = q
				if(poll.poll_id == option_poll_id)
					poll.options += option
					option.parent_poll = poll
		qdel(query_load_poll_options)
