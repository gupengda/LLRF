
library ieee;
use ieee.std_logic_1164.all;

package fifo1kx8b_sync_block_cnt_p is

  component fifo1kx8b_sync_block_cnt is
  port
  (
    clk: in std_logic;
    srst: in std_logic;
    din: in std_logic_vector(7 downto 0);
    wr_en: in std_logic;
    rd_en: in std_logic;
    dout: out std_logic_vector(7 downto 0);
    full: out std_logic;
    empty: out std_logic;
    data_count: out std_logic_vector(10 downto 0)
  );
  end component fifo1kx8b_sync_block_cnt;

end package fifo1kx8b_sync_block_cnt_p;

