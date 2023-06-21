a = Map("zerotier")
a.title = translate("ZeroTier")
a.description = translate("Zerotier is an open source, cross-platform and easy to use virtual LAN")

a:section(SimpleSection).template  = "zerotier/zerotier_status"

t = a:section(NamedSection, "sample_config", "zerotier")
t.anonymous = true
t.addremove = false

e = t:option(Flag, "enabled", translate("Enable"))
e.default = 0
e.rmempty = false

e = t:option(DynamicList, "join", translate('ZeroTier Network ID'))
e.password = true
e.rmempty = false

e = t:option(Flag, "nat", translate("Auto NAT Clients"))
e.description = translate("Allow zerotier clients access your LAN network")
e.default = 0
e.rmempty = false

e = t:option(Flag, "more", translate("More options"))
function e.cfgvalue(self, section)
	return self:formvalue(section)
end
function e.parse(self, section, novld)
	return true
end

e = t:option(Value, "port", translate("Port"))
e.description = translate("Port of zerotier service, default 9993")
e.placeholder = 9993
e.rmempty = true
e.datatype = "and(port,min(1025))"
e:depends("more","1")

e = t:option(TextValue, "secret", translate("Secret"))
e.description = translate("Secret of zerotier client")
e.rmempty = true
e.size = 80
e:depends("more","1")

e = t:option(Value, "local_conf", translate("Local configuration"))
e.description = translate("Path to the local.conf")
e.placeholder = "/etc/zerotier.conf"
e.rmempty = true
e.datatype = "file"
e:depends("more","1")

e = t:option(Value, "config_path", translate("Configuration folder"))
e.description = translate("Persistent configuration folder (for ZT controller mode)")
e.placeholder = "/etc/zerotier"
e.rmempty = true
--e.datatype = "directory"
e:depends("more","1")

e = t:option(Flag, "copy_config_path", translate("Copy configuration folder"))
e.description = translate("Copy configuration folder to RAM to prevent writing to flash (for ZT controller mode)")
e.rmempty = true
e:depends("more","1")

e = t:option(DummyValue, "opennewwindow", translate("<input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Zerotier.com\" onclick=\"window.open('https://my.zerotier.com/network')\" />"))
e.description = translate("Create or manage your zerotier network, and auth clients who could access")

return a
