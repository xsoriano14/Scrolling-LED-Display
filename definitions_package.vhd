library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package definitions_package is
    --package delclaration section
    --constant N : INTEGER := 8;
    type bus_width is array (0 to 7) of std_logic_vector(4 downto 0);
    type hex_array is array (0 to 7) of std_logic_vector (6 downto 0);
    type programA is array (0 to 17) of std_logic_vector(5 downto 0);
	type programB is array (0 to 10) of std_logic_vector(5 downto 0);
	constant prog1: programA:= ("000101", "000110", "000111", "001000", "001001", "001010", "001011", "001100", "001101", "001110", "001111", "010000", "010001", "010010", "010011", "010100", "010101", "010110");
	constant prog2: programB:= ("010111", "011000", "011001", "011010", "011011", "011100", "011101", "011110", "011111", "100000", "100001");
	constant prog3: programB:= ("100010", "100011", "100100", "100101", "100110", "100111", "101000", "101001", "101010", "101011", "101100");
    constant prog4: programA:= ("101101", "101110", "101111", "110000", "110001", "110010", "110011", "110100", "110101", "110110", "110111", "111000", "111001", "111010", "111011", "111100", "111101", "111110");
end package;

package body definitions_package is  
    --blank, include any implementations here, if necessary
end package body definitions_package;