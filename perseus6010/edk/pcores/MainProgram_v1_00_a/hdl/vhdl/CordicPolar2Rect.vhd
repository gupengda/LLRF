---File CordicPolar2Rect.vhd;----

library ieee, work;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY CordicPolar2Rect IS

	PORT ( Amp_In : in std_logic_vector (15 downto 0);
			 Ph_In : in std_logic_vector (15 downto 0);
			 clk : in std_logic;
			 I_Out : out std_logic_vector (15 downto 0);
			 Q_out : out std_logic_vector (15 downto 0);
			 id_in : in std_logic_vector (4 downto 0);
			 id_out : out std_logic_vector (4 downto 0));
			 
END CordicPolar2Rect;

ARCHITECTURE CordicPolar2Rect_arc OF CordicPolar2Rect is
	signal I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14 : std_logic_vector (15 downto 0);
	signal Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14 : std_logic_vector (15 downto 0);
	signal ph0, ph1, ph2, ph3, ph4, ph5, ph6, ph7, ph8, ph9, ph10, ph11, ph12, ph13, ph14, ph15 : std_logic_vector (15 downto 0);
	signal phref0, phref1, phref2, phref3, phref4, phref5, phref6, phref7, phref8, phref9, phref10, phref11, phref12, phref13, phref14 : std_logic_vector (15 downto 0);
	signal id0,  id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, id11, id12, id13, id14, id15, id_inl : std_logic_vector (4 downto 0);
	
	component CordicPolar2RectIteration is
	port (Ph_ref : in  STD_LOGIC_VECTOR (15 downto 0);
           Ph_in : in  STD_LOGIC_VECTOR (15 downto 0);
           I_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (15 downto 0);
           I_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Q_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Ph_out : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  phase_cordic : in std_logic_vector (15 downto 0);
			  stage : in integer range 1 to 15);
	end component CordicPolar2RectIteration;
	
	component CordicPolar2RectIteration_0 is
    Port ( Ph_ref : in  STD_LOGIC_VECTOR (15 downto 0);
           Ph_in : in  STD_LOGIC_VECTOR (15 downto 0);
           I_in : in  STD_LOGIC_VECTOR (15 downto 0);
           Q_in : in  STD_LOGIC_VECTOR (15 downto 0);
           I_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Q_Out : out  STD_LOGIC_VECTOR (15 downto 0);
           Ph_out : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
			  phase_cordic : in std_logic_vector (15 downto 0));
	end component CordicPolar2RectIteration_0;
	
BEGIN
process(clk)
variable I0_vble, Q0_vble, ph0_vble : std_logic_vector (15 downto 0);
Begin
	if (clk'EVENT and clk = '1') then
		if(Ph_In < X"C001") then
			I0_vble := (others => '0');
			Q0_vble := not(Amp_In) + 1;
			ph0_vble := X"C000";
		elsif (Ph_In > X"3FFF") then
			I0_vble := (others => '0');
			Q0_vble := Amp_In;
			ph0_vble := X"4000";
		else
			I0_vble := Amp_In;
			Q0_vble := (others => '0');
			ph0_vble := (others => '0');
		end if;
		
		I0 <= I0_vble;
		Q0 <= Q0_vble;
		ph0 <= ph0_vble;
		
		id0 <= id_in;
		id1 <= id0;
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
		id_out <= id14;
		
		phref0 <= ph_in;
		phref1 <= phref0;
		phref2 <= phref1;
		phref3 <= phref2;
		phref4 <= phref3;
		phref5 <= phref4;
		phref6 <= phref5;
		phref7 <= phref6;
		phref8 <= phref7;
		phref9 <= phref8;
		phref10 <= phref9;
		phref11 <= phref10;
		phref12 <= phref11;
		phref13 <= phref12;
		phref14 <= phref13;
		
	end if;
end process;	

Cord_stage1 : component CordicPolar2RectIteration_0
	Port map( Ph_ref => Phref0,
           Ph_in => ph0,
           I_in => I0,
           Q_in => Q0,
           I_Out => I1,
           Q_Out => Q1,
           Ph_out => ph1,
           clk => clk,
			  phase_cordic => X"2000");
	
Cord_stage2 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref1,
           Ph_in => ph1,
           I_in => I1,
           Q_in => Q1,
           I_Out => I2,
           Q_Out => Q2,
           Ph_out => ph2,
           clk => clk,
			  phase_cordic => X"12E4",
			  stage => 1);
	
Cord_stage3 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref2,
           Ph_in => ph2,
           I_in => I2,
           Q_in => Q2,
           I_Out => I3,
           Q_Out => Q3,
           Ph_out => ph3,
           clk => clk,
			  phase_cordic => X"09FB",
			  stage => 2);
	
Cord_stage4 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref3,
           Ph_in => ph3,
           I_in => I3,
           Q_in => Q3,
           I_Out => I4,
           Q_Out => Q4,
           Ph_out => ph4,
           clk => clk,
			  phase_cordic => X"0511",
			  stage => 3);
	
Cord_stage5 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref4,
           Ph_in => ph4,
           I_in => I4,
           Q_in => Q4,
           I_Out => I5,
           Q_Out => Q5,
           Ph_out => ph5,
           clk => clk,
			  phase_cordic => X"028B",
			  stage => 4);
	
Cord_stage6 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref5,
           Ph_in => ph5,
           I_in => I5,
           Q_in => Q5,
           I_Out => I6,
           Q_Out => Q6,
           Ph_out => ph6,
           clk => clk,
			  phase_cordic => X"0146",
			  stage => 5);
	
Cord_stage7 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref6,
           Ph_in => ph6,
           I_in => I6,
           Q_in => Q6,
           I_Out => I7,
           Q_Out => Q7,
           Ph_out => ph7,
           clk => clk,
			  phase_cordic => X"00A3",
			  stage => 6);
	
Cord_stage8 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref7,
           Ph_in => ph7,
           I_in => I7,
           Q_in => Q7,
           I_Out => I8,
           Q_Out => Q8,
           Ph_out => ph8,
           clk => clk,
			  phase_cordic => X"0051",
			  stage => 7);
	
Cord_stage9 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref8,
           Ph_in => ph8,
           I_in => I8,
           Q_in => Q8,
           I_Out => I9,
           Q_Out => Q9,
           Ph_out => ph9,
           clk => clk,
			  phase_cordic => X"0029",
			  stage => 8);
	
Cord_stage10 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref9,
           Ph_in => ph9,
           I_in => I9,
           Q_in => Q9,
           I_Out => I10,
           Q_Out => Q10,
           Ph_out => ph10,
           clk => clk,
			  phase_cordic => X"0014",
			  stage => 9);
	
Cord_stage11 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref10,
           Ph_in => ph10,
           I_in => I10,
           Q_in => Q10,
           I_Out => I11,
           Q_Out => Q11,
           Ph_out => ph11,
           clk => clk,
			  phase_cordic => X"000A",
			  stage => 10);
	
Cord_stage12 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref11,
           Ph_in => ph11,
           I_in => I11,
           Q_in => Q11,
           I_Out => I12,
           Q_Out => Q12,
           Ph_out => ph12,
           clk => clk,
			  phase_cordic => X"0005",
			  stage => 11);
	
Cord_stage13 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref12,
           Ph_in => ph12,
           I_in => I12,
           Q_in => Q12,
           I_Out => I13,
           Q_Out => Q13,
           Ph_out => ph13,
           clk => clk,
			  phase_cordic => X"0003",
			  stage => 12);
	
Cord_stage14 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref13,
           Ph_in => ph13,
           I_in => I13,
           Q_in => Q13,
           I_Out => I14,
           Q_Out => Q14,
           Ph_out => ph14,
           clk => clk,
			  phase_cordic => X"0001",
			  stage => 13);
	
Cord_stage15 : component CordicPolar2RectIteration 
	Port map( Ph_ref => Phref14,
           Ph_in => ph14,
           I_in => I14,
           Q_in => Q14,
           I_Out => I_Out,
           Q_Out => Q_Out,
           Ph_out => ph15,
           clk => clk,
			  phase_cordic => X"0001",
			  stage => 14);
	
	
end  CordicPolar2Rect_arc;
	