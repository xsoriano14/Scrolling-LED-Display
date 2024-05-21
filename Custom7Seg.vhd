library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Custom7Seg is
    port (
        D: in std_logic_vector (4 downto 0); --input value
        Y: out std_logic_vector(6 downto 0) --output to 7seg display
    );
end Custom7Seg;

architecture rtl of Custom7Seg is

begin
    PROCESS (D) IS
	 BEGIN
        CASE D IS
        WHEN "00000" => Y <= "1111111"; -- all LEDS off
		WHEN "00001" => Y <= "0001001"; -- H
        WHEN "00010" => Y <= "0000110"; -- E
        WHEN "00011" => Y <= "1000111"; -- L/worm tail - moving forwards
        WHEN "00100" => Y <= "1000000"; -- O
        WHEN "00101" => Y <= "0101111"; -- r
        WHEN "00110" => Y <= "1111000"; -- 7/worm head - moving forwards
        WHEN "00111" => Y <= "1001000"; -- worm body
        WHEN "01000" => Y <= "1001110"; -- worm head - moving backwards
        WHEN "01001" => Y <= "1110001"; -- worm tail - moving backwards
        WHEN "01010" => Y <= "1111110"; -- LED 0 lit up
        WHEN "01011" => Y <= "1111101"; -- LED 1 lit up
        WHEN "01100" => Y <= "1111011"; -- LED 2 lit up
        WHEN "01101" => Y <= "1110111"; -- LED 3 lit up
        WHEN "01110" => Y <= "1101111"; -- LED 4 lit up
        WHEN "01111" => Y <= "1011111"; -- LED 5 lit up
        WHEN "10000" => Y <= "0111111"; -- LED 6 lit up
        WHEN "10001" => Y <= "0100011"; -- o
        WHEN "10010" => Y <= "0010010"; -- S
        WHEN "10011" => Y <= "0001000"; -- A
        WHEN "10100" => Y <= "0101011"; -- N
        WHEN OTHERS =>  Y <= "0000000"; -- all LEDS on
	    END CASE;	
    END PROCESS;
end architecture;