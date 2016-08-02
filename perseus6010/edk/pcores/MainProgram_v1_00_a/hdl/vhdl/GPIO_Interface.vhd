----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: A. Salom
-- 
-- Create Date:    17:03:43 02/11/2014 
-- Design Name: 
-- Module Name:    GPIO_Interface - Behavioral 
-- Project Name: DLS LLRF
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GPIO_Interface is
    Port ( o_Reset : out  STD_LOGIC;
           i_Ready : in  STD_LOGIC;
           ov32_Gpio_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ov32_GpioDir : out  STD_LOGIC_VECTOR (31 downto 0);
           iv32_Gpio_in : in  STD_LOGIC_VECTOR (31 downto 0);
           o_SetGpioDir : out  STD_LOGIC;
           o_StartGpio : out  STD_LOGIC;
           iv12_GpioAdcData0 : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_GpioAdcData1 : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_GpioAdcData2 : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_GpioAdcData3 : in  STD_LOGIC_VECTOR (11 downto 0);
           i_GpioAdcData0Valid : in  STD_LOGIC;
           i_GpioAdcData1Valid : in  STD_LOGIC;
           i_GpioAdcData2Valid : in  STD_LOGIC;
           i_GpioAdcData3Valid : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           custom_reg_gpio_write : in  STD_LOGIC_VECTOR (31 downto 0);
           custom_reg_gpio_read_in : in  STD_LOGIC_VECTOR (15 downto 0);
           custom_reg_gpio_read_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  gpio_input_A : out std_logic_vector (12 downto 0);
			  gpio_output_A: in std_logic_vector (10 downto 0);
			  gpio_input_B : out std_logic_vector (12 downto 0);
			  gpio_output_B: in std_logic_vector (10 downto 0);
			  PinDiodeSw : in std_logic_vector (3 downto 0);
			  LLRFITckOut : in std_logic;
			  Conf : in std_logic_vector(1 downto 0));
end GPIO_Interface;

architecture Behavioral of GPIO_Interface is

-- Signals declaration
	signal custom_reg_gpio_write_add : std_logic_vector (3 downto 0);
	signal custom_reg_gpio_write_data : std_logic_vector (15 downto 0);
	signal custom_reg_gpio_read_in_add : std_logic_vector (4 downto 0);
	signal custom_reg_gpio_read_in_data : std_logic_vector (15 downto 0);

	signal Reset 				: std_logic;
	signal Ready 				: Std_logic;		
	signal GPIO_in 			: Std_logic_vector (31 downto 0);	
	signal gpio_out 			: std_logic_vector (31 downto 0);	
	signal GpioDir				: std_logic_vector (31 downto 0);
	signal SetGpioDir			: std_logic;
	signal StartGpio			: std_logic;
	signal SetGpioAck 		: Std_logic;
	signal StartGpioAck 		: Std_logic;
	signal GpioAdcData0 		: Std_logic_vector (11 downto 0);		
	signal GpioAdcData1 		: Std_logic_vector (11 downto 0);		
	signal GpioAdcData2 		: Std_logic_vector (11 downto 0);		
	signal GpioAdcData3 		: Std_logic_vector (11 downto 0);		
	signal GpioAdcData0Valid: Std_logic;		
	signal GpioAdcData1Valid: Std_logic;		
	signal GpioAdcData2Valid: Std_logic;		
	signal GpioAdcData3Valid: Std_logic;	
	
	signal GpioDir_LSBs		: std_logic_vector (15 downto 0);
	signal GpioDir_MSBs		: std_logic_vector (15 downto 0);
	
	signal SlaveGPIOEnable : std_logic;
	signal gpio_slave_data_LSBs : std_logic_vector (15 downto 0);
	signal gpio_slave_data_MSBs : std_logic_vector (15 downto 0);
	
	signal gpio_plg : std_logic_vector (3 downto 0);
	
-- Components declaration

begin

process(clk)
begin
	if(clk'EVENT and clk = '1') then
		custom_reg_gpio_write_add <= custom_reg_gpio_write(19 downto 16);
		custom_reg_gpio_write_data <= custom_reg_gpio_write(15 downto 0);	
		
		-- GPIO outputs interface assignment		
		o_Reset 			<= Reset;
		ov32_Gpio_out 	<= GPIO_out;
		ov32_GpioDir 	<= GpioDir;
		o_SetGpioDir 	<= SetGpioDir;
		o_StartGpio 	<= StartGpio;
		
		-- GPIO inputs interface assignment
		Ready 			<= i_Ready;
		GPIO_in 			<= iv32_Gpio_in;
		GpioAdcData0 	<= iv12_GpioAdcData0;
		GpioAdcData1 	<= iv12_GpioAdcData1;
		GpioAdcData2 	<= iv12_GpioAdcData2;
		GpioAdcData3 	<= iv12_GpioAdcData3;
		GpioAdcData0Valid <= i_GpioAdcData0Valid;
		GpioAdcData1Valid <= i_GpioAdcData1Valid;
		GpioAdcData2Valid <= i_GpioAdcData2Valid;
		GpioAdcData3Valid <= i_GpioAdcData3Valid;
				
		
		--GPIO custom registers write
		case custom_reg_gpio_write_add is
			when "0000" => Reset <= custom_reg_gpio_write_data(0);
			when "0001" => GpioDir_LSBs <= custom_reg_gpio_write_data;
			when "0010" => GpioDir_MSBs <= custom_reg_gpio_write_data;
			when "0011" => SetGpioDir <= custom_reg_gpio_write_data(0);
			when "0100" => StartGpio <= custom_reg_gpio_write_data(0);
			when "0101" => SlaveGPIOEnable <= custom_reg_gpio_write_data(0);
			when "0110" => gpio_slave_data_LSBs <= custom_reg_gpio_write_data;
			when "0111" => gpio_slave_data_MSBs <= custom_reg_gpio_write_data;
			when others => null;
		end case;
		
		case custom_reg_gpio_read_in(4 downto 0) is
			-- GPIO Configuration Settings read-back
			when "00000" => custom_reg_gpio_read_out <= X"000"&"000"&Reset;
			when "00001" => custom_reg_gpio_read_out <= GpioDir(31 downto 16);
			when "00010" => custom_reg_gpio_read_out <= GpioDir(15 downto 0);
			when "00011" => custom_reg_gpio_read_out <= X"000"&"000"&SetGpioDir;
			when "00100" => custom_reg_gpio_read_out <= X"000"&"000"&StartGpio;
			when "00101" => custom_reg_gpio_read_out <= X"000"&"000"&SlaveGPIOEnable;
			when "00110" => custom_reg_gpio_read_out <= gpio_slave_data_LSBs;
			when "00111" => custom_reg_gpio_read_out <= gpio_slave_data_MSBs;
			
			-- GPIO Status read			
			when "10000" => custom_reg_gpio_read_out <= X"000"&"000"&Ready;
			when "10001" => custom_reg_gpio_read_out <= X"000"&"000"&StartGpioAck;
			when "10010" => custom_reg_gpio_read_out <= X"000"&"000"&SetGpioAck;
			when "10011" => custom_reg_gpio_read_out <= Gpio_out(31 downto 16);
			when "10100" => custom_reg_gpio_read_out <= Gpio_out(15 downto 0);
			when "10101" => custom_reg_gpio_read_out <= Gpio_in(31 downto 16);
			when "10110" => custom_reg_gpio_read_out <= Gpio_in(15 downto 0);
			when "10111" => custom_reg_gpio_read_out <= "0000"&GpioAdcData0;
			when "11000" => custom_reg_gpio_read_out <= "0000"&GpioAdcData1;
			when "11001" => custom_reg_gpio_read_out <= "0000"&GpioAdcData2;
			when "11010" => custom_reg_gpio_read_out <= "0000"&GpioAdcData3;
			when "11011" => custom_reg_gpio_read_out <= X"000"&GpioAdcData3Valid&GpioAdcData2Valid&GpioAdcData1Valid&GpioAdcData0Valid;
		
			when others => null;
		end case;
	end if;
end process;

process(clk)
begin
	if(clk'EVENT and clk='1') then

		if(conf = "11") then  
			gpio_plg <= gpio_output_A(4 downto 1); -- Booster Configuration: Two plungers controlled by main cavity (Tuning and Field Flatness)
			
		elsif(conf = "10") then 
			gpio_plg <= gpio_output_A(2)&gpio_output_A(2)&gpio_output_A(1)&gpio_output_A(1); --  Super Conducting Conf: the commands computed by Cavity A are sent to both plunger controllers. 
																														-- Usually control signals of second plunger  will be left disconnected			
		else 
			gpio_plg <= gpio_output_B(2)&gpio_output_A(2)&gpio_output_B(1)&gpio_output_A(1); -- Normal Conducting Conf: plungers are moved independently
		end if;
			

		if(SlaveGPIOEnable = '1') then
			gpio_input_A <= gpio_slave_data_LSBs(11)&gpio_slave_data_LSBs(9)&gpio_slave_data_LSBs(15)&gpio_slave_data_LSBs(14)&gpio_slave_data_LSBs(13)&gpio_slave_data_LSBs(12)&gpio_slave_data_LSBs(10)&gpio_slave_data_LSBs(8)&gpio_slave_data_LSBs(6)&gpio_slave_data_LSBs(4)&gpio_slave_data_LSBs(2)&gpio_slave_data_LSBs(1)&gpio_slave_data_LSBs(0);
			gpio_input_B <= gpio_slave_data_LSBs(10)&gpio_slave_data_LSBs(8)&gpio_slave_data_LSBs(15)&gpio_slave_data_LSBs(14)&gpio_slave_data_LSBs(13)&gpio_slave_data_LSBs(12)&gpio_slave_data_LSBs(11)&gpio_slave_data_LSBs(9)&gpio_slave_data_LSBs(7)&gpio_slave_data_LSBs(5)&gpio_slave_data_LSBs(3)&gpio_slave_data_LSBs(1)&gpio_slave_data_LSBs(0);
			gpio_out <= gpio_slave_data_MSBs&gpio_slave_data_LSBs;
		else
			gpio_input_A <= Gpio_in(11)&Gpio_in(9)&Gpio_in(15)&Gpio_in(14)&Gpio_in(13)&Gpio_in(12)&Gpio_in(10)&Gpio_in(8)&Gpio_in(6)&Gpio_in(4)&Gpio_in(2)&Gpio_in(1)&Gpio_in(0);
			gpio_input_B <= Gpio_in(10)&Gpio_in(8)&Gpio_in(15)&Gpio_in(14)&Gpio_in(13)&Gpio_in(12)&Gpio_in(11)&Gpio_in(9)&Gpio_in(7)&Gpio_in(5)&Gpio_in(3)&Gpio_in(1)&Gpio_in(0);
			gpio_out <= LLRFITckOut&gpio_output_A(9 downto 7)&PinDiodeSw&gpio_plg&gpio_output_B(1)&gpio_output_A(1)&gpio_output_B(0)&gpio_output_A(0)&X"0000";
			GpioDir  <= GpioDir_MSBs & GpioDir_LSBs;
		end if;
	end if;
end process;

end Behavioral;

