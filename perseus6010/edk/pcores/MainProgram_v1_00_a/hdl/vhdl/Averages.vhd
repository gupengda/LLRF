----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:03:28 02/02/2013 
-- Design Name: 
-- Module Name:    Averages - Behavioral 
-- Project Name: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Averages is
    Port ( In1 : in  STD_LOGIC_VECTOR (15 downto 0);
           In2 : in  STD_LOGIC_VECTOR (15 downto 0);
           In3 : in  STD_LOGIC_VECTOR (15 downto 0);
           In4 : in  STD_LOGIC_VECTOR (15 downto 0);
           In5 : in  STD_LOGIC_VECTOR (15 downto 0);
           In6 : in  STD_LOGIC_VECTOR (15 downto 0);
           In7 : in  STD_LOGIC_VECTOR (15 downto 0);
           In8 : in  STD_LOGIC_VECTOR (15 downto 0);
           In9 : in  STD_LOGIC_VECTOR (15 downto 0);
           In10 : in  STD_LOGIC_VECTOR (15 downto 0);
           In11 : in  STD_LOGIC_VECTOR (15 downto 0);
           In12 : in  STD_LOGIC_VECTOR (15 downto 0);
           In13 : in  STD_LOGIC_VECTOR (15 downto 0);
           In14 : in  STD_LOGIC_VECTOR (15 downto 0);
           In15 : in  STD_LOGIC_VECTOR (15 downto 0);
           In16 : in  STD_LOGIC_VECTOR (15 downto 0);
           In17 : in  STD_LOGIC_VECTOR (15 downto 0);
           In18 : in  STD_LOGIC_VECTOR (15 downto 0);
           In19 : in  STD_LOGIC_VECTOR (15 downto 0);
           In20 : in  STD_LOGIC_VECTOR (15 downto 0);
           In21 : in  STD_LOGIC_VECTOR (15 downto 0);
           In22 : in  STD_LOGIC_VECTOR (15 downto 0);
           In23 : in  STD_LOGIC_VECTOR (15 downto 0);
           In24 : in  STD_LOGIC_VECTOR (15 downto 0);
           In25 : in  STD_LOGIC_VECTOR (15 downto 0);
           In26 : in  STD_LOGIC_VECTOR (15 downto 0);
           In27 : in  STD_LOGIC_VECTOR (15 downto 0);
           In28 : in  STD_LOGIC_VECTOR (15 downto 0);
           In29 : in  STD_LOGIC_VECTOR (15 downto 0);
           In30 : in  STD_LOGIC_VECTOR (15 downto 0);
           In31 : in  STD_LOGIC_VECTOR (15 downto 0);
           In32 : in  STD_LOGIC_VECTOR (15 downto 0);
           In33 : in  STD_LOGIC_VECTOR (15 downto 0);
           In34 : in  STD_LOGIC_VECTOR (15 downto 0);
           In35 : in  STD_LOGIC_VECTOR (15 downto 0);
           In36 : in  STD_LOGIC_VECTOR (15 downto 0);
           In37 : in  STD_LOGIC_VECTOR (15 downto 0);
           In38 : in  STD_LOGIC_VECTOR (15 downto 0);
           In39 : in  STD_LOGIC_VECTOR (15 downto 0);
           In40 : in  STD_LOGIC_VECTOR (15 downto 0);
           In41 : in  STD_LOGIC_VECTOR (15 downto 0);
           In42 : in  STD_LOGIC_VECTOR (15 downto 0);
           In43 : in  STD_LOGIC_VECTOR (15 downto 0);
           In44 : in  STD_LOGIC_VECTOR (15 downto 0);
           In45 : in  STD_LOGIC_VECTOR (15 downto 0);
           In46 : in  STD_LOGIC_VECTOR (15 downto 0);
           In47 : in  STD_LOGIC_VECTOR (15 downto 0);
           In48 : in  STD_LOGIC_VECTOR (15 downto 0);
           In49 : in  STD_LOGIC_VECTOR (15 downto 0);
           In50 : in  STD_LOGIC_VECTOR (15 downto 0);
           In51 : in  STD_LOGIC_VECTOR (15 downto 0);
           In52 : in  STD_LOGIC_VECTOR (15 downto 0);
           In53 : in  STD_LOGIC_VECTOR (15 downto 0);
           In54 : in  STD_LOGIC_VECTOR (15 downto 0);
           In55 : in  STD_LOGIC_VECTOR (15 downto 0);
           In56 : in  STD_LOGIC_VECTOR (15 downto 0);
           In57 : in  STD_LOGIC_VECTOR (15 downto 0);
           In58 : in  STD_LOGIC_VECTOR (15 downto 0);
           In59 : in  STD_LOGIC_VECTOR (15 downto 0);
           In60 : in  STD_LOGIC_VECTOR (15 downto 0);
           In61 : in  STD_LOGIC_VECTOR (15 downto 0);
           In62 : in  STD_LOGIC_VECTOR (15 downto 0);
           In63 : in  STD_LOGIC_VECTOR (15 downto 0);
           In64 : in  STD_LOGIC_VECTOR (15 downto 0);
           In65 : in  STD_LOGIC_VECTOR (15 downto 0);
           In66 : in  STD_LOGIC_VECTOR (15 downto 0);
           In67 : in  STD_LOGIC_VECTOR (15 downto 0);
           In68 : in  STD_LOGIC_VECTOR (15 downto 0);
           In69 : in  STD_LOGIC_VECTOR (15 downto 0);
           In70 : in  STD_LOGIC_VECTOR (15 downto 0);
           In71 : in  STD_LOGIC_VECTOR (15 downto 0);
           In72 : in  STD_LOGIC_VECTOR (15 downto 0);
           In73 : in  STD_LOGIC_VECTOR (15 downto 0);
           In74 : in  STD_LOGIC_VECTOR (15 downto 0);
           In75 : in  STD_LOGIC_VECTOR (15 downto 0);
           In76 : in  STD_LOGIC_VECTOR (15 downto 0);
           In77 : in  STD_LOGIC_VECTOR (15 downto 0);
           In78 : in  STD_LOGIC_VECTOR (15 downto 0);
           In79 : in  STD_LOGIC_VECTOR (15 downto 0);
           In80 : in  STD_LOGIC_VECTOR (15 downto 0);
           In81 : in  STD_LOGIC_VECTOR (15 downto 0);
           In82 : in  STD_LOGIC_VECTOR (15 downto 0);
           In83 : in  STD_LOGIC_VECTOR (15 downto 0);
           In84 : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  PulseUp : in std_logic;
			  Conditioning : in std_logic;
           Out1 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out2 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out3 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out4 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out5 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out6 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out7 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out8 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out9 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out10 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out11 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out12 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out13 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out14 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out15 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out16 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out17 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out18 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out19 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out20 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out21 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out22 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out23 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out24 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out25 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out26 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out27 : out  STD_LOGIC_VECTOR (15 downto 0);			  
           Out28 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out29 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out30 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out31 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out32 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out33 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out34 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out35 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out36 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out37 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out38 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out39 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out40 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out41 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out42 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out43 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out44 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out45 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out46 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out47 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out48 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out49 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out50 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out51 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out52 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out53 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out54 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out55 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out56 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out57 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out58 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out59 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out60 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out61 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out62 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out63 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out64 : Out  STD_LOGIC_VECTOR (15 downto 0);
           Out65 : Out  STD_LOGIC_VECTOR (15 downto 0);           
           Out66 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out67 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out68 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out69 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out70 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out71 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out72 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out73 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out74 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out75 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out76 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out77 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out78 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out79 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out80 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out81 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out82 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out83 : out  STD_LOGIC_VECTOR (15 downto 0);
           Out84 : out  STD_LOGIC_VECTOR (15 downto 0);
			  average_update_out : out std_logic
			  );
end Averages;

architecture Behavioral of Averages is

-- signals declaration
signal counteraverage : std_logic_vector (11 downto 0);
signal average_update : std_logic;
signal accum_enable : std_logic;

signal average_update1 : std_logic;
signal average_update2 : std_logic;
signal average_update3 : std_logic;
signal average_update4 : std_logic;
signal average_update5 : std_logic;
signal average_update6 : std_logic;
signal average_update7 : std_logic;
signal average_update8 : std_logic;
signal average_update9 : std_logic;

signal accum_enable1 : std_logic;
signal accum_enable2 : std_logic;
signal accum_enable3 : std_logic;
signal accum_enable4 : std_logic;
signal accum_enable5 : std_logic;
signal accum_enable6 : std_logic;
signal accum_enable7 : std_logic;
signal accum_enable8 : std_logic;
signal accum_enable9 : std_logic;

-- components declaraion
  component Average is
	port (a : in std_logic_vector (15 downto 0);
			clk : in std_logic;
			average_update : in std_logic;
			accum_enable : in std_logic;
			averageout : out std_logic_vector (15 downto 0));
	end component Average; 

begin

process(clk)
begin
	if (clk'EVENT and clk='1') then
	
		average_update1 <= average_update;
		average_update2 <= average_update;
		average_update3 <= average_update;
		average_update4 <= average_update;
		average_update5 <= average_update;
		average_update6 <= average_update;
		average_update7 <= average_update;
		average_update8 <= average_update;
		average_update9 <= average_update;
		average_update_out <= average_update;
		
		accum_enable1 <= accum_enable;
		accum_enable2 <= accum_enable;
		accum_enable3 <= accum_enable;
		accum_enable4 <= accum_enable;
		accum_enable5 <= accum_enable;
		accum_enable6 <= accum_enable;
		accum_enable7 <= accum_enable;
		accum_enable8 <= accum_enable;
		accum_enable9 <= accum_enable;
		
		if(PulseUp = '1' or Conditioning = '0') then
			counteraverage <= counteraverage + 1;
			accum_enable <= '1';
		else
			accum_enable <= '0';
		end if;
		
		if(counteraverage = X"FFF" and accum_enable = '1') then
			average_update <= '1';
		else
			average_update <= '0';
		end if;
	end if;
end process;
	

	
---Diagnostic Signals Means
	

ICav_average : component average
		port map (
			a				=> In1,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out1 );
			

QCav_average : component average
		port map (
			a				=> In2,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out2 );

IFw_average : component average
		port map (
			a				=> In3,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out3 );
			

QFw_average : component average
		port map (
			a				=> In4,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out4 );
			
IControl_average : component average
		port map (
			a				=> In5,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out5 );
			
QControl_average : component average
		port map (
			a				=> In6,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out6 );
			
IControl1_average : component average
		port map (
			a				=> In7,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out7 );
			
QControl1_average : component average
		port map (
			a				=> In8,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out8);
			
			
IControl2_average : component average
		port map (
			a				=> In9,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out9);
			
QControl2_average : component average
		port map (
			a				=> In10,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out10 );
			
			
IControl3_average : component average
		port map (
			a				=> In11,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out11);
			
			
QControl3_average : component average
		port map (
			a				=> In12,
			clk 			=> clk ,
			average_update => average_update1,
			accum_enable => accum_enable1,
			averageout	=> Out12);
			
			
IControl4_average : component average
		port map (
			a				=> In13,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out13);
			
QControl4_average : component average
		port map (
			a				=> In14,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out14 );
			
IError_average : component average
		port map (
			a				=> In15,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out15);
			
QError_average : component average
		port map (
			a				=> In16,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out16 );
			
			
IErrorAccum_average : component average
		port map (
			a				=> In17,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out17 );
			
QErrorAccum_average : component average
		port map (
			a				=> In18,
			clk 			=> clk,
			average_update => average_update2,
			accum_enable => accum_enable4,
			averageout	=> Out18);
			
			
AngCav_average : component average
		port map (
			a				=> In19,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out19 );
			
AngFw_average : component average
		port map (
			a				=> In20,
			clk 			=> clk ,
			average_update => average_update2,
			accum_enable => accum_enable2,
			averageout	=> Out20 );
			
			
IFwIOT1_loop_average : component average
		port map (
			a				=> In21,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out21);
			
QFwIOT1_loop_average : component average
		port map (
			a				=> In22,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out22 );

			
			
IFwIOT2_average : component average
		port map (
			a				=> In23,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out23 );
			
QFwIOT2_average : component average
		port map (
			a				=> In24,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out24);
			
IFwIOT3_loop_average : component average
		port map (
			a				=> In25,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out25);
			
QFwIOT3_loop_average : component average
		port map (
			a				=> In26,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out26);

			
			
IFwIOT4_average : component average
		port map (
			a				=> In27,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out27);
			
QFwIOT4_average : component average
		port map (
			a				=> In28,
			clk 			=> clk ,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout	=> Out28);

			
ICell2_average : component average
	port map(
			a 				=> In29,
			clk			=> clk,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout 	=>	Out29);


			
QCell2_average : component average
	port map(
			a 				=> In30,
			clk			=> clk,
			average_update => average_update3,
			accum_enable => accum_enable3,
			averageout 	=>	Out30);
			
ICell4_average : component average
	port map(
			a 				=> In31,
			clk			=> clk,
			average_update => average_update4,
			accum_enable => accum_enable4,
			averageout 	=>	Out31);


QCell4_average : component average
	port map(
			a 				=> In32,
			clk			=> clk,
			average_update => average_update4,
			accum_enable => accum_enable4,
			averageout 	=>	Out32);

			
AngCavFw_average : component average
	port map(
			a 				=> In33,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out33);

			
AmpCav_average : component average
	port map(
			a 				=> In34,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out34);

			
AmpFw_average : component average
	port map(
			a 				=> In35,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out35);

			
IMO_average : component average
	port map(
			a 				=> In36,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out36);

			
QMO : component average
	port map(
			a 				=> In37,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out37);

			
IRFIn7 : component average
	port map(
			a 				=> In38,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out38);

			
QRFIn7 : component average
	port map(
			a 				=> In39,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out39);

			
IRFIn8 : component average
	port map(
			a 				=> In40,
			clk			=> clk,
			average_update => average_update5,
			accum_enable => accum_enable5,
			averageout 	=>	Out40);

			
QRFIn8 : component average
	port map(
			a 				=> In41,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out41);
			
IRFIn9 : component average
	port map(
			a 				=> In42,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out42);
			
QRFIn9 : component average
	port map(
			a 				=> In43,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out43);
			
IRFIn10 : component average
	port map(
			a 				=> In44,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out44);
			
QRFIn10 : component average
	port map(
			a 				=> In45,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out45);
			
IRFIn11 : component average
	port map(
			a 				=> In46,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out46);
			
QRFIn11 : component average
	port map(
			a 				=> In47,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out47);
			
IRFIn12 : component average
	port map(
			a 				=> In48,
			clk			=> clk,
			average_update => average_update6,
			accum_enable => accum_enable6,
			averageout 	=>	Out48);
			
QRFIn12 : component average
	port map(
			a 				=> In49,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out49);
			
IRFIn13 : component average
	port map(
			a 				=> In50,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out50);
			
QRFIn13 : component average
	port map(
			a 				=> In51,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out51);
			
IRFIn14 : component average
	port map(
			a 				=> In52,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out52);
			
QRFIn14 : component average
	port map(
			a 				=> In53,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out53);
			
IRFIn15 : component average
	port map(
			a 				=> In54,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out54);
			
QRFIn15 : component average
	port map(
			a 				=> In55,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out55);
			
IPolarAmpLoop : component average
	port map(
			a 				=> In56,
			clk			=> clk,
			average_update => average_update7,
			accum_enable => accum_enable7,
			averageout 	=>	Out56);
			
QPolarAmpLoop : component average
	port map(
			a 				=> In57,
			clk			=> clk,
			average_update => average_update8,
			accum_enable => accum_enable8,
			averageout 	=>	Out57);
			
IPolarPhLoop : component average
	port map(
			a 				=> In58,
			clk			=> clk,
			average_update => average_update8,
			accum_enable => accum_enable8,
			averageout 	=>	Out58);
			
qPolarPhLoop : component average
	port map(
			a 				=> In59,
			clk			=> clk,
			average_update => average_update8,
			accum_enable => accum_enable8,
			averageout 	=>	Out59);
			
Amp_AmpLoopInput : component average
	port map(
			a 				=> In60,
			clk			=> clk,
			average_update => average_update8,
			accum_enable => accum_enable8,
			averageout 	=>	Out60);
			
Ph_AmpLoopInput : component average
	port map(
			a 				=> In62,
			clk			=> clk,
			average_update => average_update8,
			accum_enable => accum_enable8,
			averageout 	=>	Out62);
			
Amp_PhLoopInput : component average
	port map(
			a 				=> In63,
			clk			=> clk,
			average_update => average_update8,
			accum_enable => accum_enable8,
			averageout 	=>	Out63);
			
Ph_PhLoopInput : component average
	port map(
			a 				=> In64,
			clk			=> clk,
			average_update => average_update8,
			accum_enable => accum_enable8,
			averageout 	=>	Out64);
			AmpLoop_Error : component average
	port map(
			a 				=> In65,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out65);
			
AmpLoop_ErrorAccum : component average
	port map(
			a 				=> In66,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out66);
			
PhLoop_controlOutput : component average
	port map(
			a 				=> In67,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out67);
			
PhLoop_Error : component average
	port map(
			a 				=> In68,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out68);
			
PhLoop_ErrorAccum : component average
	port map(
			a 				=> In69,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out69);
			
IControl_Polar : component average
	port map(
			a 				=> In70,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out70);
			
QControl_Polar : component average
	port map(
			a 				=> In71,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out71);
			
IControl_Rect : component average
	port map(
			a 				=> In72,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out72);
			
QControl_Rect : component average
	port map(
			a 				=> In73,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out73);
			
IControl_FastPI : component average
	port map(
			a 				=> In74,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out74);
			
QControl_FastPI : component average
	port map(
			a 				=> In75,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out75);
			
IloopInput : component average
	port map(
			a 				=> In76,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out76);
			
QloopInput : component average
	port map(
			a 				=> In77,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out77);
			
IInput_FastPI : component average
	port map(
			a 				=> In78,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out78);
			
QInput_FastPI : component average
	port map(
			a 				=> In79,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out79);

			
PhCorrectionError : component average
	port map(
			a 				=> In80,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out80);

			
PhCorrectionControl : component average
	port map(
			a 				=> In81,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out81);
			
AmpCell2 : component average
	port map(
			a 				=> In82,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out82);

AmpCell4 : component average
	port map(
			a 				=> In83,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out83);
			
FFError : component average
	port map(
			a 				=> In84,
			clk			=> clk,
			average_update => average_update9,
			accum_enable => accum_enable9,
			averageout 	=>	Out84);

end Behavioral;

