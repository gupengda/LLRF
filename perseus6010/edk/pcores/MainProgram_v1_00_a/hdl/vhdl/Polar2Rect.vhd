----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom
-- 
-- Create Date:    09:00:11 12/24/2012 
-- Design Name: 
-- Module Name:    Polar2Rect - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Polar2Rect is
    Port ( AmpRefOld : in  STD_LOGIC_VECTOR (15 downto 0);
           PhRefOld: in  STD_LOGIC_VECTOR (15 downto 0);
           AmpRefMin : in  STD_LOGIC_VECTOR (15 downto 0);
           PhRefMin : in  STD_LOGIC_VECTOR (15 downto 0);
			  CavPhSh : in std_logic_vector (15 downto 0);
			  FwCavPhSh : in std_logic_vector (15 downto 0);
			  FwIOT1PhSh : in std_logic_vector (15 downto 0);
			  FwIOT2PhSh : in std_logic_vector (15 downto 0);
			  FwIOT3PhSh : in std_logic_vector (15 downto 0);
			  FwIOT4PhSh : in std_logic_vector (15 downto 0);
			  
			  FwCavGain : in std_logic_vector (15 downto 0);			  
			  FwIOT1Gain : in std_logic_vector (15 downto 0);
			  FwIOT2Gain : in std_logic_vector (15 downto 0);
			  FwIOT3Gain : in std_logic_vector (15 downto 0);
			  FwIOT4Gain : in std_logic_vector (15 downto 0);			  
			  
			  GainControl1 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT1 : in std_logic_vector (15 downto 0);
			  GainControl2 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT2 : in std_logic_vector (15 downto 0);
			  GainControl3 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT3 : in std_logic_vector (15 downto 0);
			  GainControl4 : in std_logic_vector (15 downto 0);
			  PhShDACsIOT4 : in std_logic_vector (15 downto 0);
			  			  
			  AmpLoop_ControlOutput : in std_logic_vector (15 downto 0);
			  PhLoop_ControlOutput : in std_logic_vector (15 downto 0);
			  PhCorrectionControl : in std_logic_vector (15 downto 0);
			  
			  PhCorrectionControl_enable : in std_logic;
			  
           clk : in  STD_LOGIC;
           IRefOld : out  STD_LOGIC_VECTOR (15 downto 0);
           QRefOld : out  STD_LOGIC_VECTOR (15 downto 0);
           IRefMin : out  STD_LOGIC_VECTOR (15 downto 0);
           QRefMin : out  STD_LOGIC_VECTOR (15 downto 0);
			  sin_phsh_cav : out std_logic_vector (15 downto 0);
			  cos_phsh_cav : out std_logic_vector (15 downto 0);
			  sin_phsh_fwcav : out std_logic_vector (15 downto 0);
			  cos_phsh_fwcav : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT1 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT1 : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT2 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT2 : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT3 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT3 : out std_logic_vector (15 downto 0);
			  sin_phsh_fwIOT4 : out std_logic_vector (15 downto 0);
			  cos_phsh_fwIOT4 : out std_logic_vector (15 downto 0);
			  sin_phsh_control1 : out std_logic_vector (15 downto 0);
			  cos_phsh_control1 : out std_logic_vector (15 downto 0);
			  sin_phsh_control2 : out std_logic_vector (15 downto 0);
			  cos_phsh_control2 : out std_logic_vector (15 downto 0);
			  sin_phsh_control3 : out std_logic_vector (15 downto 0);
			  cos_phsh_control3 : out std_logic_vector (15 downto 0);
			  sin_phsh_control4 : out std_logic_vector (15 downto 0);
			  cos_phsh_control4 : out std_logic_vector (15 downto 0);
			  I_DACsIF_out : out std_logic_vector (15 downto 0);
			  Q_DACsIF_out : out std_logic_vector (15 downto 0);
			  IControl_Polar : out std_logic_vector (15 downto 0);
			  QControl_Polar : out std_logic_vector (15 downto 0)
			  );
end Polar2Rect;

architecture Behavioral of Polar2Rect is

-- signals declaration

signal id_in_sig : std_logic_vector (4 downto 0):= (others => '0');
signal id_out_sig, id_out_sig_ctrl : std_logic_vector (4 downto 0):= (others => '0');
signal I_out_sig : std_logic_vector (15 downto 0):= (others => '0');
signal Q_out_sig : std_logic_vector (15 downto 0):= (others => '0');
signal Amp_in_sig : std_logic_vector (15 downto 0):= (others => '0');
signal Ph_in_sig : std_logic_vector (15 downto 0):= (others => '0');

signal mux : std_logic_vector (4 downto 0):= (others => '0');

signal GainControl1_sig : std_logic_vector (15 downto 0):= (others => '0');
signal GainControl2_sig : std_logic_vector (15 downto 0):= (others => '0');
signal GainControl3_sig : std_logic_vector (15 downto 0):= (others => '0');
signal GainControl4_sig : std_logic_vector (15 downto 0):= (others => '0');
signal PhShDACsIOT1_sig : std_logic_vector (15 downto 0):= (others => '0');
signal PhShDACsIOT2_sig : std_logic_vector (15 downto 0):= (others => '0');
signal PhShDACsIOT3_sig : std_logic_vector (15 downto 0):= (others => '0');
signal PhShDACsIOT4_sig : std_logic_vector (15 downto 0):= (others => '0');

signal FwCavGain_sig : std_logic_vector (15 downto 0):= (others => '0');
signal FwIOT1Gain_sig : std_logic_vector (15 downto 0):= (others => '0');
signal FwIOT2Gain_sig : std_logic_vector (15 downto 0):= (others => '0');
signal FwIOT3Gain_sig : std_logic_vector (15 downto 0):= (others => '0');
signal FwIOT4Gain_sig : std_logic_vector (15 downto 0):= (others => '0');

signal LookRefLatchLatch : std_logic:= '0';
signal PhCorrectionControl_enable_latch : std_logic:= '0';


-- components declaration

component CordicPolar2Rect IS
	PORT ( Amp_In : in std_logic_vector (15 downto 0);
			 Ph_In : in std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 I_Out : out std_logic_vector (15 downto 0);
			 Q_out : out std_logic_vector (15 downto 0);
			 id_in : in std_logic_vector (4 downto 0);
			 id_out : out std_logic_vector (4 downto 0));			 
end component CordicPolar2Rect;




begin

process(clk)
begin
if (clk'EVENT and clk = '1') then


	if(GainControl1 = X"0000") then
		GainControl1_sig <= X"4DB8";
	else
		GainControl1_sig <= GainControl1;
	end if;	
	
	if(GainControl2 = X"0000") then
		GainControl2_sig <= X"4DB8";
	else
		GainControl2_sig <= GainControl2;
	end if;	
	
	if(GainControl3 = X"0000") then
		GainControl3_sig <= X"4DB8";
	else
		GainControl3_sig <= GainControl3;
	end if;	
	
	if(GainControl4 = X"0000") then
		GainControl4_sig <= X"4DB8";
	else
		GainControl4_sig <= GainControl4;
	end if;
	
	if(FwCavGain = X"0000") then
		FwCavGain_sig <= X"4DB8";
	else
		FwCavGain_sig <= FwCavGain;
	end if;
	
	if(FwIOT1Gain = X"0000") then
		FwIOT1Gain_sig <= X"4DB8";
	else
		FwIOT1Gain_sig <= FwIOT1Gain;
	end if;
	
	if(FwIOT2Gain = X"0000") then
		FwIOT2Gain_sig <= X"4DB8";
	else
		FwIOT2Gain_sig <= FwIOT2Gain;
	end if;
	
	if(FwIOT3Gain = X"0000") then
		FwIOT3Gain_sig <= X"4DB8";
	else
		FwIOT3Gain_sig <= FwIOT3Gain;
	end if;
	
	if(FwIOT4Gain = X"0000") then
		FwIOT4Gain_sig <= X"4DB8";
	else
		FwIOT4Gain_sig <= FwIOT4Gain;
	end if;
	
	
	if(PhCorrectionControl_enable = '1') then
		PhShDACsIOT1_sig <= PhShDACsIOT1 + PhCorrectionControl;
		PhShDACsIOT2_sig <= PhShDACsIOT2 + PhCorrectionControl;
		PhShDACsIOT3_sig <= PhShDACsIOT3 + PhCorrectionControl;
		PhShDACsIOT4_sig <= PhShDACsIOT4 + PhCorrectionControl;
	else
		PhShDACsIOT1_sig <= PhShDACsIOT1;
		PhShDACsIOT2_sig <= PhShDACsIOT2;
		PhShDACsIOT3_sig <= PhShDACsIOT3;
		PhShDACsIOT4_sig <= PhShDACsIOT4;	
	end if;
		
	mux <= mux + 1;
	
	case mux is 
		when "00000" => id_in_sig <= "00000";
							Amp_in_sig <= AmpRefOld;
							Ph_in_sig <= PhRefOld;
		when "00010" => id_in_sig <= "00010";
							Amp_in_sig <= AmpRefMin;
							Ph_in_sig <= PhRefMin;
		when "00100" => id_in_sig <= "00100";
							Amp_in_sig <= X"4DB8";
							Ph_in_sig <= CavPhSh;
		when "00110" => id_in_sig <= "00110";
							Amp_in_sig <= FwCavGain_sig;
							Ph_in_sig <= FwCavPhSh;
		when "01000" => id_in_sig <= "01000";
							Amp_in_sig <= FwIOT1Gain_sig;
							Ph_in_sig <= FwIOT1PhSh;
		when "01010" => id_in_sig <= "01010";
							Amp_in_sig <= FwIOT2Gain_sig;
							Ph_in_sig <= FwIOT2PhSh;
		when "01100" => id_in_sig <= "01100";
							Amp_in_sig <= FwIOT3Gain_sig;
							Ph_in_sig <= FwIOT3PhSh;
		when "01110" => id_in_sig <= "01110";
							Amp_in_sig <= FwIOT4Gain_sig;
							Ph_in_sig <= FwIOT4PhSh;
		when "10000" => id_in_sig <= "10000";
							Amp_in_sig <= GainControl1_sig;
							Ph_in_sig <= PhShDACsIOT1_sig;
		when "10010" => id_in_sig <= "10010";
							Amp_in_sig <= GainControl2_sig;
							Ph_in_sig <= PhShDACsIOT2_sig;
		when "10100" => id_in_sig <= "10100";
							Amp_in_sig <= GainControl3_sig;
							Ph_in_sig <= PhShDACsIOT3_sig;
		when "10110" => id_in_sig <= "10110";
							Amp_in_sig <= GainControl4_sig;
							Ph_in_sig <= PhShDACsIOT4_sig;
		when others => id_in_sig <= "00001";
							Amp_in_sig <= X"4DB8";
							Ph_in_sig <= PhCorrectionControl;
	end case;
	
	case id_out_sig is
		when "00000" => IRefOld <= I_out_sig;
							QRefOld <= Q_out_sig;
		when "00010" => IRefMin <= I_out_sig;
							QRefMin <= Q_out_sig;
		when "00100" => cos_phsh_cav <= I_out_sig;
							sin_phsh_cav <= Q_out_sig;
		when "00110" => cos_phsh_fwcav <= I_out_sig;
							sin_phsh_fwcav <= Q_out_sig;
		when "01000" => cos_phsh_fwIOT1 <= I_out_sig;
							sin_phsh_FwIOT1 <= Q_out_sig;
		when "01010" => cos_phsh_FwIOT2 <= I_out_sig;
							sin_phsh_FwIOT2 <= Q_out_sig;
		when "01100" => cos_phsh_FwIOT3 <= I_out_sig;
							sin_phsh_FwIOT3 <= Q_out_sig;
		when "01110" => cos_phsh_FwIOT4 <= I_out_sig;
							sin_phsh_FwIOT4 <= Q_out_sig;
		when "10000" => cos_phsh_control1 <= I_out_sig;
							sin_phsh_control1 <= Q_out_sig;
		when "10010" => cos_phsh_control2 <= I_out_sig;
							sin_phsh_control2 <= Q_out_sig;
		when "10100" => cos_phsh_control3 <= I_out_sig;
							sin_phsh_control3 <= Q_out_sig;
		when "10110" => cos_phsh_control4 <= I_out_sig;
							sin_phsh_control4 <= Q_out_sig;
		when others => I_DACsIF_out <= I_out_sig;
							Q_DACsIF_out <= Q_out_sig;
	end case;
	
end if;
end process;

C_P2R : component CordicPolar2Rect
	port map( Amp_In => Amp_in_sig,
				Ph_In => Ph_in_sig,
				clk => clk,
				I_Out => I_out_sig,
				Q_out => Q_out_sig,
				id_in => id_in_sig,
				id_out => Id_out_sig);


Control_P2R : component CordicPolar2Rect
	port map( Amp_In => AmpLoop_ControlOutput,
				Ph_In => PhLoop_ControlOutput,
				clk => clk,
				I_Out => IControl_Polar,
				Q_out => QControl_Polar,
				id_in => "00001",
				id_out => Id_out_sig_ctrl);


end Behavioral;

