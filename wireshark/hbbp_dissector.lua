hbbp_proto = Proto("hbbp", "Home Brew Broadcast Protocol")

-- create a function to dissect it
function hbbp_proto.dissector(buffer, pinfo, tree)
    pinfo.cols.protocol = "HBBP"
    local subtree = tree:add(hbbp_proto, buffer(), "HBBP Data")

    -- find the \0 that seperates task and payload
    local i = 0
    local b = buffer():bytes()
    while i < b:len() and b:get_index(i) ~= 0 do
      i = i + 1
    end

    subtree:add(buffer(0, i), "Task: " .. buffer(0, i):string())   
    if b:get_index(i) == 0 then
       subtree:add(buffer(i + 1),"Payload [Length " .. buffer:len() - i .. "]")   
    end
end

-- register our protocol to handle udp port 4950
DissectorTable.get("udp.port"):add(4950, hbbp_proto)