a = Map("zerotier")
a.title = translate("ZeroTier")
a.description = translate("Zerotier is an open source, cross-platform and easy to use virtual LAN")

a:section(SimpleSection).template  = "zerotier/zerotier_status"

-- Global Settings
t = a:section(NamedSection, "global", "zerotier")
t:tab("main", translate("General options"))
t:tab("more", translate("Advanced options"))
t.anonymous = true
t.addremove = false

-- General options
e = t:taboption("main", Flag, "enabled", translate("Enable"))
e.default = 0
e.rmempty = false

e = t:taboption("main", Flag, "nat", translate("Auto NAT Clients"))
e.description = translate("Allow zerotier clients access your LAN network")
e.default = 0
e.rmempty = false

-- Advanced options
e = t:taboption("more", Value, "port", translate("Port"))
e.description = translate("Port of zerotier service, default 9993")
e.placeholder = 9993
e.datatype = "and(port,min(1025))"

e = t:taboption("more", TextValue, "secret", translate("Secret"))
e.description = translate("Secret of zerotier client")
e.size = 80
e.rows = 5  -- Adjusted to display 5 rows

e = t:taboption("more", Value, "local_conf", translate("Local configuration"))
e.description = translate("Path to the local.conf")
e.placeholder = "/etc/zerotier.conf"
e.datatype = "file"

e = t:taboption("more", Value, "config_path", translate("Configuration folder"))
e.description = translate("Persistent configuration folder (for ZT controller mode)")
e.placeholder = "/etc/zerotier"

e = t:taboption("more", Flag, "copy_config_path", translate("Copy configuration folder"))
e.description = translate("Copy configuration folder to RAM to prevent writing to flash (for ZT controller mode)")

-- Network Settings
network_section = a:section(TypedSection, "network", translate("Networks"))
network_section.template = "cbi/tblsection"
network_section.addremove = true
network_section.anonymous = false

-- Network ID
e = network_section:option(Value, "id", translate("Network ID"))
e.datatype = "string"
e.rmempty = false
e.validate = function(self, value, section)
    if value == nil or value == "" then
        return nil, translate("Network ID cannot be empty.")
    end
    return value
end

-- Allow Managed
e = network_section:option(Flag, "allow_managed", translate("Allow Managed"))
e.default = 1
e.rmempty = false

-- Allow Global
e = network_section:option(Flag, "allow_global", translate("Allow Global"))
e.default = 0
e.rmempty = false

-- Allow Default
e = network_section:option(Flag, "allow_default", translate("Allow Default"))
e.default = 0
e.rmempty = false

-- Allow DNS
e = network_section:option(Flag, "allow_dns", translate("Allow DNS"))
e.default = 0
e.rmempty = false

-- Zerotier.com Button
zerotier_section = a:section(SimpleSection)
e = zerotier_section:option(DummyValue, "opennewwindow", translate("<input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"Zerotier.com\" onclick=\"window.open('https://my.zerotier.com/network')\" />"))
e.description = translate("Create or manage your zerotier network, and auth clients who could access")

return a
