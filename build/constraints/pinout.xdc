#system.xdc

#clock
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk_50m]
set_property PACKAGE_PIN U18 [get_ports sys_clk_50m]
create_clock -period 20.000 -waveform {0.000 10.000} [get_ports sys_clk_50m]

set_clock_groups -asynchronous \
-group [get_clocks -include_generated_clocks clk_fpga_0] \
-group [get_clocks -include_generated_clocks clk_74p25m]

#HDMI interface
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HDMI_OEN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_hpd_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_ddc_scl]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_ddc_sda]

set_property PACKAGE_PIN N18 [get_ports TMDS_clk_p]
set_property PACKAGE_PIN V20 [get_ports {TMDS_data_p[0]}]
set_property PACKAGE_PIN T20 [get_ports {TMDS_data_p[1]}]
set_property PACKAGE_PIN N20 [get_ports {TMDS_data_p[2]}]
set_property PACKAGE_PIN V16 [get_ports {HDMI_OEN[0]}]
set_property PACKAGE_PIN Y19 [get_ports {hdmi_hpd_tri_i[0]}]
set_property PACKAGE_PIN R18 [get_ports hdmi_ddc_scl]
set_property PACKAGE_PIN R16 [get_ports hdmi_ddc_sda]

#led indicator
set_property IOSTANDARD LVCMOS33 [get_ports led_indc]
set_property PACKAGE_PIN M15 [get_ports led_indc]
#set_property IOSTANDARD LVCMOS33 [get_ports led2]
#set_property PACKAGE_PIN K16 [get_ports led2]
#set_property IOSTANDARD LVCMOS33 [get_ports led3]
#set_property PACKAGE_PIN J16 [get_ports led3]
#set_property IOSTANDARD LVCMOS33 [get_ports key1]
#set_property PACKAGE_PIN N15 [get_ports key1]
