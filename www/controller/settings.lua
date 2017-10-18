local dc = require 'skynet.datacenter'

return {
	get = function(self)
		if lwf.auth.user == 'Guest' then
			self:redirect('/user/login')
		else
			local using_beta = dc.get('CLOUD', 'USING_BETA')
			local pkg_host = dc.get('CLOUD', 'PKG_HOST_URL')
			lwf.render('settings.html', {using_beta=using_beta, pkg_host=pkg_host})
		end
	end,
	post = function(self)
		ngx.req.read_body()
		local post = ngx.req.get_post_args()
		local action = post.action
		if action == 'pkg' then
			local option = post.option
			local value = post.value
			if value == 'true' then
				value = true
			end
			if value == 'false' then
				value = false
			end
			dc.set('CLOUD', string.upper(option), value)
			ngx.print(_('PKG option is changed!'))
		end
	end
}
