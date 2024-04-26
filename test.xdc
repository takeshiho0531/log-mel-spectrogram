# クロックの制約設定
# create_clock -period 100 [get_ports clk]
create_clock -period 100.000 -name NNN_clk [get_ports NNN_clk_in]
create_clock -period 20.000 -name sys_clk [get_ports sys_clk_in]
create_clock -period 100.000 -name spi_clk [get_ports spi_clk_in]

# I/Oピンの配置とI/Oスタンダードの設定
# pmod connector
set_property PACKAGE_PIN AY14 [get_ports NNN_clk_in]
set_property IOSTANDARD LVCMOS18 [get_ports NNN_clk_in]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets NNN_clk_in_IBUF_inst/O]

set_property PACKAGE_PIN AY15 [get_ports sys_clk_in]
set_property IOSTANDARD LVCMOS18 [get_ports sys_clk_in]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sys_clk_in_IBUF_inst/O]

set_property PACKAGE_PIN AW15 [get_ports spi_clk_in]
set_property IOSTANDARD LVCMOS18 [get_ports spi_clk_in]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets spi_clk_in_IBUF_inst/O]


# pmod
set_property PACKAGE_PIN AV15 [get_ports rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports rst_n]

set_property PACKAGE_PIN AV16 [get_ports spi_cs]
set_property IOSTANDARD LVCMOS18 [get_ports spi_cs]

set_property PACKAGE_PIN AU16 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS18 [get_ports spi_mosi]

set_property PACKAGE_PIN AT15 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS18 [get_ports spi_miso]

set_property PACKAGE_PIN AT16 [get_ports spi_misoshin_en]
set_property IOSTANDARD LVCMOS18 [get_ports spi_miso_en]



# タイミング制約やエリア制約など、他の必要な制約もここに追加できます

# set_input_delay -clock NNN_clk -max 40 [get_ports NNN_clk_in]
# set_input_delay -clock NNN_clk -min 10 [get_ports NNN_clk_in]

# set_input_delay -clock sys_clk -max 8 [get_ports sys_clk_in]
# set_input_delay -clock sys_clk -min 2 [get_ports sys_clk_in]

# set_input_delay -clock spi_clk -max 40 [get_ports spi_clk_in]
# set_input_delay -clock spi_clk -min 10 [get_ports spi_clk_in]


