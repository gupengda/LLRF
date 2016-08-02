
library ieee;
use ieee.std_logic_1164.all;

package fifo32x20b_sync_block_cnt_p is

  component fifo32x20b_sync_block_cnt is
  port
  (
    clk: in std_logic;
    din: in std_logic_vector(19 downto 0);
    wr_en: in std_logic;
    rd_en: in std_logic;
    dout: out std_logic_vector(19 downto 0);
    full: out std_logic;
    empty: out std_logic;
    data_count: out std_logic_vector(4 downto 0)
  );
  end component fifo32x20b_sync_block_cnt;

end package fifo32x20b_sync_block_cnt_p;

