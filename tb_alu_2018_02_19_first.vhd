-------------------------------------------------------------------------------
--
-- Title       : tb_alu_2018_02_19_first
-- Design      : Compito_2018_02_19_primo
-- Author      : Davide Grimaldi
-- Company     : Grimaldi's company
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\Compito_2018_02_19_primo\Compito_2018_02_19_primo\src\tb_alu_2018_02_19_first.vhd
-- Generated   : Fri Feb  8 10:26:54 2019
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
--{entity {tb_alu_2018_02_19_first} architecture {tb_alu_2018_02_19_first}}
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


entity tb_alu_2018_02_19_first is
end tb_alu_2018_02_19_first;

--}} End of automatically maintained section

architecture tb_alu_2018_02_19_first of tb_alu_2018_02_19_first is
component alu_2018_02_19_first is
		port(
		 clk : in STD_LOGIC;
		 start : in STD_LOGIC;
		 op : in STD_LOGIC_VECTOR(1 downto 0);
		 dataIn : in STD_LOGIC_VECTOR(15 downto 0);
		 finish : out STD_LOGIC;
		 output : out STD_LOGIC_VECTOR(31 downto 0)
	     );
	end component;
signal clk, start, finish : std_logic;
signal op : std_logic_vector(1 downto 0);
signal dataIn : std_logic_vector(15 downto 0);
signal output : std_logic_vector(31 downto 0);
begin
	dut : alu_2018_02_19_first port map (clk, start, op, dataIn, finish, output);
	process 
		begin
		clk <= '0'; wait for 5 ns;
		clk <= '1'; wait for 5 ns;
	end process;
	start <= 
			'1' after 1 ns, '0' after 11 ns,
			'1' after 91 ns, '0' after 101 ns,
			'1' after 181 ns, '0' after 191 ns,
			'1' after 271 ns, '0' after 281 ns,
			'1' after 371 ns, '0' after 381 ns;
	op <= 
			"00" after 11 ns, --SUB--
			"01" after 91 ns, --ADD--
			"10" after 181 ns, --MULT--
			"11" after 271 ns; --MAC (1 & 2)--
	dataIn <=
			--SUB--
			conv_std_logic_vector(10,16) after 11 ns,
			conv_std_logic_vector(7,16) after 21 ns,
			--ADD--
			conv_std_logic_vector(4,16) after 101 ns,
			conv_std_logic_vector(5,16) after 111 ns,
			--MULT--
			conv_std_logic_vector(2,16) after 191 ns,
			conv_std_logic_vector(2,16) after 201 ns,
			--MAC 1--
			conv_std_logic_vector(1,16) after 281 ns,
			conv_std_logic_vector(3,16) after 291 ns,
			conv_std_logic_vector(3,16) after 301 ns,
			--MAC 2--
			conv_std_logic_vector(0,16) after 381 ns,
			conv_std_logic_vector(3,16) after 391 ns,
			conv_std_logic_vector(3,16) after 401 ns;
			
end tb_alu_2018_02_19_first;
