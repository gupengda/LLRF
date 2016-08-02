----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A. Salom 
-- 
-- Create Date:    12:22:00 06/30/2012 
-- Design Name: 
-- Module Name:    CordicRect2Polar - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CordicRect2Polar is
    Port ( I_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           Amp_out : out  STD_LOGIC_VECTOR (16 downto 0);
           Ph_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  id_in : in std_logic_vector (3 downto 0);
			  id_out : out std_logic_vector (3 downto 0));
end CordicRect2Polar;

architecture Behavioral of CordicRect2Polar is
-- signals declaration
signal Amp_out_sig, Q_out : std_logic_vector (17 downto 0) := "00"&X"0000";
signal Amp_int : std_logic_vector (33 downto 0);
signal ph_int, ph_out_sig : std_logic_vector (15 downto 0);
signal I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15 : std_logic_vector (17 downto 0):= "00"&X"0000";
signal Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15 : std_logic_vector (17 downto 0):= "00"&X"0000";
signal ph0, ph1, ph2, ph3, ph4, ph5, ph6, ph7, ph8, ph9, ph10, ph11, ph12, ph13, ph14, ph15 : std_logic_vector (15 downto 0):= X"0000";
signal id0, id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, id11, id12, id13, id14, id15, id16, id0l : std_logic_vector (3 downto 0):= "0000";
signal I0L, Q0L : std_logic_vector (17 downto 0):= "00"&X"0000";

-- components declaration

component CordicRect2PolarIteration_0 is
    Port ( I_in : in  STD_LOGIC_VECTOR (17 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (17 downto 0);
           Ph_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  ph_cordic : in std_logic_vector (15 downto 0);
           clk : in  STD_LOGIC;
           I_out : out  STD_LOGIC_VECTOR (17 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (17 downto 0);
           ph_out : out  STD_LOGIC_VECTOR (15 downto 0));
end component CordicRect2PolarIteration_0;

component CordicRect2PolarIteration is
    Port ( I_in : in  STD_LOGIC_VECTOR (17 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (17 downto 0);
           Ph_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  ph_cordic : in std_logic_vector (15 downto 0);
           clk : in  STD_LOGIC;
           stage : in integer range 1 to 15;
           I_out : out  STD_LOGIC_VECTOR (17 downto 0);
           Q_out : out  STD_LOGIC_VECTOR (17 downto 0);
           ph_out : out  STD_LOGIC_VECTOR (15 downto 0));
end component CordicRect2PolarIteration;


begin

process (clk)
variable I1_vble, Q1_vble : std_logic_vector (17 downto 0);
variable ph1_vble : std_logic_vector (15 downto 0);

begin 
	if(clk = '1' and clk'EVENT) then
		I0 <= I_In(15)&I_In(15)&I_in; -- To compensate saturation due to cordic gain
		Q0 <= Q_in(15)&Q_in(15)&Q_in; -- to compensate saturation due to cordic gain
		
		I0L <= I0;
		Q0L <= Q0;
		
		id0 <= id_in;
		id0l <= id0;
		id1 <= id0l;
		id2 <= id1;
		id3 <= id2;
		id4 <= id3;
		id5 <= id4;
		id6 <= id5;
		id7 <= id6;
		id8 <= id7;
		id9 <= id8;
		id10 <= id9;
		id11 <= id10;
		id12 <= id11;
		id13 <= id12;
		id14 <= id13;
		id15 <= id14;
		id16 <= id15;
		id_out <= id16;
		
		if(I0(17) = '1' and Q0(17) = '1') then
			I1_vble := not(I0) + 1;
			Q1_vble := not(Q0) + 1;
			ph1_vble := X"8000";
		elsif(I0(17) = '1') then
			I1_vble := Q0;
			Q1_vble := not(I0) + 1;
			ph1_vble := X"4000";
		elsif (Q0(17)='1') then
			I1_vble := not(Q0) + 1;
			Q1_vble := I0;
			ph1_vble := X"C000";
		else
			I1_vble := I0;
			Q1_vble := Q0;
			ph1_vble := X"0000";
		end if;
		I1 <= I1_vble;
		Q1 <= Q1_vble;
		ph1 <= ph1_vble;
		Amp_int <= Amp_out_sig*X"4DBA";
		Amp_out <= Amp_int(31 downto 15);
		ph_int <= ph_out_sig;
		ph_out <= ph_int;
		
		
		
end if;
end process;

inst1 : component CordicRect2PolarIteration_0
    Port map( I_in => I1,
           Q_in => Q1,
           Ph_in => ph1, 
			  ph_cordic => X"2000",
           clk => clk,
           I_out => I2,
           Q_out => Q2,
           ph_out => ph2);


inst2 : component CordicRect2PolarIteration
    Port map( I_in => I2,
           Q_in => Q2,
           Ph_in => ph2, 
			  ph_cordic => X"12E4",
           clk => clk,
           stage => 1,
           I_out => I3,
           Q_out => Q3,
           ph_out => ph3);
			  
inst3 : component CordicRect2PolarIteration 
    Port map( I_in => I3,
           Q_in => Q3,
           Ph_in => ph3, 
			  Ph_cordic => X"09FB",
           clk => clk,
           stage => 2,
           I_out => I4,
           Q_out => Q4,
           ph_out => ph4);
			  
inst4 : component CordicRect2PolarIteration 
    Port map( I_in => I4,
           Q_in => Q4,
           Ph_in => ph4, 
			  Ph_cordic => X"0511",
           clk => clk,
           stage => 3,
           I_out => I5,
           Q_out => Q5,
           ph_out => ph5);
			  
inst5 : component CordicRect2PolarIteration 
    Port map( I_in => I5,
           Q_in => Q5,
           Ph_in => ph5, 
			  Ph_cordic => X"028B",
           clk => clk,
           stage => 4,
           I_out => I6,
           Q_out => Q6,
           ph_out => ph6);
			  
inst6 : component CordicRect2PolarIteration 
    Port map( I_in => I6,
           Q_in => Q6,
           Ph_in => ph6, 
			  Ph_cordic => X"0146",
           clk => clk,
           stage => 5,
           I_out => I7,
           Q_out => Q7,
           ph_out => ph7);
			  
inst7 : component CordicRect2PolarIteration 
    Port map( I_in => I7,
           Q_in => Q7,
           Ph_in => ph7, 
			  Ph_cordic => X"00A3",
           clk => clk,
           stage => 6,
           I_out => I8,
           Q_out => Q8,
           ph_out => ph8);
			  
inst8 : component CordicRect2PolarIteration 
    Port map( I_in => I8,
           Q_in => Q8,
           Ph_in => ph8, 
			  Ph_cordic => X"0051",
           clk => clk,
           stage => 7,
           I_out => I9,
           Q_out => Q9,
           ph_out => ph9);
			  
inst9 : component CordicRect2PolarIteration 
    Port map( I_in => I9,
           Q_in => Q9,
           Ph_in => ph9, 
			  Ph_cordic => X"0029",
           clk => clk,
           stage => 8,
           I_out => I10,
           Q_out => Q10,
           ph_out => ph10);
			  
inst10 : component CordicRect2PolarIteration 
    Port map( I_in => I10,
           Q_in => Q10,
           Ph_in => ph10, 
			  Ph_cordic => X"0014",
           clk => clk,
           stage => 9,
           I_out => I11,
           Q_out => Q11,
           ph_out => ph11);
			  
inst11 : component CordicRect2PolarIteration 
    Port map( I_in => I11,
           Q_in => Q11,
           Ph_in => ph11, 
			  Ph_cordic => X"000A",
           clk => clk,
           stage => 10,
           I_out => I12,
           Q_out => Q12,
           ph_out => ph12);
			  
inst12 : component CordicRect2PolarIteration
    Port map( I_in => I12,
           Q_in => Q12,
           Ph_in => ph12, 
			  Ph_cordic => X"0005",
           clk => clk,
           stage => 11,
           I_out => I13,
           Q_out => Q13,
           ph_out => ph13);
			  
inst13 : component CordicRect2PolarIteration 
    Port map( I_in => I13,
           Q_in => Q13,
           Ph_in => ph13, 
			  Ph_cordic => X"0003",
           clk => clk,
           stage => 12,
           I_out => I14,
           Q_out => Q14,
           ph_out => ph14);
			  
inst14 : component CordicRect2PolarIteration 
    Port map( I_in => I14,
           Q_in => Q14,
           Ph_in => ph14, 
			  Ph_cordic => X"0001",
           clk => clk,
           stage => 13,
           I_out => I15,
           Q_out => Q15,
           ph_out => ph15);
			  
inst15 : component CordicRect2PolarIteration 
    Port map( I_in => I15,
           Q_in => Q15,
           Ph_in => ph15, 
			  Ph_cordic => X"0001",
           clk => clk,
           stage => 14,
           I_out => Amp_Out_sig,
           Q_out => Q_Out,
           ph_out => ph_Out_sig);		  



end Behavioral;

