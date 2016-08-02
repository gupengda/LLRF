----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:07 10/24/2012 
-- Design Name: 
-- Module Name:    rampTestIn - Behavioral 
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
-- simple ramp test
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rampTestIn is
	 generic(
				dataWidth : integer := 16
	 );
    Port ( 
	 			rampIn 	  : in  std_logic_vector( dataWidth -1 downto 0 );
				valid		  : in  std_logic;
				start		  : in  std_logic;
				errorCnt	  : out std_logic_vector( 31 downto 0 );
				errorMask  : out std_logic_vector( dataWidth -1 downto 0 );
				dataCountDiv1024 : out std_logic_vector( 31 downto 0);
				lock		  : out std_logic;
				reset 	  : in  std_logic;
				clk		  : in  std_logic
			);
end rampTestIn;

architecture Behavioral of rampTestIn is

	signal lastValue     : unsigned( dataWidth -1 downto 0 );
	signal sErrorCount   : unsigned(31 downto 0);
	
	signal sErrorMask		: std_logic_vector( dataWidth -1 downto 0 );
		
	type stateType is (idle, locked);
	
	signal state : stateType := idle;
	
	signal sDataCountDiv1024 : unsigned(31 downto 0);
	signal sDataCountPrescale : unsigned(9 downto 0);

begin


	syncSmProcess : process(clk,reset)
	begin 
		if reset = '1' then
			state 		<= idle;
			lastValue	<= ( others => '0' );
			sErrorCount	<= ( others => '0');
			sErrorMask	<= ( others => '0');
      sDataCountDiv1024 <= ( others => '0');
      sDataCountPrescale <= ( others => '0');
			
		elsif rising_edge(clk) then 
			lastValue <= 	unsigned(rampIn); 
			
			if start = '1' then 
				case state is
					when idle =>
						sErrorCount	<= ( others => '0');
						sErrorMask	<= ( others => '0');
						if unsigned(rampIn) = (lastValue + 1) then
							state <= locked;
						else
							state <= idle;
						end if;
						
					when locked => 
										
						if unsigned(rampIn) = (lastValue + 1) then
							sDataCountPrescale <= sDataCountPrescale +1;
							if sDataCountPrescale = 1023 then 
								sDataCountDiv1024 <= sDataCountDiv1024 + 1;
							end if;
						else
							sErrorCount <= sErrorCount + 1;
							sErrorMask <= sErrorMask or ( rampIn xor std_logic_vector(lastValue + 1));
						end if;
						
						state <= locked;
				end case;
			end if;	
			
		end if;
	end process;

errorCnt 			<= std_logic_vector(sErrorCount);
dataCountDiv1024	<= std_logic_vector(sDataCountDiv1024);
		
	errorCheckProcess : process(clk)
		begin 
			

			if rising_edge(clk) then
			
				if valid = '1' then
					if  unsigned(rampIn) = (lastValue + 1) then
						lock <= '1'; 
					else
						lock <= '0'; 
					end if;
				end if;
			
			end if;
		
		end process;





end Behavioral;

