----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:26:23 11/05/2012 
-- Design Name: 
-- Module Name:    lyt_bustestinDual_wrapper - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library lyt_BusTestIn_v1_00_a;
  use lyt_BusTestIn_v1_00_a.Bustestin_wrapper_p.all;

entity lyt_BusTestIn is
  port ( 
    i_sclr_p          : in  std_logic;
    i_clk_p           : in  std_logic;
    i_sourceMux_p      : in  std_logic;
    iv14_dataIn_p         : in  std_logic_vector(13 downto 0);
    i_dataValid_p      : in  std_logic;
    i_start_p          : in  std_logic;  
    o_lock_p          : out std_logic;
    ov32_errorCnt_p        : out std_logic_vector( 31 downto 0 );
    ov32_errorMask_p      : out std_logic_vector( 31 downto 0 );
    ov32_dataCountDiv1024_p   : out std_logic_vector( 31 downto 0 )
  );
end lyt_BusTestIn;

architecture Behavioral of lyt_BusTestIn is

  constant INWIDTH     : integer := 14;
  constant c_zero_vec  : std_logic_vector( 31 downto 0 ) := x"00000000";
  
  COMPONENT rampTestIn
   generic(
        dataWidth : integer := 14
   );
    Port ( 
        rampIn     : in  std_logic_vector( dataWidth -1 downto 0 );
        valid      : in  std_logic;
        start      : in  std_logic;
        errorCnt    : out std_logic_vector( 31 downto 0 );
        errorMask  : out std_logic_vector( dataWidth -1 downto 0 );
        dataCountDiv1024 : out std_logic_vector( 31 downto 0);
        lock      : out std_logic;
        reset     : in  std_logic;
        clk      : in  std_logic
      );
  END COMPONENT;


  signal sLock0,sLock1                   : std_logic;
  signal sv32_errorCnt0, sv32_errorCnt1         : std_logic_vector( 31 downto 0 );
  signal sErrorMask0, sErrorMask1               : std_logic_vector( INWIDTH - 1 downto 0 );
  signal sDataCountDiv1024_0, sDataCountDiv1024_1  : std_logic_vector( 31 downto 0 );


begin

  bustestinGroup1_u1 : Bustestin_wrapper
      port map (
        clk           => i_clk_p,
        ce           => i_dataValid_p,
        start         => i_start_p,
        nRstErr         => not i_sclr_p,
        pattern         => iv14_dataIn_p,
        lock           => sLock0,
        errorCnt        => sv32_errorCnt0,
        dataCountDiv1024 => sDataCountDiv1024_0,
        errorMask       => sErrorMask0
      );    
      
  rampTestIn_u0 : rampTestIn
      generic map(
        dataWidth        => 14
      )
      Port map ( 
        rampIn           => iv14_dataIn_p, 
        valid            => i_dataValid_p,  
        start            => i_start_p,
        errorCnt          => sv32_errorCnt1,
        errorMask        => sErrorMask1,
        dataCountDiv1024 => sDataCountDiv1024_1,
        lock            => sLock1,
        reset            => i_sclr_p,
        clk             => i_clk_p
      );

  outputMuxProcess : process( i_sourceMux_p, sLock0, sLock1, sv32_errorCnt0, sv32_errorCnt1, sErrorMask0, sErrorMask1, sDataCountDiv1024_0, sDataCountDiv1024_1 )
    begin 
      if i_sourceMux_p = '0' then 
        o_lock_p          <= sLock0;
        ov32_errorCnt_p        <= sv32_errorCnt0;
        ov32_errorMask_p      <= c_zero_vec( (32 - INWIDTH) -1 downto 0) & sErrorMask0;
        ov32_dataCountDiv1024_p  <= sDataCountDiv1024_0;
      else
        o_lock_p          <= sLock1;
        ov32_errorCnt_p        <= sv32_errorCnt1;
        ov32_errorMask_p      <= c_zero_vec( (32 - INWIDTH) -1 downto 0) & sErrorMask1;
        ov32_dataCountDiv1024_p  <= sDataCountDiv1024_1;
      end if;
    end process;

end Behavioral;

