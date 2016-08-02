
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------

package Xgmii_p is

  constant IdleXGMIICode_c            : std_logic_vector(7 downto 0) := x"07";
  constant StartOfPckt27K7CodeS_c     : std_logic_vector(7 downto 0) := x"FB";
  constant EndOfPckt29K7CodeT_c       : std_logic_vector(7 downto 0) := x"FD";
  
end Xgmii_p;

--------------------------------------------------------------------------------
