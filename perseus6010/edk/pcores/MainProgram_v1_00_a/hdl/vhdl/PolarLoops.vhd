----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    19:44:06 08/30/2014 
-- Design Name: 
-- Module Name:    PolarLoops - Behavioral 
-- Project Name: Max-IV LLRF - Perseus Loops Board
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PolarLoops is
    Port ( IMuxCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwCav : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT2 : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT3 : in  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT4 : in  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in std_logic;
			  ForwardMin_Amp : in std_logic;
			  ForwardMin_Ph : in std_logic;
			  IPolarAmpLoop : out std_logic_vector (15 downto 0);
			  QPolarAmpLoop : out std_logic_vector (15 downto 0);
			  IPolarPhLoop : out std_logic_vector (15 downto 0);
			  QPolarPhLoop : out std_logic_vector (15 downto 0);
           PolarLoopInputSelection_amp : in  STD_LOGIC_VECTOR (2 downto 0);
           PolarLoopInputSelection_ph : in  STD_LOGIC_VECTOR (2 downto 0);
           Amp_AmpLoopInput : in  STD_LOGIC_VECTOR (15 downto 0);
			  Gain_OL : in std_logic_vector (7 downto 0);
			  IntLimit : in std_logic_vector (15 downto 0);
           Ph_PhLoopInput : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_ControlOutput : out  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_Error : out  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_ErrorAccum : out  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_kp : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpLoop_ki : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRefIn : in  STD_LOGIC_VECTOR (15 downto 0);
           PhRefIn : in  STD_LOGIC_VECTOR (15 downto 0);
           AmpPolarLoopEnable : in  STD_LOGIC;
           PhPolarLoopEnable : in  STD_LOGIC;
           PhLoop_controlOutput : out  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_Error : out  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_ErrorAccum : out  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_kp : in  STD_LOGIC_VECTOR (15 downto 0);
           PhLoop_ki : in  STD_LOGIC_VECTOR (15 downto 0));
end PolarLoops;

architecture Behavioral of PolarLoops is

-- signals declaration

signal IntLimitLatch_CordicGain_32b : std_logic_vector (31 downto 0);
signal IntLimitLatch_CordicGain : std_logic_vector (15 downto 0);
signal IntLimitLatch : std_logic_vector (15 downto 0);


-- components declaration

	component PI_Polar IS
		port ( Input : in std_logic_vector (15 downto 0);
				 LoopEnable : in std_logic;
				 Gain_OL : in std_logic_vector (7 downto 0);
				 Ref : in std_logic_vector (15 downto 0);
				 Kp : in std_logic_vector(15 downto 0);
				 Ki : in std_logic_vector(15 downto 0);
				 Error : out std_logic_vector(15 downto 0);
				 ErrorAccumOut : out std_logic_vector (15 downto 0);
				 IntLimit : in std_logic_vector (15 downto 0);
				 Control : out std_logic_vector (15 downto 0);
				 clk : in std_logic;
				 ForwardMin : in std_logic);			 
	end component PI_Polar;

	component FastPI_Polar is
	port ( Input : in std_logic_vector (15 downto 0);
			 LoopEnable : in std_logic;
			 Ref : in std_logic_vector (15 downto 0);
			 Kp : in std_logic_vector(15 downto 0);
			 Ki : in std_logic_vector(15 downto 0);
			 Error : out std_logic_vector(15 downto 0);
			 ErrorAccumOut : out std_logic_vector (15 downto 0);
			 IntLimit : in std_logic_vector (15 downto 0);
			 Control : out std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 ForwardMin : in std_logic);			 
	end component FastPI_Polar;

begin

inst_AmpLoop : component PI_Polar
	port map ( 
			 Input 				  => Amp_AmpLoopInput, 		
			 LoopEnable         => AmpPolarLoopEnable, 
			 Gain_OL 	        => Gain_OL, 	
			 Ref                => AmpRefIn,
			 Kp                 => AmpLoop_kp, 
			 Ki                 => AmpLoop_ki, 
			 Error              => AmpLoop_Error, 
			 ErrorAccumOut      => AmpLoop_ErrorAccum, 
			 IntLimit           => IntLimitLatch_CordicGain,
			 Control            => AmpLoop_ControlOutput, 
			 clk                => clk, 
			 ForwardMin         => ForwardMin_Amp );

inst_PhLoop : component FastPI_Polar
	port map ( 
			 Input 				=>  Ph_PhLoopInput, 		
			 LoopEnable     	=>  PhPolarLoopEnable, 
			 Ref 		    		=>  PhRefIn, 		
			 Kp 		    		=>  PhLoop_kp, 		
			 Ki 		    		=>  PhLoop_ki, 		
			 Error 		    	=>  PhLoop_Error, 		
			 ErrorAccumOut  	=>  PhLoop_ErrorAccum, 
			 IntLimit 	    	=>  X"7FFF", 	
			 Control 	    	=>  PhLoop_ControlOutput, 	
			 clk 		    		=>  clk, 		
			 ForwardMin     	=>  ForwardMin_Ph);
			 
			 
process(clk)
begin
if(clk'EVENT and clk = '1') then
	case PolarLoopInputSelection_Amp is
		when "000" => IPolarAmpLoop <= IMuxCav;
						  QPolarAmpLoop <= QMuxCav;
		when "001" => IPolarAmpLoop <= IMuxFwCav;
						  QPolarAmpLoop <= QMuxFwCav;
		when "010" => IPolarAmpLoop <= IMuxFwIOT1;
						  QPolarAmpLoop <= QMuxFwIOT1;
		when "011" => IPolarAmpLoop <= IMuxFwIOT2;
						  QPolarAmpLoop <= QMuxFwIOT2;
		when "100" => IPolarAmpLoop <= IMuxFwIOT3;
						  QPolarAmpLoop <= QMuxFwIOT3;
		when "101" => IPolarAmpLoop <= IMuxFwIOT4;
						  QPolarAmpLoop <= QMuxFwIOT4;
		when "110" => IPolarAmpLoop <= IMuxCav;
						  QPolarAmpLoop <= QMuxCav;
		when "111" => IPolarAmpLoop <= IMuxCav;
						  QPolarAmpLoop <= QMuxCav;
		when others => null;
	end case;
	
	
	case PolarLoopInputSelection_Ph is
		when "000" => IPolarPhLoop <= IMuxCav;
						  QPolarPhLoop <= QMuxCav;
		when "001" => IPolarPhLoop <= IMuxFwCav;
						  QPolarPhLoop <= QMuxFwCav;
		when "010" => IPolarPhLoop <= IMuxFwIOT1;
						  QPolarPhLoop <= QMuxFwIOT1;
		when "011" => IPolarPhLoop <= IMuxFwIOT2;
						  QPolarPhLoop <= QMuxFwIOT2;
		when "100" => IPolarPhLoop <= IMuxFwIOT3;
						  QPolarPhLoop <= QMuxFwIOT3;
		when "101" => IPolarPhLoop <= IMuxFwIOT4;
						  QPolarPhLoop <= QMuxFwIOT4;
		when "110" => IPolarPhLoop <= IMuxCav;
						  QPolarPhLoop <= QMuxCav;
		when "111" => IPolarPhLoop <= IMuxCav;
						  QPolarPhLoop <= QMuxCav;
		when others => null;
	end case;

end if;
end process;


process(clk)
begin
	if(clk'EVENT and clk='1') then
		IntLimitLatch <= IntLimit;
		IntLimitLatch_CordicGain_32b <= IntLimitLatch * X"4DB8";
		IntLimitLatch_CordicGain <= IntLimitLatch_CordicGain_32b(30 downto 15);
	end if;
end process;

end Behavioral;

