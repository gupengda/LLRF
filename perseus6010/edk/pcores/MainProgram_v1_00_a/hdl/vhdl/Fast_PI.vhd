
---File Fast_PI.vhd;----
--- Modified 9th August 2011 --> line 72 --> ErrorKi <= ErrorVble*Ki;			

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY Fast_PI IS

	PORT ( Input : in std_logic_vector (15 downto 0);
			 LoopEnable : in std_logic;
			 Ref : in std_logic_vector (15 downto 0);
			 Kp : in std_logic_vector(15 downto 0);
			 Ki : in std_logic_vector(15 downto 0);
			 IntLimit : in std_logic_vector(15 downto 0);
			 Error : out std_logic_vector(15 downto 0);
			 ErrorAccumOut : out std_logic_vector (15 downto 0);
			 Control : out std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 ForwardMin : in std_logic);
			 
END Fast_PI;

ARCHITECTURE Fast_PI_arc OF Fast_PI is

--Signals declaration

signal ErrorKp31 : std_logic_vector (31 downto 0);
signal ErrorKp : std_logic_vector (15 downto 0);

signal ErrorKi : std_logic_vector (31 downto 0);

signal ErrorAccumLatch : std_logic_vector (31 downto 0);
signal ErrorAccum : std_logic_vector (31 downto 0);

signal Error_sig : std_logic_vector (15 downto 0);

signal LoopSaturation, LoopSaturation_latch : std_logic_vector (15 downto 0);



begin

	process(clk)
		
		variable ErrorVble : std_logic_vector (15 downto 0);
		variable ControlVble : std_logic_vector (15 downto 0);
		
	begin
		if(clk'EVENT and clk = '1') then
			
--			if(ForwardMin = '0')then
--				ErrorVble := (others => '0'); -- If there is no forward power feeding the cavity, the Fast_PI loop stops accumulating signal to avoid overdrive when there is no power
--			else 
--				ErrorVble := Ref + not(Input) + 1;
--			end if;
			
			Error_sig <= Ref + not(Input) + 1;
			Error <= Error_sig;

			
			ErrorKp31 <= Error_sig*kp;
			ErrorKp <= ErrorKp31(23 downto 8); -- 8LSB of Kp = decimal part
			
			ErrorKi <= Error_sig*Ki;				
			
			if(LoopEnable ='0' or ForwardMin = '0') then
				ErrorAccum <= (others => '0');
			elsif(ErrorAccum > IntLimit&X"0000") then
				ErrorAccum <= IntLimit&X"0000";
			elsif(ErrorAccum < not(IntLimit&X"0000")) then
				ErrorAccum <= not(IntLimit&X"0000");
			else
				ErrorAccum <= ErrorAccum + ErrorKi;
			end if;
			
				ErrorAccumOut <= ErrorAccum(31 downto 16);
				ErrorAccumLatch <= ErrorAccum;
							
				
			LoopSaturation <= ErrorKp + ErrorAccumLatch(31 downto 16);
			LoopSaturation_latch <= LoopSaturation;
			
					
		
			if(LoopEnable = '0') then
				ControlVble := (others => '0');
			elsif(LoopSaturation(15 downto 14) /= LoopSaturation_latch(15 downto 14)) then
				ControlVble := ErrorAccumLatch(31 downto 16);
			else
				ControlVble := ErrorKp + ErrorAccumLatch(31 downto 16);
			end if;
			
			
			
			Control <= ControlVble;
			
	
		end if;
	end process;
	

	
end Fast_PI_arc;

