
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package v6Ddr3Controler8b_p is

  component v6Ddr3Controler8b is
  port
  (
     sys_clk :             in std_logic;
     clk_ref :             in std_logic;
     ddr3_dq :             inout std_logic_vector(7 downto 0);
     ddr3_addr :           out std_logic_vector(13 downto 0);
     ddr3_ba :             out std_logic_vector(2 downto 0);
     ddr3_ras_n :          out std_logic;
     ddr3_cas_n :          out std_logic;
     ddr3_we_n :           out std_logic;
     ddr3_reset_n :        out std_logic;
     ddr3_cs_n :           out std_logic_vector(0 downto 0);
     ddr3_odt :            out std_logic_vector(0 downto 0);
     ddr3_cke :            out std_logic_vector(0 downto 0);
     ddr3_dm :             out std_logic_vector(0 downto 0);
     ddr3_dqs_p :          inout std_logic_vector(0 downto 0);
     ddr3_dqs_n :          inout std_logic_vector(0 downto 0);
     ddr3_ck_p :           out std_logic_vector(0 downto 0);
     ddr3_ck_n :           out std_logic_vector(0 downto 0);
     app_wdf_wren :        in std_logic;
     app_wdf_data :        in std_logic_vector(31 downto 0);
     app_wdf_mask :        in std_logic_vector(3 downto 0);   
     app_wdf_end :         in std_logic;
     tg_addr :             in std_logic_vector(27 downto 0);
     app_cmd :             in std_logic_vector(2 downto 0);
     app_en :              in std_logic;
     app_full :            out std_logic;
     app_wdf_full :        out std_logic;
     app_wdf_afull:        out std_logic;
     app_rd_data :         out std_logic_vector(31 downto 0);
     app_rd_data_valid :   out std_logic;
     tb_rst :              out std_logic;
     tb_clk :              out std_logic;
     phy_init_done :       out std_logic;
     iodelay_ctrl_rdy :    in std_logic;
     sys_rst       :       in std_logic

  );
  end component;

end package v6Ddr3Controler8b_p;