/// 将规则正文包装为完整的 HTML 文档，中文用字符引用传给 DreamSeeker。
/proc/z121_dice_rules_html(rules_html)
	var/list/parts = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'></head><body>")
	var/byte_index = 1
	while(byte_index <= length(rules_html))
		var/codepoint = text2ascii(rules_html, byte_index)
		var/character = ascii2text(codepoint)
		parts += codepoint < 128 ? character : "&#[num2text(codepoint, 1, 10)];"
		byte_index += length(character)
	parts += "</body></html>"
	return parts.Join()

/proc/get_chess_result_display(value)
	var/static/list/names = list("Checkmate. 白方 wins." = "将死，白方获胜。", "Checkmate. 黑方 wins." = "将死，黑方获胜。")
	return names[value] || value
