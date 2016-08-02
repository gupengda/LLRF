
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package fifo16x256b_async_dist_p is

    component fifo16x256b_async_dist is
    port
    (
      rst: in std_logic;
      wr_clk: in std_logic;
      rd_clk: in std_logic;
      din: in std_logic_vector(255 downto 0);
      wr_en: in std_logic;
      rd_en: in std_logic;
      dout: out std_logic_vector(255 downto 0);
      full: out std_logic;
      wr_ack: out std_logic;
      overflow: out std_logic;
      empty: out std_logic;
      valid: out std_logic;
      underflow: out std_logic;
      prog_full: out std_logic
    );
    end component fifo16x256b_async_dist;

end package fifo16x256b_async_dist_p;

