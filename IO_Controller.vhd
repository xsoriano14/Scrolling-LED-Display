library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions_package.all;

entity IO_Controller is
    port (
        toSeg : in bus_width;  --  bus_width and hex_array are custom datatypes defined in definitions_package
        to_hex: out hex_array   -- refer to definitions_package for more information about these types
    );
end IO_Controller;

architecture rtl of IO_Controller is
    component Custom7Seg is   --used Custom7Seg to display to decode values
        port (D: in std_logic_vector (4 downto 0);
		     Y: out std_logic_vector (6 downto 0)
		);
    end component;

begin
      --Custom7Seg reads values from ToSeg, decodes it and stores it in to_hex, which can be mapped to the HEX displays later
C7seg0 : Custom7Seg
    port map (D => toSeg(0), Y => to_hex(0));

    C7seg1 : Custom7Seg
    port map (D => toSeg(1), Y => to_hex(1));

    C7seg2 : Custom7Seg
    port map (D => toSeg(2), Y => to_hex(2));

    C7seg3 : Custom7Seg
    port map (D => toSeg(3), Y => to_hex(3));

    C7seg4 : Custom7Seg
    port map (D => toSeg(4), Y => to_hex(4));

    C7seg5 : Custom7Seg
    port map (D => toSeg(5), Y => to_hex(5));

    C7seg6 : Custom7Seg
    port map (D => toSeg(6), Y => to_hex(6));

    C7seg7 : Custom7Seg
    port map (D => toSeg(7), Y => to_hex(7));

end architecture;