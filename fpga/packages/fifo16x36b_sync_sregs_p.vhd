
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package fifo16x36bSyncSRegs_p is

    component fifo16x36bSyncSRegs IS
        port (
        clk: IN std_logic;
        srst: IN std_logic;
        din: IN std_logic_VECTOR(35 downto 0);
        wr_en: IN std_logic;
        rd_en: IN std_logic;
        dout: OUT std_logic_VECTOR(35 downto 0);
        full: OUT std_logic;
        almost_full: OUT std_logic;
        overflow: OUT std_logic;
        empty: OUT std_logic;
        almost_empty: OUT std_logic;
        underflow: OUT std_logic);
    end component fifo16x36bSyncSRegs;

end package fifo16x36bSyncSRegs_p;

