----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    09:36:12 08/23/2014 
-- Design Name: 
-- Module Name:    HFLoopInput_Selection - Behavioral 
-- Project Name: 	Max-IV LLRF - Loops
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;

entity FastLoopInput_Selection is
    Port ( LoopInputSel : in  STD_LOGIC_VECTOR (2 downto 0);
           IFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           IFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           QFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           IRef_FastPI : out  STD_LOGIC_VECTOR (15 downto 0);
           QRef_FastPI : out  STD_LOGIC_VECTOR (15 downto 0);
           IInput_FastPI : out  STD_LOGIC_VECTOR (15 downto 0);
           QInput_FastPI : out  STD_LOGIC_VECTOR (15 downto 0));
end FastLoopInput_Selection;

architecture Behavioral of FastLoopInput_Selection is

-- signals declaration

signal ILoopInput : std_logic_vector (15 downto 0);
signal QLoopInput : std_logic_vector (15 downto 0);

signal decimation_counter : std_logic_vector (11 downto 0);

signal wea : std_logic_vector (0 downto 0);

signal Iaccum_32b : std_logic_vector (23 downto 0);
signal Iaccum_32b_out : std_logic_vector (23 downto 0);
signal addr : std_logic_vector (7 downto 0);
signal addra : std_logic_vector (7 downto 0);
signal addrb : std_logic_vector (7 downto 0);
signal ILI : std_logic_vector (15 downto 0);
signal ILI_Filt_32b : std_logic_vector (23 downto 0);
signal ILI_Filt : std_logic_vector (15 downto 0);

signal Qaccum_32b : std_logic_vector (23 downto 0);
signal Qaccum_32b_out : std_logic_vector (23 downto 0);
signal QLI : std_logic_vector (15 downto 0);
signal QLI_Filt_32b : std_logic_vector (23 downto 0);
signal QLI_Filt : std_logic_vector (15 downto 0);



-- components declaration

--
----
--	component mem_16b
--		port (
--		clka: IN std_logic;
--		wea: IN std_logic_VECTOR(0 downto 0);
--		addra: IN std_logic_VECTOR(7 downto 0);
--		dina: IN std_logic_VECTOR(23 downto 0);
--		clkb: IN std_logic;
--		addrb: IN std_logic_VECTOR(7 downto 0);
--		doutb: OUT std_logic_VECTOR(23 downto 0));
--	end component;

--component m16b
--	port (
--	clka: IN std_logic;
--	wea: IN std_logic_VECTOR(0 downto 0);
--	addra: IN std_logic_VECTOR(15 downto 0);
--	dina: IN std_logic_VECTOR(31 downto 0);
--	clkb: IN std_logic;
--	addrb: IN std_logic_VECTOR(15 downto 0);
--	doutb: OUT std_logic_VECTOR(31 downto 0));
--end component;
----
	component mem
		port (
		clka: IN std_logic;
		ena: IN std_logic;
		wea: IN std_logic_VECTOR(0 downto 0);
		addra: IN std_logic_VECTOR(7 downto 0);
		dina: IN std_logic_VECTOR(23 downto 0);
		clkb: IN std_logic;
		addrb: IN std_logic_VECTOR(7 downto 0);
		doutb: OUT std_logic_VECTOR(23 downto 0));
	end component;
	
--		component mem
--		port (
--		clka: IN std_logic;
--		ena: IN std_logic;
--		wea: IN std_logic_VECTOR(0 downto 0);
--		addra: IN std_logic_VECTOR(7 downto 0);
--		dina: IN std_logic_VECTOR(23 downto 0);
--		clkb: IN std_logic;
--		addrb: IN std_logic_VECTOR(7 downto 0);
--		doutb: OUT std_logic_VECTOR(23 downto 0));
--	end component;
--
begin
--
--inst_memI : m16b
--		port map (
--			clka => clk,
--			wea => Iwea,
--			addra => Iaddra,
--			dina => Iaccum_32b,
--			clkb => clk,
--			addrb => Iaddrb,
--			doutb => Iaccum_32b_out);			
--			
--inst_memQ : m16b
--		port map (
--			clka => clk,
--			wea => Qwea,
--			addra => Qaddra,
--			dina => Qaccum_32b,
--			clkb => clk,
--			addrb => Qaddrb,
--			doutb => Qaccum_32b_out);

inst_memI : mem
		port map (
			clka => clk,
			ena => '1',
			wea => wea,
			addra => addra,
			dina => Iaccum_32b,
			clkb => clk,
			addrb => addrb,
			doutb => Iaccum_32b_out);		
			
inst_memQ : mem
		port map (
			clka => clk,
			ena => '1',
			wea => wea,
			addra => addra,
			dina => Qaccum_32b,
			clkb => clk,
			addrb => addrb,
			doutb => Qaccum_32b_out);
			


process(clk)
begin
	if(clk'EVENT and clk = '1') then
		decimation_counter <= decimation_counter + 1;
		ILI <= ILoopInput;
		QLI <= QLoopInput;
		
		if(decimation_counter = X"FFF") then
			wea <= (others => '1');
			addr <= addr + 1;
			addra <= addr;
			addrb <= addr + 2;
			Iaccum_32b <= Iaccum_32b + ILI;
			Qaccum_32b <= Qaccum_32b + QLI;
		else
			wea <= (others => '0');	
			ILI_filt_32b <= Iaccum_32b - Iaccum_32b_out + ILI;
			QLI_filt_32b <= Qaccum_32b - Qaccum_32b_out + QLI;
		end if;
		
		ILI_filt <= ILI_filt_32b(23 downto 8);	
		QLI_filt <= QLI_filt_32b(23 downto 8);		
	end if;
end process;



			

	process(clk)
	begin
	if(clk'EVENT and clk = '1') then
		case LoopInputSel is
			when "001" => 	ILoopInput <= IFwCav;
								QLoopInput <= QFwCav;
			when "010" => 	ILoopInput <= IFwIOT1;
								QLoopInput <= QFwIOT1;
			when "011" => 	ILoopInput <= IFwIOT2;
								QLoopInput <= QFwIOT2;
			when "100" => 	ILoopInput <= IFwIOT3;
								QLoopInput <= QFwIOT3;
			when "101" => 	ILoopInput <= IFwIOT4;
								QLoopInput <= QFwIOT4;
			when others => ILoopInput <= (others => '0');
								QLoopInput <= (others => '0');
		end case;
		
		IRef_FastPI <= ILI_filt;
		QRef_FastPI <= QLI_filt;
		
		IInput_FastPI <= ILoopInput;
		QInput_FastPI <= QLoopInput;
	end if;
	end process;
	
	
--	
--
--inst_memI : mem
--		port map (
--			clka => clk,
--			ena => '1',
--			wea => Iwea,
--			addra => Iaddra,
--			dina => Iaccum_32b,
--			clkb => clk,
--			addrb => Iaddrb,
--			doutb => Iaccum_32b_out);			
--			
--inst_memQ : mem
--		port map (
--			clka => clk,
--			ena => '1',
--			wea => Qwea,
--			addra => Qaddra,
--			dina => Qaccum_32b,
--			clkb => clk,
--			addrb => Qaddrb,
--			doutb => Qaccum_32b_out);
--			
--			
--			
--
--process(clk)
--begin
--	if(clk'EVENT and clk = '1') then
--		ILI <= ILoopInput;
--		QLI <= QLoopInput;
--		Iwea <= (others => '1');	
--		Qwea <= (others => '1');	
--		
--		Iaddr <= Iaddr + 1;
--		Iaddra <= Iaddr;
--		Iaddrb <= Iaddr + 2;
--		Iaccum_32b <= Iaccum_32b + ILI;
--		ILI_filt_32b <= Iaccum_32b - Iaccum_32b_out + ILI;
--
--		ILI_filt <= ILI_filt_32b(23 downto 8);	
--		
--		Qaddr <= Qaddr + 1;
--		Qaddra <= Qaddr;
--		Qaddrb <= Qaddr + 2;
--		Qaccum_32b <= Qaccum_32b + QLI;
--		QLI_filt_32b <= Qaccum_32b - Qaccum_32b_out + QLI;
--
--		QLI_filt <= QLI_filt_32b(23 downto 8);		
--	end if;
--end process;
--



end Behavioral;

