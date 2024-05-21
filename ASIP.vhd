library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions_package.all;

entity ASIP is
    port (
        clk : in std_logic;
        rst, hard_rst : in std_logic; --active high
        stop_prog, pause : in std_logic; --active low
        program: in std_logic_vector(2 downto 0);
        to_hex: out hex_array;
        pec: out std_logic_vector(3 downto 0)
    );
end ASIP;

architecture rtl of ASIP is

component ControlUnit is
    port (
        clk : in std_logic;
        rst : in std_logic;
        hard_rst : in std_logic;
		ToSeg: out bus_width;
        inst : in std_logic_vector(5 downto 0)
    );
end component;

component datapath is
    port (clk : in std_logic; --clock input
		rst, hard_rst : in std_logic; --resets (active high)
		stop_prog, pause: in std_logic; --pause and stop (active low)
		program: in std_logic_vector(2 downto 0);	--switches to select program
		pce: out std_logic_vector(3 downto 0):= "0000"; --counts program exuction
		inst: out std_logic_vector(5 downto 0)	--sent to the ControlUnit
        );
end component;

component IO_Controller is
    port (
        toSeg : in bus_width;
        to_hex: out hex_array
    );
end component;

    signal inst_out : std_logic_vector(5 downto 0) := "000000";
	signal segID: bus_width:=("00000","00000","00000","00000","00000","00000","00000","00000");

begin

    ProgramControl: ControlUnit 
    port map(clk=> clk, rst=> rst, hard_rst=> hard_rst, inst => inst_out, toSeg => segID);

    OutputControl: IO_Controller 
    port map(toSeg=>segID, to_hex=>to_hex);
	 
	 Data: Datapath 
	 port map(clk=>clk,rst=>rst, hard_rst=>hard_rst, stop_prog=>stop_prog, pause => pause, program => program, inst => inst_out, pce => pec);

end architecture;