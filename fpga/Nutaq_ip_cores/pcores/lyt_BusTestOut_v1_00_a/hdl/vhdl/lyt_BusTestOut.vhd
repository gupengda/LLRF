----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:21:18 11/05/2012 
-- Design Name: 
-- Module Name:    lyt_bustestoutDual_wrapper - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library lyt_BusTestOut_v1_00_a;
  use lyt_BusTestOut_v1_00_a.Bustestout_wrapper_p.all;
  
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lyt_BusTestOut is
    Port ( 
        i_sclr_p            : in  std_logic;
        i_clk_p             : in  std_logic;
        i_sourceSelect_p    : in  std_logic;  -- 0 bustest 1 ramp  
        i_ce_p              : in  std_logic;
        i_start_p           : in  std_logic;
        ov14_dataOut_p      : out std_logic_vector(13 DOWNTO 0)
       );
end lyt_BusTestOut;

architecture Behavioral of lyt_BusTestOut is

  constant INWIDTH  : integer := 14;

  signal rampCounter   : unsigned( INWIDTH - 1 downto 0 )        := (others => '0');
  signal busTestOut    : std_logic_vector( INWIDTH - 1 downto 0 ) := (others => '0');
  signal outputBuffer  : std_logic_vector( INWIDTH - 1 downto 0 ) := (others => '0');

begin

  rampOutProcess : process(i_clk_p)
    begin 
      if rising_edge(i_clk_p) then
        if i_sclr_p = '1' then
          rampCounter <= ( others => '0' );
        elsif i_ce_p = '1' and i_start_p = '1' then
          rampCounter <= rampCounter + 1;  
        end if;        
      end if;
    end process;
    

  bustestout_u0 : Bustestout_wrapper
    port map (
      clk         => i_clk_p,
      ce         => i_ce_p,
      start       => i_start_p,
      pattern       => busTestOut
      );  

  asyncMuxProcess : process(i_sourceSelect_p,busTestOut,rampCounter)
    begin 
      if i_sourceSelect_p = '0'  then
        outputBuffer  <=  busTestOut;
      else
        outputBuffer   <=  std_logic_vector(rampCounter);
      end if;
    end process; -- asyncMuxProcess
    
    
    ov14_dataOut_p <= outputBuffer;
  
  
END ARCHITECTURE Behavioral;

