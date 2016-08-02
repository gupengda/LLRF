--- File VCXO_ProgramminDiagBoard.vhd -------------
--- Created 22nd July 2009 -----
--- Modified 9th August 2011 to match VCXO parameters addressing of MAX-IV 

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY VCXO_Programming IS

	PORT( LE_VCXO: out std_logic;
			Data_VCXO : out std_logic;
			CLK_VCXO : out std_logic;
			clk : in std_logic;
			MDivider : in std_logic_vector (9 downto 0);
			NDivider : in std_logic_vector (9 downto 0);
			MuxSel : in std_logic_vector (2 downto 0);
			Mux0 : in std_logic_vector (2 downto 0);
			Mux1 : in std_logic_vector (2 downto 0);
			Mux2 : in std_logic_vector (2 downto 0);
			Mux3 : in std_logic_vector (2 downto 0);
			Mux4 : in std_logic_vector (2 downto 0);
			CP_Dir: in std_logic;
			SendWordVCXO : in std_logic;
			VCXO_out_inversion : in std_logic);
END VCXO_Programming;

ARCHITECTURE VCXO_Programming_arc OF VCXO_Programming is

	signal clk_VCXO_counter : std_logic_vector (11 downto 0);
	signal clk_VCXO_2_5MHz, clk_VCXO_5MHz, clk_VCXO_10MHz : std_logic;
	signal SendWordVCXOL : std_logic;
	signal StartTx, StartTxL, FinishTx, FinishTXL : std_logic;
	signal counterVCXOword : std_logic_vector (7 downto 0);
	signal Data_Signal : std_logic;


	signal clk_VCXO_50kHz_latch : std_logic;
	signal clk_VCXO_50kHz : std_logic;
	
	signal LE_VCXO_sig : std_logic;
	signal Data_VCXO_sig : std_logic;
	signal clk_VCXO_sig : std_logic;

BEGIN


	process (clk)
	begin
		if(clk'EVENT and clk = '1') then
			clk_VCXO_counter <= clk_VCXO_counter + 1;
			clk_VCXO_2_5MHz <= clk_VCXO_counter(4);
			clk_VCXO_5MHz <= clk_VCXO_counter(3);
			clk_VCXO_10MHz <= clk_VCXO_counter(2);			
			
			
			clk_VCXO_50kHz_latch <= clk_VCXO_counter(11);
			clk_VCXO_50kHz <= clk_VCXO_50kHz_latch;
			
			
			sendwordVCXOL <= sendwordVCXO;
			StartTxL <= StartTx;
			FinishTxL <= FinishTx;
		
			Data_VCXO <= Data_Signal;
			clk_VCXO <= clk_VCXO_sig;
			LE_VCXO <= LE_VCXO_sig;
			
		end if;
	end process;
	
	process(clk_VCXO_50kHz, sendWordVCXO)
	begin
		if(sendwordVCXO = '1' and sendwordVCXOL = '0') then
			counterVCXOword <= (others => '0');
		elsif(clk_VCXO_50kHz'EVENT and clk_VCXO_50kHz = '1') then
			if (counterVCXOword < X"CB") then
				counterVCXOword <= counterVCXOword + 1;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if(clk'EVENT and clk = '1') then
		
		case counterVCXOWord is
			when X"00" =>  LE_VCXO_sig <= '1';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
								FinishTx <= '0';
								StartTx <= '1';
			when X"01" =>  LE_VCXO_sig <= '1';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
								
								
			when X"02" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MuxSel(2); --bit 31
			when X"03" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"04" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MuxSel(1); --bit 30
			when X"05" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"06" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MuxSel(0); --bit 29
			when X"07" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"08" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 28
			when X"09" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"0A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 27
			when X"0B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"0C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 26
			when X"0D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"0E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 25
			when X"0F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"10" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 24
			when X"11" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"12" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 23
			when X"13" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"14" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 22
			when X"15" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"16" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 21
			when X"17" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"18" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 20
			when X"19" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"1A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 19
			when X"1B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"1C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 18
			when X"1D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"1E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 17
			when X"1F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"20" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 16
			when X"21" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"22" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 15
			when X"23" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"24" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 14
			when X"25" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"26" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 13
			when X"27" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"28" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 12
			when X"29" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"2A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(9); --bit 11
			when X"2B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"2C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(8); --bit 10
			when X"2D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"2E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(7); --bit 9
			when X"2F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"30" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(6); --bit 8
			when X"31" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"32" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(5); --bit 7
			when X"33" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"34" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(4); --bit 6
			when X"35" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"36" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(3); --bit 5
			when X"37" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"38" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(2); --bit 4
			when X"39" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"3A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(1); --bit 3
			when X"3B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"3C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= MDivider(0); --bit 2
			when X"3D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"3E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 1
			when X"3F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"40" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 0
			when X"41" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			--Second Word					
			when X"42" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
			
			
			when X"43" =>  LE_VCXO_sig <= '1';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
								
			when X"44" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
								
								
			when X"45" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 31
			when X"46" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"47" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= CP_Dir; --bit 30
			when X"48" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"49" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux4(2); --bit 29
			when X"4A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"4B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux4(1); --bit 28
			when X"4C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"4D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux4(0); --bit 27
			when X"4E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"4F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux3(2); --bit 26
			when X"50" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"51" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux3(1); --bit 25
			when X"52" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"53" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux3(0); --bit 24
			when X"54" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"55" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux2(2); --bit 23
			when X"56" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"57" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux2(1); --bit 22
			when X"58" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"59" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux2(0); --bit 21
			when X"5A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"5B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux1(2); --bit 20
			when X"5C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"5D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux1(1); --bit 19
			when X"5E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"5F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux1(0); --bit 18
			when X"60" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"61" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux0(2); --bit 17
			when X"62" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"63" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux0(1); --bit 16
			when X"64" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"65" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= Mux0(0); --bit 15
			when X"66" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
				
								
			when X"67" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 14
			when X"68" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"69" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 13
			when X"6A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"6B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 12
			when X"6C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"6D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(9); --bit 11
			when X"6E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"6F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(8); --bit 10
			when X"70" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"71" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(7); --bit 9
			when X"72" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"73" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(6); --bit 8
			when X"74" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"75" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(5); --bit 7
			when X"76" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"77" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(4); --bit 6
			when X"78" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"79" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(3); --bit 5
			when X"7A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"7B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(2); --bit 4
			when X"7C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"7D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(1); --bit 3
			when X"7E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"7F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= NDivider(0); --bit 2
			when X"80" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"81" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 1
			when X"82" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"83" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 0
			when X"84" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"85" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
			when X"86" =>  LE_VCXO_sig <= '1';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
			when X"87" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
								finishTx <= '1';
								StartTx <= '0';
								
								
								
			---THIRD WORD
			
			
			when X"88" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 31
			when X"89" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"8A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 30
			when X"8B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"8C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 29
			when X"8D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"8E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 28
			when X"8F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"90" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 27
			when X"91" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"92" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 26
			when X"93" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"94" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 25
			when X"95" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"96" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 24
			when X"97" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"98" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 23
			when X"99" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"9A" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 22
			when X"9B" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"9C" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 21
			when X"9D" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"9E" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 20
			when X"9F" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"A0" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 19
			when X"A1" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"A2" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 18
			when X"A3" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"A4" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 17
			when X"A5" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"A6" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 16
			when X"A7" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"A8" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 15
			when X"A9" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
				
								
			when X"AA" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 14
			when X"AB" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"AC" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 13
			when X"AD" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"AE" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 12
			when X"AF" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"B0" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 11
			when X"B1" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"B2" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 10
			when X"B3" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"B4" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 9
			when X"B5" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"B6" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 8
			when X"B7" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"B8" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 7
			when X"B9" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
								
			when X"BA" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 6
			when X"BB" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
																
								
			when X"BC" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 5
			when X"BD" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"BE" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 4
			when X"BF" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
								
			when X"C0" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 3
			when X"C1" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
														
			when X"C2" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 2
			when X"C3" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"C4" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '1'; --bit 1
			when X"C5" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"C6" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0'; --bit 0
			when X"C7" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '1';
								data_signal <= data_signal;
								
			when X"C8" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
			when X"C9" =>  LE_VCXO_sig <= '1';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
			when X"CA" =>  LE_VCXO_sig <= '0';
								CLK_VCXO_sig <= '0';
								data_signal <= '0';
								finishTx <= '1';
								StartTx <= '0';	
			
			when others => null;
	end case;
end if;
end process;
								
	
end  VCXO_Programming_arc;
	