----------------------------------------------------------------------------------
-- Company: CELLS
-- Engineer: Angela Salom
-- 
-- Create Date:    12:06:28 10/02/2011 
-- Design Name: 
-- Module Name:    FIM - Behavioral 
-- Project Name: 	 DLS LLRF 
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

entity FIM is
    Port ( clk 					: in  STD_LOGIC;
			  ResetFIM 				: in std_logic;
           AmpRvIOT1 			: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvIOT2				: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvIOT3 			: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvIOT4 			: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRvCav 				: in  STD_LOGIC_VECTOR (15 downto 0);
			  Manual_itck_in		: in 	std_logic;
			  ExtLLRF3ITCK_In		: in 	std_logic;
           gpio_in_itck 		: in  STD_LOGIC_VECTOR (12 downto 0); -- PLC interlock and external LLRF interlocks 
           RvIOT1Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvIOT2Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvIOT3Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvIOT4Limit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           RvCavLimit 			: in  STD_LOGIC_VECTOR (15 downto 0);
           Conf 					: in  STD_LOGIC_VECTOR (1 downto 0);
			  DisableITCK_RvIOT1 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvIOT2 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvIOT3 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvIOT4 		: in std_logic_vector (5 downto 0);
			  DisableITCK_RvCav			: in std_logic_vector (5 downto 0);
			  DisableITCK_Manual			: in std_logic_vector (5 downto 0);
			  DisableITCK_PLC				: in std_logic_vector (5 downto 0);
			  DisableITCK_LLRF1			: in std_logic_vector (5 downto 0);
			  DisableITCK_LLRF2			: in std_logic_vector (5 downto 0);
			  DisableITCK_LLRF3			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwUp1			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwDw1			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwUp2			: in std_logic_vector (5 downto 0);
			  DisableITCK_ESwDw2			: in std_logic_vector (5 downto 0);
			  EndSwitchNO			: in std_logic;
           gpio_out_itck 		: out  STD_LOGIC_VECTOR (4 downto 0);
			  ITCK_Detected		: out std_logic_vector (13 downto 0);
			  InterlocksDisplay0 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay1 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay2 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay3 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay4 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay5 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay6 : out std_logic_vector (13 downto 0);
			  InterlocksDisplay7 : out std_logic_vector (13 downto 0);
			  timestamp1_out 		: out std_logic_vector (15 downto 0);
			  timestamp2_out 		: out std_logic_vector (15 downto 0);
			  timestamp3_out 		: out std_logic_vector (15 downto 0);
			  timestamp4_out 		: out std_logic_vector (15 downto 0);
			  timestamp5_out 		: out std_logic_vector (15 downto 0);
			  timestamp6_out 		: out std_logic_vector (15 downto 0);
			  timestamp7_out 		: out std_logic_vector (15 downto 0);
			  delay_interlocks	: in std_logic_vector (15 downto 0)
			  );
end FIM;

architecture Behavioral of FIM is

-- Signals Declaration
signal timestamp1 : std_logic_vector (15 downto 0);
signal timestamp2 : std_logic_vector (15 downto 0);
signal timestamp3 : std_logic_vector (15 downto 0);
signal timestamp4 : std_logic_vector (15 downto 0);
signal timestamp5 : std_logic_vector (15 downto 0);
signal timestamp6 : std_logic_vector (15 downto 0);
signal timestamp7 : std_logic_vector (15 downto 0);
signal ITCK_Out_Signal : std_logic_vector (13 downto 0);
signal n : std_logic_vector (2 downto 0);

signal RvIOT1ITCK_In : std_logic;
signal RvIOT2ITCK_In : std_logic;
signal RvIOT3ITCK_In : std_logic;
signal RvIOT4ITCK_In : std_logic;
signal RvCavITCK_In : std_logic;
signal ExtLLRF1ITCK_In : std_logic;
signal ExtLLRF2ITCK_In : std_logic;
signal ExtLLRF3ITCK_in_sig : std_logic;
signal ESwUp1ITCK_In : std_logic;
signal ESwDw1ITCK_In : std_logic;
signal ESwUp2ITCK_In : std_logic;
signal ESwDw2ITCK_In : std_logic;
signal PLCITCK_In : std_logic;


signal ESwUp1ITCK : std_logic;
signal ESwDw1ITCK : std_logic;
signal ESwUp2ITCK : std_logic;
signal ESwDw2ITCK : std_logic;

signal counter_RvIOT1 : std_logic_vector (15 downto 0);
signal counter_RvIOT2 : std_logic_vector (15 downto 0);
signal counter_RvIOT3 : std_logic_vector (15 downto 0);
signal counter_RvIOT4 : std_logic_vector (15 downto 0);
signal counter_RvCav : std_logic_vector (15 downto 0);
signal counter_ExtLLRF1 : std_logic_vector (15 downto 0);
signal counter_ExtLLRF2 : std_logic_vector (15 downto 0);
signal counter_ExtLLRF3 : std_logic_vector (15 downto 0);
signal counter_PLCItckIn : std_logic_vector (15 downto 0);
signal counter_ESwUp1 : std_logic_vector (15 downto 0);
signal counter_ESwDw1 : std_logic_vector (15 downto 0);
signal counter_ESwUp2 : std_logic_vector (15 downto 0);
signal counter_ESwDw2 : std_logic_vector (15 downto 0);

signal ITCK_Out_SetLLRF2STBY : std_logic;
signal ITCK_Out2OtherLLRF : std_logic;
signal ITCK_Out_PinSw : std_logic;
signal ITCK_Out_FDL : std_logic;
signal ITCK_Out_PLC : std_logic;
signal ITCK_Out_Diag : std_logic_vector (13 downto 0);
signal ITCK_Out_Diag_latch : std_logic_vector (13 downto 0);
signal ITCK_Out_Diag_delay : std_logic_vector (13 downto 0);


signal RvIOT1ITCK_Out : std_logic_vector (6 downto 0);
signal RvIOT2ITCK_Out : std_logic_vector (6 downto 0);
signal RvIOT3ITCK_Out : std_logic_vector (6 downto 0);
signal RvIOT4ITCK_Out : std_logic_vector (6 downto 0);
signal RvCavITCK_Out : std_logic_vector (6 downto 0);
signal ExtLLRF1ITCK_Out : std_logic_vector (6 downto 0);
signal ExtLLRF2ITCK_Out : std_logic_vector (6 downto 0);
signal ExtLLRF3ITCK_Out : std_logic_vector (6 downto 0);
signal ManualITCK_Out : std_logic_vector (6 downto 0);
signal PLCITCK_Out : std_logic_vector (6 downto 0);
signal ESwUp1ITCK_Out : std_logic_vector (6 downto 0);
signal ESwDw1ITCK_Out : std_logic_vector (6 downto 0);
signal ESwUp2ITCK_Out : std_logic_vector (6 downto 0);
signal ESwDw2ITCK_Out : std_logic_vector (6 downto 0);



-- Components

component ITCK is
    Port ( ITCK_In : in  STD_LOGIC;
			  ResetFIM : in  STD_LOGIC;
           Disable_ITCK : in  STD_LOGIC_VECTOR (5 downto 0);
           ITCK_Out : out  STD_LOGIC_VECTOR (6 downto 0);
           clk : in  STD_LOGIC);
end component ITCK;



begin

I_RvIOT1 : ITCK
	port map (ITCK_In => RvIOT1ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_RvIOT1,
				  ITCK_Out => RvIOT1ITCK_Out,
				  clk => clk);

I_RvIOT2 : ITCK
	port map (ITCK_In => RvIOT2ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_RvIOT2,
				  ITCK_Out => RvIOT2ITCK_Out,
				  clk => clk);

I_RvIOT3 : ITCK
	port map (ITCK_In => RvIOT3ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_RvIOT3,
				  ITCK_Out => RvIOT3ITCK_Out,
				  clk => clk);

I_RvIOT4 : ITCK
	port map (ITCK_In => RvIOT4ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_RvIOT4,
				  ITCK_Out => RvIOT4ITCK_Out,
				  clk => clk);

I_RvCav : ITCK
	port map (ITCK_In => RvCavITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_RvCav,
				  ITCK_Out => RvCavITCK_Out,
				  clk => clk);


I_Manual : ITCK
	port map (ITCK_In => Manual_ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_Manual,
				  ITCK_Out => ManualITCK_Out,
				  clk => clk);
				  
I_PLC : ITCK 
	port map (ITCK_In => PLCITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_PLC,
				  ITCK_Out => PLCITCK_Out,
				  clk => clk);
				  
I_ExtLLRF1 : ITCK 
	port map (ITCK_In => ExtLLRF1Itck_in,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_LLRF1,
				  ITCK_Out => ExtLLRF1Itck_out,
				  clk => clk);
				  
I_ExtLLRF2 : ITCK
	port map (ITCK_In => ExtLLRF2Itck_in,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_LLRF2,
				  ITCK_Out => ExtLLRF2Itck_out,
				  clk => clk);
				  
I_ExtLLRF3 : ITCK --- Interlock to be considered only in case of normal conducting cavities, where two cavities will be controlled by one LLRF. Both cavities will be informed if its partner has detected and interlock. 
	port map (ITCK_In => ExtLLRF3Itck_in_sig,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_LLRF3,
				  ITCK_Out => ExtLLRF3Itck_out,
				  clk => clk);

I_ESwUp1 : ITCK
	port map (ITCK_In => ESwUp1ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_ESwUp1,
				  ITCK_Out => ESwUp1ITCK_Out,
				  clk => clk);

I_ESwDw1 : ITCK
	port map (ITCK_In => ESwDw1ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_ESwDw1,
				  ITCK_Out => ESwDw1ITCK_Out,
				  clk => clk);
I_ESwUp2 : ITCK
	port map (ITCK_In => ESwUp2ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_ESwUp2,
				  ITCK_Out => ESwUp2ITCK_Out,
				  clk => clk);

I_ESwDw2 : ITCK
	port map (ITCK_In => ESwDw2ITCK_In,
				  ResetFIM => ResetFIM,
				  Disable_ITCK => DisableITCK_ESwDw2,
				  ITCK_Out => ESwDw2ITCK_Out,
				  clk => clk);

Interlocks_detection : process (clk)
begin
if (clk'EVENT and clk = '1') then

	if(AmpRvIOT1 > RvIOT1Limit) then
		if(counter_RvIOT1 < delay_interlocks) then
			counter_RvIOT1 <= counter_RvIOT1 + 1;
		else
			RvIOT1ITCK_In <= '1';
		end if;
	else 
		RvIOT1ITCK_In <= '0';
		counter_RvIOT1 <= (others => '0');
	end if;
	
	if(AmpRvIOT2 > RvIOT2Limit) then
		if(counter_RvIOT2 < delay_interlocks) then
			counter_RvIOT2 <= counter_RvIOT2 + 1;
		else
			RvIOT2ITCK_In <= '1';
		end if;
	else 
		RvIOT2ITCK_In <= '0';
		counter_RvIOT2 <= (others => '0');
	end if;		
	
	if(AmpRvIOT3 > RvIOT3Limit) then
		if(counter_RvIOT3 < delay_interlocks) then
			counter_RvIOT3 <= counter_RvIOT3 + 1;
		else	
			RvIOT3ITCK_In <= '1';
		end if;			
	else 
		RvIOT3ITCK_In <= '0';
		counter_RvIOT2 <= (others => '0');
	end if;				
	
	if(AmpRvIOT4 > RvIOT4Limit) then
		if(counter_RvIOT4 < delay_interlocks) then
			counter_RvIOT4 <= counter_RvIOT4 + 1;
		else	
			RvIOT4ITCK_In <= '1';
		end if;
	else 
		RvIOT4ITCK_In <= '0';
		counter_RvIOT4 <= (others => '0');
	end if;		

	
	if(AmpRvCav > RvCavLimit) then
		if(counter_RvCav < delay_interlocks) then
			counter_RvCav <= counter_RvCav + 1;
		else
			RvCavITCK_In <= '1';
		end if;
	else 
		RvCavITCK_In <= '0';
		counter_RvCav <= (others => '0');
	end if;
	
	if(gpio_in_ITCK(0) = '1') then
		if(counter_ExtLLRF1 < delay_interlocks) then
			counter_ExtLLRF1 <= counter_ExtLLRF1 + 1;
		else
			ExtLLRF1ITCK_In <= gpio_in_ITCK(0);
		end if;
	else
		ExtLLRF1ITCK_In <= '0';
		counter_ExtLLRF1 <= (others => '0');
	end if;
	
	if(gpio_in_ITCK(1) = '1') then
		if(counter_ExtLLRF2 < delay_interlocks) then
			counter_ExtLLRF2 <= counter_ExtLLRF2 + 1;
		else
			ExtLLRF2ITCK_In <= gpio_in_ITCK(1);
		end if;
	else
		ExtLLRF2ITCK_In <= '0';
		counter_ExtLLRF2 <= (others => '0');
	end if;	
	
	if(Conf(0) = '0') then --- interlock to be detected by second cavity in case of NC cavities. Not used in SC nor Bo case				
		if(ExtLLRF3ITCK_In = '1') then 
			if(counter_ExtLLRF3 < delay_interlocks) then
					counter_ExtLLRF3 <= counter_ExtLLRF3 + 1;
				else
					ExtLLRF3ITCK_In_sig <= ExtLLRF3ITCK_In;
				end if;
			else
				ExtLLRF3ITCK_In_sig <= '0';
				counter_ExtLLRF3 <= (others => '0');
			end if;
	else
		ExtLLRF3ITCK_In_sig <= '0';
	end if;
		
	
	if(gpio_in_ITCK(2) = '1') then
		if(counter_PLCItckIn < delay_interlocks) then
			counter_PLCItckIn <= counter_PLCItckIn + 1;
		else
			PLCITCK_In <= gpio_in_ITCK(2);
		end if;
	else
		PLCITCK_In <= '0';
		counter_PLCItckIn <= (others => '0');
	end if;	
			
		
	if(EndSwitchNO = '0') then 						-- if end switches are connected to Normally open contacts, 
		ESwUp1ITCK <= gpio_in_ITCK(5);			-- the interlock will be activated by a high signal
		ESwDw1ITCK <= gpio_in_ITCK(6);
		if (Conf = "11") then -- For booster cavity configuration, there will be two plungers and two sets of end switches
			ESwUp2ITCK <= gpio_in_ITCK(11);	
			ESwDw2ITCK <= gpio_in_ITCK(12);
		else						-- in NC and SC Cavities case, the second pair of end switches interlocks will not be considered
			ESwUp2ITCK <= '0';	
			ESwDw2ITCK <= '0';		
		end if;
	else
		ESwUp1ITCK <= not(gpio_in_ITCK(5));		-- if end switches are connected to Normally close contacts,			
		ESwDw1ITCK <= not(gpio_in_ITCK(6));  	-- the interlock will get activated by low signal
		if (Conf = "11") then -- For booster cavity configuration, there will be two plungers and two sets of end switches
			ESwUp2ITCK <= not(gpio_in_ITCK(11));	
			ESwDw2ITCK <= not(gpio_in_ITCK(12));
		else						-- in NC and SC Cavities case, the second pair of end switches interlocks will not be considered
			ESwUp2ITCK <= '0';	
			ESwDw2ITCK <= '0';		
		end if; 
	end if;

	if(ESwUp1ITCK = '1') then
		if (counter_ESwUp1 < X"7F00") then
			counter_ESwUp1 <= counter_ESwUp1 + 1;
		else
			ESwUp1ITCK_In <= '1';
		end if;
	else
		ESwUp1ITCK_In <= '0';
		counter_ESwUp1 <= (others => '0');
	end if;
	
	if(ESwDw1ITCK = '1') then
		if (counter_ESwDw1 < X"7F00") then
			counter_ESwDw1 <= counter_ESwDw1 + 1;
		else
			ESwDw1ITCK_In <= '1';
		end if;
	else
		ESwDw1ITCK_In <= '0';
		counter_ESwDw1 <= (others => '0');
	end if;

	if(ESwUp2ITCK = '1') then
		if (counter_ESwUp2 < X"7F00") then
			counter_ESwUp2 <= counter_ESwUp2 + 1;
		else
			ESwUp2ITCK_In <= '1';
		end if;
	else
		ESwUp2ITCK_In <= '0';
		counter_ESwUp2 <= (others => '0');
	end if;
	
	if(ESwDw2ITCK = '1') then
		if (counter_ESwDw2 < X"7F00") then
			counter_ESwDw2 <= counter_ESwDw2 + 1;
		else
			ESwDw2ITCK_In <= '1';
		end if;
	else
		ESwDw2ITCK_In <= '0';
		counter_ESwDw2 <= (others => '0');
	end if;
	
end if;
end process;

process(clk)
begin
	if(clk'EVENT and clk = '1') then
		timestamp1_out <= timestamp1;
		timestamp2_out <= timestamp2;
		timestamp3_out <= timestamp3;
		timestamp4_out <= timestamp4;
		timestamp5_out <= timestamp5;
		timestamp6_out <= timestamp6;
		timestamp7_out <= timestamp7;	
		
	if(ResetFIM = '1') then	
		ITCK_Out_SetLLRF2STBY 	<= '0';
		ITCK_Out_PinSw 			<= '0';
		ITCK_Out_FDL 				<= '0';
		ITCK_Out_PLC 				<= '0';
		ITCK_Out2OtherLLRF 		<= '0';
		ITCK_Out_Diag 			<= (others => '0');	
		ITCK_Out_Diag_latch 	<= (others => '0');	
		InterlocksDisplay0 <= (others => '0');
		InterlocksDisplay1 <= (others => '0');
		InterlocksDisplay2 <= (others => '0');
		InterlocksDisplay3 <= (others => '0');
		InterlocksDisplay4 <= (others => '0');
		InterlocksDisplay5 <= (others => '0');
		InterlocksDisplay6 <= (others => '0');
		InterlocksDisplay7 <= (others => '0');
		timestamp1 <= (others => '0');
		timestamp2 <= (others => '0');
		timestamp3 <= (others => '0');
		timestamp4 <= (others => '0');
		timestamp5 <= (others => '0');
		timestamp6 <= (others => '0');
		timestamp7 <= (others => '0');		
	else
		ITCK_Out_SetLLRF2STBY 		<= ESwDw2ITCK_out(0) or ESwUp2ITCK_out(0) or ESwDw1ITCK_out(0) or ESwUp1ITCK_out(0) or PLCITCK_Out(0) or ManualITCK_out(0) or ExtLLRF3ITCK_out(0) or ExtLLRF2ITCK_out(0) or ExtLLRF1ITCK_out(0) or RvCavITCK_out(0) or RvIOT4ITCK_out(0) or RvIOT3ITCK_out(0) or RvIOT2ITCK_out(0) or RvIOT1ITCK_out(0);
		ITCK_Out_PinSw 				<= ESwDw2ITCK_out(1) or ESwUp2ITCK_out(1) or ESwDw1ITCK_out(1) or ESwUp1ITCK_out(1) or PLCITCK_Out(1) or ManualITCK_out(1) or ExtLLRF3ITCK_out(1) or ExtLLRF2ITCK_out(1) or ExtLLRF1ITCK_out(1) or RvCavITCK_out(1) or RvIOT4ITCK_out(1) or RvIOT3ITCK_out(1) or RvIOT2ITCK_out(1) or RvIOT1ITCK_out(1);
		ITCK_Out_FDL 					<= ESwDw2ITCK_out(2) or ESwUp2ITCK_out(2) or ESwDw1ITCK_out(2) or ESwUp1ITCK_out(2) or PLCITCK_Out(2) or ManualITCK_out(2) or ExtLLRF3ITCK_out(2) or ExtLLRF2ITCK_out(2) or ExtLLRF1ITCK_out(2) or RvCavITCK_out(2) or RvIOT4ITCK_out(2) or RvIOT3ITCK_out(2) or RvIOT2ITCK_out(2) or RvIOT1ITCK_out(2);
		-- the LLRF interlock ouput for PLC will NOT get triggered by interlocks coming from the PLC to avoid deadlocks
		ITCK_Out_PLC 					<= ESwDw2ITCK_out(3) or ESwUp2ITCK_out(3) or ESwDw1ITCK_out(3) or ESwUp1ITCK_out(3) or 						ManualITCK_out(3) or ExtLLRF3ITCK_out(3) or ExtLLRF2ITCK_out(3) or ExtLLRF1ITCK_out(3) or RvCavITCK_out(3) or RvIOT4ITCK_out(3) or RvIOT3ITCK_out(3) or RvIOT2ITCK_out(3) or RvIOT1ITCK_out(3);
		ITCK_Out2OtherLLRF 			<= ESwDw2ITCK_out(4) or ESwUp2ITCK_out(4) or ESwDw1ITCK_out(4) or ESwUp1ITCK_out(4) or PLCITCK_Out(4) or ManualITCK_out(4) or ExtLLRF3ITCK_out(4) or ExtLLRF2ITCK_out(4) or ExtLLRF1ITCK_out(4) or RvCavITCK_out(4) or RvIOT4ITCK_out(4) or RvIOT3ITCK_out(4) or RvIOT2ITCK_out(4) or RvIOT1ITCK_out(4);		
								
		ITCK_Out_Diag 					<=	ESwDw2ITCK_out(5)&ESwUp2ITCK_out(5)&ESwDw1ITCK_out(5)&ESwUp1ITCK_out(5)&PLCITCK_Out(5)&ManualITCK_out(5)&ExtLLRF3ITCK_out(5)&ExtLLRF2ITCK_out(5)&ExtLLRF1ITCK_out(5)&RvCavITCK_out(5)&RvIOT4ITCK_out(5)&RvIOT3ITCK_out(5)&RvIOT2ITCK_out(5)&RvIOT1ITCK_out(5);		
		ITCK_Out_Diag_latch			<=	ESwDw2ITCK_out(6)&ESwUp2ITCK_out(6)&ESwDw1ITCK_out(6)&ESwUp1ITCK_out(6)&PLCITCK_Out(6)&ManualITCK_out(6)&ExtLLRF3ITCK_out(6)&ExtLLRF2ITCK_out(6)&ExtLLRF1ITCK_out(6)&RvCavITCK_out(6)&RvIOT4ITCK_out(6)&RvIOT3ITCK_out(6)&RvIOT2ITCK_out(6)&RvIOT1ITCK_out(6);		
	end if;

	
		gpio_out_itck <= ITCK_Out2OtherLLRF & ITCK_Out_PLC & ITCK_Out_FDL & ITCK_Out_PinSw & ITCK_Out_SetLLRF2STBY;
		ITCK_Out_Diag_Delay <= ITCK_Out_Diag; -- all interlocks at that moment. If one interlock is not present anymore, the correspondant bit will not be activated. 
		ITCK_Detected <= ITCK_Out_Diag_latch; -- all interlocks that have happened. Even if the interlock is no longer present, they will get latched in this register
				
		
		if(ResetFIM = '1') then
			n <= "000";
		elsif(ITCK_Out_Diag /= ITCK_Out_Diag_Delay) then			
			if(n < "111") then 
				n <= n + 1;
			end if;
		end if;
		
		
		case n is
			when "000" => timestamp1 <= (others => '0');
							  timestamp2 <= (others => '0');
							  timestamp3 <= (others => '0');
							  timestamp4 <= (others => '0');
							  timestamp5 <= (others => '0');
							  timestamp6 <= (others => '0');
							  timestamp7 <= (others => '0');
							  InterlocksDisplay0 <= ITCK_Out_Diag;
							  
			when "001" => InterlocksDisplay1 <= ITCK_Out_Diag;
							  if(timestamp1 < X"FFFF") then timestamp1 <= timestamp1 + 1;
							  end if;
							  
			when "010" => InterlocksDisplay2 <= ITCK_Out_Diag;
							  if(timestamp2 < X"FFFF") then timestamp2 <= timestamp2 + 1;
							  end if;
							  
			when "011" => InterlocksDisplay3 <= ITCK_Out_Diag;
							  if(timestamp3 < X"FFFF") then timestamp3 <= timestamp3 + 1;
							  end if;
							  
			when "100" => InterlocksDisplay4 <= ITCK_Out_Diag;
							  if(timestamp4 < X"FFFF") then timestamp4 <= timestamp4 + 1;
							  end if;
							  
			when "101" => InterlocksDisplay5 <= ITCK_Out_Diag;
							  if(timestamp5 < X"FFFF") then timestamp5 <= timestamp5 + 1;
							  end if;
							  
			when "110" => InterlocksDisplay6 <= ITCK_Out_Diag;
							  if(timestamp6 < X"FFFF") then timestamp6 <= timestamp6 + 1;
							  end if;
							  
			when "111" => InterlocksDisplay7 <= ITCK_Out_Diag;
							  if(timestamp7 < X"FFFF") then timestamp7 <= timestamp7 + 1;
							  end if;
							  
			when others => null;
		end case;
	end if;
	end process;
	
end Behavioral;

