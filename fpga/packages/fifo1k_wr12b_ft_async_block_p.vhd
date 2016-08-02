
library ieee;
use ieee.std_logic_1164.all;
package fifo1k_wr12b_ft_async_block_p is

   component fifo1k_wr12b_ft_async_block is
   port
   (
     rst: in std_logic;
     wr_clk: in std_logic;
     rd_clk: in std_logic;
     din: in std_logic_vector(11 downto 0);
     wr_en: in std_logic;
     rd_en: in std_logic;
     dout: out std_logic_vector(11 downto 0);
     full: out std_logic;
     empty: out std_logic
   );
   end component fifo1k_wr12b_ft_async_block;

end package fifo1k_wr12b_ft_async_block_p;

