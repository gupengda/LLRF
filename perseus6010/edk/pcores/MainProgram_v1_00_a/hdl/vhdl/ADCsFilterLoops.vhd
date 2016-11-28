---File ADCsFilterLoops.vhd;----

-- Modified 12th March --
-- Accumlator decimals rounded --

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY ADCsFilterLoops IS

	port (InI : in std_logic_vector (15 downto 0);
			InQ : in std_logic_vector (15 downto 0);
			clk : in std_logic;
			ConstantFilter : in std_logic_vector (7 downto 0);
			ConstantFilter_Inverse : in integer range 0 to 7;
			OutI : out std_logic_vector (15 downto 0);
			OutQ : out std_logic_vector (15 downto 0));
			 
END ADCsFilterLoops;

ARCHITECTURE ADCsFilterLoops_arc OF ADCsFilterLoops is


	signal IFilter : std_logic_vector (15 downto 0);		
	signal QFilter  : std_logic_vector (15 downto 0);
	signal IAccum : std_logic_vector (23 downto 0);	
	signal QAccum  : std_logic_vector (23 downto 0);

	
	signal ConstantFilterInverse_Plus : integer range 15 to 22;

	
	
BEGIN
	process (clk)
	-- variable 
	begin
	if (clk'EVENT and clk = '1') then
			
		OutI <= IFilter;		
		OutQ <= QFilter;

	end if;
	end process;	
	

			 
	process(clk)
	begin
		if(clk'EVENT and clk = '1') then
			ConstantFilterInverse_Plus <= ConstantFilter_Inverse + 15;
		end if;
	end process;
			 
			 
		 
	process(clk)
--	variable IAccumVble : std_logic_vector (22 downto 0);
--	variable IFilterVble : std_logic_vector (15 downto 0);
	begin
	if(clk'EVENT and clk = '1') then
		IAccum <= IFilter*ConstantFilter + InI;
		IFilter <= IAccum(ConstantFilterInverse_Plus downto ConstantFilter_Inverse) + IAccum(ConstantFilter_Inverse - 1);
		--IFilter <= IFilter;
	end if;
	end process;	

			 			 
	process(clk)
--	variable QAccumVble : std_logic_vector (22 downto 0);
--	variable QFilterVble : std_logic_vector (15 downto 0);
	begin
	if(clk'EVENT and clk = '1') then
		QAccum <= QFilter*ConstantFilter + InQ;
		QFilter <= QAccum(ConstantFilterInverse_Plus downto ConstantFilter_Inverse) + QAccum(ConstantFilter_Inverse - 1);
		--QFilter <= QFilterVble;
	end if;
	end process;	
		
end  ADCsFilterLoops_arc;
	