local sys = require "luci.sys"
local utl = require "luci.util"

local f = SimpleForm("interfaceview", translate("ZeroTier Interface Information"))
f.description = translate("Detailed view of all ZeroTier interfaces currently active on this device.")
f.reset = false  -- Disable Reset button
f.submit = false -- Disable Submit button

-- Table for interface details
local t = f:section(Table, {}, translate("Summary"))

-- Get raw output of ifconfig and extract ZeroTier interfaces
local ifconfig_output = luci.sys.exec("ifconfig")
local interfaces = {}
local interface_details = {}

for block in ifconfig_output:gmatch("(%S+.-)\n\n") do
    local iface = block:match("^(%S+)")
    if iface and iface:match("^zt") then
        interfaces[#interfaces + 1] = iface
        interface_details[iface] = block
    end
end

-- Check if interfaces are found
if #interfaces > 0 then
    -- Prepare table rows
    local rows = {}
    for _, iface in ipairs(interfaces) do
        local details = interface_details[iface]
        if details then
            local row = {
                _iface = iface,
                _mac = details:match("HWaddr%s+([%x:]+)") or "N/A",
                _ipv4 = details:match("inet addr:(%S+)") or "N/A",
                _ipv6 = details:match("inet6 addr:%s*([%x:]+)") or "N/A",
                _mtu = details:match("MTU:(%d+)") or "N/A",
                _rx = details:match("RX bytes:%d+ %(([%d.]+%s?%a+)%)") or "0 B",
                _tx = details:match("TX bytes:%d+ %(([%d.]+%s?%a+)%)") or "0 B"
            }
            table.insert(rows, row)
        end
    end

    -- Define table columns
    t:option(DummyValue, "_iface", translate("Interface Name"))
    t:option(DummyValue, "_mac", translate("MAC Address"))
    t:option(DummyValue, "_ipv4", translate("IPv4 Address"))
    t:option(DummyValue, "_ipv6", translate("IPv6 Address"))
    t:option(DummyValue, "_mtu", translate("MTU"))
    t:option(DummyValue, "_rx", translate("Total Download"))
    t:option(DummyValue, "_tx", translate("Total Upload"))

    -- Populate table
    t.data = rows
else
    f.description = translate("No ZeroTier interfaces found.")
end

-- Add consolidated raw output
local raw_details = f:section(SimpleSection)
raw_details.title = translate("Details")
raw_details.titlefont = "small"

local raw_text = raw_details:option(TextValue, "raw")
raw_text.rmempty = true
raw_text.rows = 20

function raw_text.cfgvalue()
    local output = {}

    -- Add raw output of ifconfig for ZeroTier interfaces
    for _, iface in ipairs(interfaces) do
        local details = interface_details[iface]
        if details then
            table.insert(output, details)
        end
    end

    -- Add an empty line before the zerotier-cli peers output
    table.insert(output, "") -- Insert an empty line

    -- Add raw output of zerotier-cli peers, skipping the "200 peers" line
    local peers_output = luci.sys.exec("zerotier-cli peers 2>/dev/null")
    if peers_output and peers_output ~= "" then
        local lines = utl.split(peers_output, "\n")
        for i = 2, #lines do -- Start from the second line to skip "200 peers"
            table.insert(output, lines[i])
        end
    end

    return table.concat(output, "\n")
end

raw_text.readonly = "readonly"

return f
