# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK100MHZ]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ] 
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK100MHZ]

# Switches for color
set_property PACKAGE_PIN V17 [get_ports {color[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {color[0]}]
set_property PACKAGE_PIN V16 [get_ports {color[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {color[1]}]
set_property PACKAGE_PIN W16 [get_ports {color[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {color[2]}]

# Switches for stiffness
set_property PACKAGE_PIN V2 [get_ports {stiffness[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {stiffness[0]}]
set_property PACKAGE_PIN T3 [get_ports {stiffness[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {stiffness[1]}]
set_property PACKAGE_PIN T2 [get_ports {stiffness[2]}]				 	
	set_property IOSTANDARD LVCMOS33 [get_ports {stiffness[2]}]
set_property PACKAGE_PIN R3 [get_ports {stiffness[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {stiffness[3]}]

# Switches for gravity 
set_property PACKAGE_PIN W2 [get_ports {gravity[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {gravity[0]}]
set_property PACKAGE_PIN U1 [get_ports {gravity[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {gravity[1]}]
set_property PACKAGE_PIN T1 [get_ports {gravity[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {gravity[2]}]
set_property PACKAGE_PIN R2 [get_ports {gravity[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {gravity[3]}]

# LEDs 
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]					 
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}] 

# Spawn
set_property PACKAGE_PIN T17 [get_ports spawn_button]						
	set_property IOSTANDARD LVCMOS33 [get_ports spawn_button]

# Reset
set_property PACKAGE_PIN U18 [get_ports Reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports Reset]

# VGA
set_property PACKAGE_PIN P19 [get_ports HSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports HSync]
set_property PACKAGE_PIN R19 [get_ports VSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports VSync]
# R 
set_property PACKAGE_PIN G19 [get_ports {RGB[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[0]}]
set_property PACKAGE_PIN H19 [get_ports {RGB[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[0]}]
set_property PACKAGE_PIN J19 [get_ports {RGB[0]}]				 
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[0]}]
set_property PACKAGE_PIN N19 [get_ports {RGB[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[0]}]
# B
set_property PACKAGE_PIN N18 [get_ports {RGB[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[2]}]
set_property PACKAGE_PIN L18 [get_ports {RGB[2]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {RGB[2]}]
set_property PACKAGE_PIN K18 [get_ports {RGB[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[2]}]
set_property PACKAGE_PIN J18 [get_ports {RGB[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[2]}]
# G
set_property PACKAGE_PIN J17 [get_ports {RGB[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[1]}]
set_property PACKAGE_PIN H17 [get_ports {RGB[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[1]}]
set_property PACKAGE_PIN G17 [get_ports {RGB[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[1]}]
set_property PACKAGE_PIN D17 [get_ports {RGB[1]}]				 
	set_property IOSTANDARD LVCMOS33 [get_ports {RGB[1]}]

