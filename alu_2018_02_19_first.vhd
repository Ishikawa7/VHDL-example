-------------------------------------------------------------------------------
--
-- Title       : alu_2018_02_19(first)
-- Design      : Compito_2018_02_19_primo
-- Author      : Davide Grimaldi
-- Company     : Grimaldi's company
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Compito_2018_02_19_primo\Compito_2018_02_19_primo\src\alu_2018_02_19(first).vhd
-- Generated   : Thu Feb  7 12:45:27 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {alu_2018_02_19(first)} architecture {alu_2018_02_19(first)}}

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity alu_2018_02_19_first is
	 port(
		 clk : in STD_LOGIC;
		 start : in STD_LOGIC;
		 op : in STD_LOGIC_VECTOR(1 downto 0);
		 dataIn : in STD_LOGIC_VECTOR(15 downto 0);
		 finish : out STD_LOGIC;
		 output : out STD_LOGIC_VECTOR(31 downto 0)
	     );
end alu_2018_02_19_first;

--}} End of automatically maintained section

architecture alu_2018_02_19_first of alu_2018_02_19_first is
type machineState is (idle, readIR_A, readB, readC, exe2c, exe4c, exe6c);
signal currentState : machineState;
--next state function--
function nextStateFunction (currentState : machineState; start : std_logic; IR : std_logic_vector(1 downto 0); count : integer; A : std_logic_vector(15 downto 0)) return machineState is
	variable nextState : machineState;
	begin
		case currentState is
			when idle => if start = '1' then nextState := readIR_A; else nextState := idle; end if;
			when readIR_A => nextState := readB;
			when readB => case IR is
							when "00" | "01" => nextState := exe2c;
							when "10" => nextState := exe4c;
							when "11" => nextState := readC;
							when others => nextState := idle;
						  end case;
			when exe2c => if count < 1 then nextState := exe2c; else nextState := idle; end if;
			when readC => if conv_integer(A) = 0 then nextState := exe4c; else nextState := exe6c; end if;
			when exe4c => if count < 3 then nextState := exe4c; else nextState := idle; end if;
			when exe6c => if count < 5 then nextState := exe6c; else nextState := idle; end if;
		end case;
	return nextState;
end nextStateFunction;
-- alu output function--
function aluOut (A : std_logic_vector(15 downto 0); B : std_logic_vector(15 downto 0); C : std_logic_vector(15 downto 0); IR : std_logic_vector(1 downto 0)) return std_logic_vector is
	variable output : std_logic_vector(31 downto 0);
	begin
		case IR is
			when "01" => output(15 downto 0) := A + B;
				if output(15) = '0' then output(31 downto 16) := "0000000000000000"; else output(31 downto 16) := "1111111111111111"; end if;
			when "00" => output(15 downto 0) := A - B;
				if output(15) = '0' then output(31 downto 16) := "0000000000000000"; else output(31 downto 16) := "1111111111111111"; end if;
				-- output(31 downto 16) := (others => output(15));	--shortcut--
			when "10" => output := A * B;
			when "11" => if (conv_integer(A) = 0) then output := C * B; else output := (C * B) + conv_std_logic_vector(conv_integer(A),32); end if;
			when others => output(31 downto 0) := "00000000000000000000000000000000";	
		end case;
		return output;
end aluOut;
--enable signals--
signal enReadIR_A, enReadB, enReadC, enExe2c, enExe4c, enExe6c : std_logic;
--internal signals--
signal A, B, C : std_logic_vector(15 downto 0);
signal IR : std_logic_vector(1 downto 0);
signal count : integer range 0 to 5;
begin
-- CONTROL UNIT--
	process(clk)
		begin 
			if clk'event and clk = '0' then currentState <= nextStateFunction(currentState, start, IR, count, A); end if;
	end process;
	--control logic--
	enReadIR_A <= '1' when currentState = readIR_A else '0';
	enReadB <= '1' when currentState = readB else '0';
	enReadC <= '1' when currentState = readC else '0';
	enExe2c <= '1' when currentState = exe2c else '0';
	enExe4c <= '1' when currentState = exe4c else '0'; 
	enExe6c <= '1' when currentState = exe6c else '0';
--DATA PATH--
	process(clk)
		begin
			if clk'event and clk = '0' then
				finish <= '0';
				if enReadIR_A = '1' then IR <= op; A <= dataIn; count <= 0; end if;
				if enReadB = '1' then B <= dataIn; end if;
				if enReadC = '1' then C <= dataIn; end if;
				if (enExe2c = '1' and count = 1) or (enExe4c = '1' and count = 3) or (enExe6c = '1' and count = 5) then
					output <= aluOut(A, B, C, IR);
					finish <= '1';
					count <= 0;
				else if (enExe2c = '1' or enExe4c = '1' or enExe6c = '1') then count <= count + 1; end if;
				end if;
			end if;
	end process;
end alu_2018_02_19_first;
