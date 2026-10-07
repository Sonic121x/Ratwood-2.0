// Verb to manipulate IDs and ckeys
/client/proc/discord_id_manipulation()
	set name = "Discord 账号管理"
	set category = "-管理-"
	set hidden = 1

	if(!check_rights(R_ADMIN))
		return

	holder.discord_manipulation() 


/datum/admins/proc/discord_manipulation()
	if(!usr.client.holder)
		return

	if(!SSdiscord.enabled)
		to_chat(usr, span_warning("TGS 未启用"))
		return

	var/lookup_choice = alert(usr, "要通过 Discord ID 还是 ckey 查找账号？", "查找方式", "ID", "Ckey", "取消")
	switch(lookup_choice)
		if("ID")
			var/lookup_id = input(usr,"输入 Discord ID 以查找 ckey") as text|null
			var/returned_ckey = SSdiscord.lookup_id(lookup_id)
			if(returned_ckey)
				var/unlink_choice = alert(usr, "Discord ID [lookup_id] 已绑定 ckey [returned_ckey]。要解除绑定还是取消？", "已找到账号", "解除绑定", "取消")
				if(unlink_choice == "解除绑定")
					SSdiscord.unlink_account(returned_ckey)
			else
				to_chat(usr, span_warning("Discord ID <b>[lookup_id]</b> 没有绑定的 ckey"))
		if("Ckey")
			var/lookup_ckey = input(usr,"输入 ckey 以查找 Discord ID") as text|null
			var/returned_id = SSdiscord.lookup_id(lookup_ckey)
			if(returned_id)
				to_chat(usr, span_notice("ckey <b>[lookup_ckey]</b> 已绑定 Discord ID <b>[returned_id]</b>"))
				to_chat(usr, span_notice("Discord 提及格式：<b>&lt;@[returned_id]&gt;</b>")) // &lt; and &gt; print < > in HTML without using them as tags
