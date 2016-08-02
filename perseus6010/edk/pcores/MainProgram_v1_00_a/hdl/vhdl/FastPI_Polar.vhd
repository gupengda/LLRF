
---File PI_Polar.vhd;----	

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY FastPI_Polar IS

	PORT ( Input : in std_logic_vector (15 downto 0);
			 LoopEnable : in std_logic;
			 Ref : in std_logic_vector (15 downto 0);
			 Kp : in std_logic_vector(15 downto 0);
			 Ki : in std_logic_vector(15 downto 0);
			 Error : out std_logic_vector(15 downto 0);
			 ErrorAccumOut : out std_logic_vector (15 downto 0);
			 IntLimit : in std_logic_vector (15 downto 0);
			 Control : out std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 ForwardMin : in std_logic);
			 
END FastPI_Polar;

ARCHITECTURE PID_arc OF FastPI_Polar is

--Signals declaration

signal ErrorKp31 : std_logic_vector (31 downto 0);
signal ErrorKp : std_logic_vector (15 downto 0);

signal ErrorKi : std_logic_vector (31 downto 0);

signal ErrorAccumLatch : std_logic_vector (31 downto 0);
signal ErrorAccum : std_logic_vector (31 downto 0);

signal Error_sig : std_logic_vector (15 downto 0);

signal LoopSaturation, LoopSaturation_latch : std_logic_vector (15 downto 0);

-- components declaration



begin
	
	process(clk)
		
		variable ErrorVble : std_logic_vector (15 downto 0);
		variable ErrorAccumVble : std_logic_vector (31 downto 0);
		variable ControlVble : std_logic_vector (15 downto 0);
		variable LoopSaturationVble : std_logic_vector (16 downto 0);
		
	begin
		if(clk'EVENT and clk = '1') then
			
			if(ForwardMin = '1')then
				ErrorVble := Ref + not(Input) + 1;
			else 
				ErrorVble := (others => '0');
			end if;
			
			Error <= ErrorVble;
			Error_sig <= ErrorVble;
			
			ErrorKp31 <= Error_sig*kp;
			ErrorKp <= ErrorKp31(23 downto 8); -- 8LSB of Kp = decimal part
			
			ErrorKi <= Error_sig*Ki;			
			
	
			ErrorAccum <= ErrorAccum + ErrorKi;
			
			ErrorAccumOut <= ErrorAccum(31 downto 16);
					
		
			if(LoopEnable = '0') then
				ControlVble := Ref;
			else
				ControlVble := ErrorKp + ErrorAccum(31 downto 16);
			end if;
			
			
			
			Control <= ControlVble;
			
	
		end if;
	end process;
	

	
end PID_arc;

