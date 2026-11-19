-----------------------
-- Name: 曲目记录
-- Author: FlameCyclone
-- Date: 2025.6.11
-----------------------
-- 曲目记录
-----------------------

file_exec = io.open ("file_exec.txt", "wb+")
local addr_record_list = {}

--记录执行地址的数据(文本)
function on_addr_exec_text_E0()
    pc = memory.getregister("pc")
    a = memory.getregister("a")
    x = memory.getregister("x")
    y = memory.getregister("y")
	
	data_l = memory.readbyte(0xE0)
	data_h = memory.readbyte(0xE1)
	addr16_l = OR(data_h * 256, data_l) + y
	addr16_h = OR(data_h * 256, data_l) + y + 1
	addr16_data = memory.readword(addr16_l)
	
	if nil == addr_record_list[addr16_l] then
		info = string.format("%.4X", addr16_l)
		emu.print(info)
	end
	
	addr_record_list[addr16_l] = addr16_data
end

function on_addr_exec_text_0112()
    pc = memory.getregister("pc")
    a = memory.getregister("a")
    x = memory.getregister("x")
    y = memory.getregister("y")
	
	data_l = memory.readbyte(0x0112 + x)
	data_h = memory.readbyte(0x0118 + x)
	addr16_l = OR(data_h * 256, data_l)
	addr16_h = OR(data_h * 256, data_l)
	addr16_data = memory.readword(addr16_l)
	
	if nil == addr_record_list[addr16_l] then
		info = string.format("%.4X,", addr16_l)
		emu.print(info)
	end
	
	addr_record_list[addr16_l] = addr16_data
end

function on_addr_exec_text_E8()
    pc = memory.getregister("pc")
    a = memory.getregister("a")
    x = memory.getregister("x")
    y = memory.getregister("y")
	
	data_l = memory.readbyte(0xEC + y)
	data_h = memory.readbyte(0xED + y)
	addr16_l = OR(data_h * 256, data_l)
	addr16_h = OR(data_h * 256, data_l)
	addr16_data = memory.readword(addr16_l)
	
	if nil == addr_record_list[addr16_l] then
		info = string.format("%.4X,", addr16_l)
		emu.print(info)
	end
	
	addr_record_list[addr16_l] = addr16_data
end

function on_addr_exec_text_EC()
    pc = memory.getregister("pc")
    a = memory.getregister("a")
    x = memory.getregister("x")
    y = memory.getregister("y")
	
	data_l = memory.readbyte(0xEC)
	data_h = memory.readbyte(0xED)
	addr16_l = OR(data_h * 256, data_l) + y
	addr16_h = OR(data_h * 256, data_l) + y + 1
	addr16_data = memory.readword(addr16_l)
	
	if nil == addr_record_list[addr16_l] then
		info = string.format("%.4X", addr16_l)
		emu.print(info)
	end
	
	addr_record_list[addr16_l] = addr16_data
end

--注册端口执行回调
--memory.registerexec(0x82E8,on_addr_exec_text_E0)
--memory.registerexec(0x8629,on_addr_exec_text_E0)
--memory.registerexec(0x8859,on_addr_exec_text_EC)
--memory.registerexec(0x8636,on_addr_exec_text_0112)
memory.registerexec(0x8851,on_addr_exec_text_EC)
--memory.registerexec(0x8466,on_addr_exec_text_0112)

--停止回调
function on_exit()

    for k, v in pairs(addr_record_list) do
		info = string.format("%.4X,", k, v)
		--emu.print(info)
		file_exec:write(info)
    end

    file_exec:close()
    emu.print("stop...")
end

emu.registerexit(on_exit)

emu.print("start...")
while (true) do
	emu.frameadvance()
end
