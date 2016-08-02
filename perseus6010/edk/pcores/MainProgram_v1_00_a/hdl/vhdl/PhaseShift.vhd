---File Demux.vhd;----

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY PhaseShift IS

	PORT ( Iin : in std_logic_vector (15 downto 0);	
			 Qin : in std_logic_vector (15 downto 0);	
			 sin : in std_logic_vector (15 downto 0);	
			 cos : in std_logic_vector (15 downto 0);	
			 clk : in std_logic;
			 IOut : out std_logic_vector (15 downto 0);	
			 QOut : out std_logic_vector (15 downto 0));
END PhaseShift;

ARCHITECTURE PhaseShift_arc OF PhaseShift is

signal IPS : std_logic_vector (31 downto 0);
signal QPS : std_logic_vector (31 downto 0);

signal IIn_latch : std_logic_vector (15 downto 0);
signal QIn_latch : std_logic_vector (15 downto 0);
signal sin_latch : std_logic_vector (15 downto 0);
signal cos_latch : std_logic_vector (15 downto 0);

BEGIN

process(clk)

begin
	if (clk'EVENT and clk = '1') then
		
		IIn_latch <= IIn;
		QIn_latch <= QIn;
		sin_latch <= sin;
		cos_latch <= cos;
	
		IPS <= Iin_latch*Cos_latch - QIn_latch*Sin_latch;
		QPS <= IIn_latch*Sin_latch + QIn_latch*Cos_latch;
		
		IOut <= IPS(30 downto 15);
		QOut <= QPS(30 downto 15);
		
	end if;
end process;


	
end  PhaseShift_arc;
	