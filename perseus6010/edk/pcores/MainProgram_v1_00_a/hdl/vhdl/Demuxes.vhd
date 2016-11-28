----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    17:19:13 08/22/2014 
-- Design Name: 	
-- Module Name:    Demuxes - Behavioral 
-- Project Name: Max-IV LLRF
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
library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Demuxes is
    Port ( VCav : in  STD_LOGIC_VECTOR (15 downto 0); --RFIN1
           FwCav : in  STD_LOGIC_VECTOR (15 downto 0); -- RFIn2
           RvCav : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn3
           MO : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn4;
           FwIOT1 : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn5
           RvIOT1 : in  STD_LOGIC_VECTOR (15 downto 0); --RFIN6
           DACsIF : in  STD_LOGIC_VECTOR (15 downto 0); --RFIn16
			  
           RFIn7 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn8 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn9 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn10 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn11 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn12 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn13 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn14 : in  STD_LOGIC_VECTOR (15 downto 0);
           RFIn15 : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           LookRefLatch : in  STD_LOGIC;
			  LookRefManual : in std_logic;
			  ManualOffset : in std_logic_vector (1 downto 0);
			  AnyLoopsEnable_latch : in std_logic;
           Quad : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
			  
           IMuxCav : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxCav : out  STD_LOGIC_VECTOR (15 downto 0);
           IMuxFwCav : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwCav : out  STD_LOGIC_VECTOR (15 downto 0);
           IMuxRvCav : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxRvCav : out  STD_LOGIC_VECTOR (15 downto 0);
			  IMO : out std_logic_vector (15 downto 0);
			  QMO : out std_logic_vector (15 downto 0);			  
           IMuxFwIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxFwIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);			  
           IMuxRvIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           QMuxRvIOT1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  IMuxDACsIF : out std_logic_vector (15 downto 0);
			  QMuxDACsIF : out std_logic_vector (15 downto 0);
			  
           IRFIn7 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn7 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn8 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn8 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn9 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn9 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn10 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn10 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn11 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn11 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn12 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn12 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn13 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn13 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn14 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn14 : out  STD_LOGIC_VECTOR (15 downto 0);
           IRFIn15 : out  STD_LOGIC_VECTOR (15 downto 0);
           QRFIn15 : out  STD_LOGIC_VECTOR (15 downto 0);			  
           
			  ClkDemux_out : out  STD_LOGIC_VECTOR (1 downto 0);
			  WordQuad_out : out std_logic_vector (3 downto 0)
			  );
end Demuxes;

architecture Behavioral of Demuxes is

-- Signals Declaration

	signal clkdemux: std_logic_vector (1 downto 0) := (others => '0');
	signal clkcav : std_logic_vector (1 downto 0):= (others => '0');
	signal clkcav_delay : std_logic_vector (1 downto 0):= (others => '0');
	signal offset : std_logic_vector (1 downto 0):= (others => '0');
	signal LoadOffset : std_logic_vector (1 downto 0):= (others => '0');
	signal WordQuad : std_logic_vector (3 downto 0):= (others => '0');
	signal MO0, MO1, MO2, MO3 : std_logic;


-- Components Declaration

component demux IS
	port ( SignalIn : in std_logic_vector (15 downto 0);	
			 clk : in std_logic;
			 ClkDemux : in std_logic_vector (1 downto 0);
			 IOut : out std_logic_vector (15 downto 0);
			 QOut : out std_logic_vector (15 downto 0));

	end component demux;



begin

process(clk)
begin
	if(clk'EVENT and clk = '1') then	
		clkdemux <= clkdemux + 1;
		WordQuad <= MO0&MO1&MO2&MO3;
		ClkCav <= ClkDemux + LoadOffset;
		ClkDemux_out <= ClkCav;
		WordQuad_out <= WordQuad;
		
		if(AnyLoopsEnable_latch = '1') then
			LoadOffset <= LoadOffset;
		elsif(LookRefManual = '1') then
			LoadOffset <= ManualOffset;
		elsif(LookRefLatch = '1') then
			LoadOffset <= offset;
		end if;		
	
		case clkdemux is 
			when "00" => MO0 <= MO(15);
			when "01" => MO1 <= MO(15);
			when "10" => MO2 <= MO(15);
			when "11" => MO3 <= MO(15);
			when others => null;
		end case;
		

			
		case Quad is
			when "00" => if(WordQuad = "0011") then
								offset <= "00";
							 elsif(WordQuad = "0110") then
								offset <= "01";
							 elsif(WordQuad = "1100") then
								offset <= "10";
							 else offset <= "11";
							 end if;
			when "01" => if(WordQuad = "0011") then
								offset <= "11";
							 elsif(WordQuad = "0110") then
								offset <= "00";
							 elsif(WordQuad = "1100") then
								offset <= "01";
							 else offset <= "10";
							 end if;
			when "10" => if(WordQuad = "0011") then
								offset <= "10";
							 elsif(WordQuad = "0110") then
								offset <= "11";
							 elsif(WordQuad = "1100") then
								offset <= "00";
							 else offset <= "01";
							 end if;
			when "11" => if(WordQuad = "0011") then
								offset <= "01";
							 elsif(WordQuad = "0110") then
								offset <= "10";
							 elsif(WordQuad = "1100") then
								offset <= "11";
							 else offset <= "00";
							 end if;
			when others => null;
		end case;
			
	end if;
end process;


IQDemux_Cav : component Demux
	PORT MAP(
	SignalIn => VCav,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IMuxCav,
	QOut => QMuxCav);

		
IQDemux_FwCav : component Demux
	PORT MAP(
	SignalIn => FwCav,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IMuxFwCav,
	QOut => QMuxFwCav);

		
IQDemux_RvCav : component Demux
	PORT MAP(
	SignalIn => RvCav,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IMuxRvCav,
	QOut => QMuxRvCav);

	
IQDemux_MO : component Demux
	PORT MAP(
	SignalIn => MO,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IMO,
	QOut => QMO);
	
IQDemux_FwIOT1 : component Demux
	PORT MAP(
	SignalIn => FwIOT1,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IMuxFwIOT1,
	QOut => QMuxFwIOT1);
	
IQDemux_RvIOT1 : component Demux
	PORT MAP(
	SignalIn => RvIOT1,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IMuxRvIOT1,
	QOut => QMuxRvIOT1);
	
	
IQDemux_DACsIF : component Demux
	PORT MAP(
	SignalIn => DACsIF,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IMuxDACsIF,
	QOut => QMuxDACsIF);
	
IQDemux_RFIn7 : component Demux
	PORT MAP(
	SignalIn => RFIn7,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn7,
	QOut => QRFIn7);	
	
IQDemux_RFIn8 : component Demux
	PORT MAP(
	SignalIn => RFIn8,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn8,
	QOut => QRFIn8);	
	
IQDemux_RFIn9 : component Demux
	PORT MAP(
	SignalIn => RFIn9,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn9,
	QOut => QRFIn9);
	
IQDemux_RFIn10 : component Demux
	PORT MAP(
	SignalIn => RFIn10,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn10,
	QOut => QRFIn10);
	
IQDemux_RFIn11 : component Demux
	PORT MAP(
	SignalIn => RFIn11,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn11,
	QOut => QRFIn11);
	
IQDemux_RFIn12 : component Demux
	PORT MAP(
	SignalIn => RFIn12,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn12,
	QOut => QRFIn12);
	
IQDemux_RFIn13 : component Demux
	PORT MAP(
	SignalIn => RFIn13,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn13,
	QOut => QRFIn13);
	
IQDemux_RFIn14 : component Demux
	PORT MAP(
	SignalIn => RFIn14,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn14,
	QOut => QRFIn14);
	
IQDemux_RFIn15 : component Demux
	PORT MAP(
	SignalIn => RFIn15,
	clk => clk,
	ClkDemux => ClkCav,
	IOut => IRFIn15,
	QOut => QRFIn15);


end Behavioral;

