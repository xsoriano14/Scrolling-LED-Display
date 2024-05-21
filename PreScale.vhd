library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PreScale is
 port (clk: in std_logic;
		mode: in std_logic_vector(1 downto 0);
		clk_out: out std_logic
	);
end entity;

architecture behaviour of PreScale is
	signal normal: unsigned(23 downto 0):= "000000000000000000000000";
	signal slow: unsigned(25 downto 0):= "00000000000000000000000000";
	signal fast: unsigned(21 downto 0):= "0000000000000000000000";
	signal very_fast: unsigned(19 downto 0):= "00000000000000000000";
begin
	process(clk, mode)
	begin
		if mode="00" then
			if rising_edge(clk) then
				normal <= normal + 1;
			end if;
			clk_out <= std_logic(normal(23));
		elsif mode="01" then
			if rising_edge(clk) then
				slow <= slow + 1;
			end if;
			clk_out <= std_logic(slow(25));
		elsif mode="10" then
			if rising_edge(clk) then
				fast <= fast + 1;
			end if;
			clk_out <= std_logic(fast(21));
		else
			if rising_edge(clk) then
				very_fast <= very_fast + 1;
			end if;
			clk_out <= std_logic(very_fast(19));
		end if;	
	end process;
end behaviour;