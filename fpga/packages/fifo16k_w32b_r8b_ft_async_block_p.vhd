
library ieee;
use ieee.std_logic_1164.all;

package fifo16k_w32b_r8b_ft_async_block_p is

component fifo16k_w32b_r8b_ft_async_block is
  port
  (
    rst: in std_logic;
    wr_clk: in std_logic;
    rd_clk: in std_logic;
    din: in std_logic_vector(31 downto 0);
    wr_en: in std_logic;
    rd_en: in std_logic;
    dout: out std_logic_vector(7 downto 0);
    full: out std_logic;
    almost_full: out std_logic;
    empty: out std_logic;
    rd_data_count: out std_logic_vector(14 downto 0);
    wr_data_count: out std_logic_vector(12 downto 0);
    prog_full: out std_logic
  );
  end component fifo16k_w32b_r8b_ft_async_block;

end package fifo16k_w32b_r8b_ft_async_block_p;

