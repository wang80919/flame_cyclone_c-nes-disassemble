
cd /d %~dp0

rem -I    输入文件路径
rem -O    输出文件路径
rem -Load 文件数据加载到  64KB 内存地址中哪个位置
rem -Org  需要反汇编的地址
rem -Data 数据段指定

NesDisassemble.exe -I="Battle City (J) [!].bin" -O="[FC][Code].asm" -Load=EA51 -Org=ea7e,ef76,ec75,ec08,EC0A,EC21,EC33,EC45,EC57,EC61,EC6B,EC75,EC81,EC85,EC99 -Data=EBE6,22;ECE6,0290;EF8E,2A

pause