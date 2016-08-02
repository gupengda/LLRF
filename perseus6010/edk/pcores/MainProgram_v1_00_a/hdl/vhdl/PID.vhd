
---File PID.vhd;----
--- Modified 9th August 2011 --> line 72 --> ErrorKi <= ErrorVble*Ki;			

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY PID IS

	PORT ( Input : in std_logic_vector (15 downto 0);
			 LoopEnable : in std_logic;
			 Gain_OL : in std_logic_vector (7 downto 0);
			 Ref : in std_logic_vector (15 downto 0);
			 Kp : in std_logic_vector(15 downto 0);
			 Ki : in std_logic_vector(15 downto 0);
			 Error : out std_logic_vector(15 downto 0);
			 ErrorAccumOut : out std_logic_vector (15 downto 0);
			 ResetKi : in std_logic;
			 IntLimit : in std_logic_vector (15 downto 0);
			 Control : out std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 ForwardMin : in std_logic);
			 
END PID;

ARCHITECTURE PID_arc OF PID is

--Signals declaration

signal ErrorKp31 : std_logic_vector (31 downto 0);
signal ErrorKp : std_logic_vector (15 downto 0);

signal ErrorKi : std_logic_vector (31 downto 0);
signal ErrorKi_40b : std_logic_vector (39 downto 0);

signal ErrorAccumLatch : std_logic_vector (39 downto 0);
signal ErrorAccum : std_logic_vector (39 downto 0);

signal Error_sig : std_logic_vector (15 downto 0);

signal Ref_OL : std_logic_vector (15 downto 0);

signal LoopSaturation, LoopSaturation_latch : std_logic_vector (15 downto 0);

-- components declaration
component Gain_OL_CL is
    Port ( Input_OL_CL : in  STD_LOGIC_VECTOR (15 downto 0);
           Gain : in  STD_LOGIC_VECTOR (7 downto 0);
           Output_OL_CL : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC);
end component Gain_OL_CL;



begin

inst_gain_OL : component Gain_OL_CL
	Port map(Input_OL_CL => Ref,
           Gain => Gain_OL,
           Output_OL_CL => Ref_OL,
           clk => clk);


	
	process(clk)
		
		variable ErrorVble : std_logic_vector (15 downto 0);
		variable ErrorAccumVble : std_logic_vector (31 downto 0);
		variable ControlVble : std_logic_vector (15 downto 0);
		variable LoopSaturationVble : std_logic_vector (16 downto 0);
		
	begin
		if(clk'EVENT and clk = '1') then
			
			if(ForwardMin = '0')then
				ErrorVble := (others => '0'); -- If there is no forward power feeding the cavity, the PID loop stops accumulating signal to avoid overdrive when there is no power
			else 
				ErrorVble := Ref + not(Input) + 1;
			end if;
			
			Error <= ErrorVble;
			Error_sig <= ErrorVble;
			
			ErrorKp31 <= Error_sig*kp;
			ErrorKp <= ErrorKp31(23 downto 8); -- 8LSB of Kp = decimal part
			
			ErrorKi <= Error_sig*Ki;	
			ErrorKi_40b <= ErrorKi(31)&ErrorKi(31)&ErrorKi(31)&ErrorKi(31)&ErrorKi(31)&ErrorKi(31)&ErrorKi(31)&ErrorKi(31)&ErrorKi;
			
			if(ResetKi = '1') then
				ErrorAccum <= (others => '0');
			elsif(LoopEnable ='0') then
				ErrorAccum <= Ref_OL&X"000000";
			elsif(ErrorAccum > IntLimit&X"000000") then
				ErrorAccum <= IntLimit&X"000000";
			elsif(ErrorAccum < not(IntLimit&X"000000")) then
				ErrorAccum <= not(IntLimit&X"000000");
			else
				ErrorAccum <= ErrorAccum + ErrorKi_40b;				
			end if;
			
				ErrorAccumOut <= ErrorAccum(39 downto 24);
				ErrorAccumLatch <= ErrorAccum;
							
				
			LoopSaturation <= ErrorKp + ErrorAccumLatch(39 downto 24);
			LoopSaturation_latch <= LoopSaturation;
			
					
		
			if(LoopEnable = '0') then
				ControlVble := Ref_OL;
			elsif(LoopSaturation(15 downto 14) = not(LoopSaturation_latch(15 downto 14))) then
				ControlVble := ErrorAccumLatch(39 downto 24);
			else
				ControlVble := ErrorKp + ErrorAccumLatch(39 downto 24);
			end if;
			
			
			
			Control <= ControlVble;
			
	
		end if;
	end process;
	

	
end PID_arc;

