---File Demux.vhd;----

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY demux IS

	PORT ( SignalIn : in std_logic_vector (15 downto 0);	
			 clk : in std_logic;
			 ClkDemux : in std_logic_vector (1 downto 0);
			 IOut : out std_logic_vector (15 downto 0);
			 QOut : out std_logic_vector (15 downto 0));
END demux;

ARCHITECTURE demux_arc OF demux is


signal IMux, IMux1, IMux2, IMux3 : std_logic_vector (15 downto 0):= (others => '0');
signal QMux, QMux1, QMux2, QMux3 : std_logic_vector (15 downto 0):= (others => '0');  


BEGIN


	process (clk)
	begin
	if (clk'EVENT and clk = '1') then
		case clkdemux is
			when "00" => QMux <= SignalIn;
			when "01" => IMux <= SignalIn;
			when "10" => QMux <= not(SignalIn) + 1;
			when "11" => IMux <= not(SignalIn) + 1;
			when others =>  null;
								
		end case;
		
		-- Removal of DC offsets of ADCS
--		QMux1 <= QMux;
--		QMux2 <= QMux1;
--		QMux3 <= QMux2;
--		
--		IMux1 <= IMux;
--		IMux2 <= IMux1;
--		IMux3 <= IMux2;
		
--		IOut <= IMux + IMux1 + IMux2 + IMux3; 
--		IOut <= IMux + IMux1 + IMux2 + IMux3; 

		IOut <= IMux(13 downto 0)&"00";
		QOut <= QMux(13 downto 0)&"00";
		
	end if;
	end process;
	
end  demux_arc;
	