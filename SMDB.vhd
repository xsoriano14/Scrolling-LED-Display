library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions_package.all;

entity SMDB is --interfaces with the FPGA
    port (CLOCK_50 : in std_logic;
        SW : in std_logic_vector (17 downto 0);
        KEY : in std_logic_vector (3 downto 0);
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : out std_logic_vector(6 downto 0);
        LEDG : out std_logic_vector(8 downto 0)
    );
end SMDB;

architecture top_level of SMDB is

    --Instatiations--
    component PreScale is --scales timing to 4 different modes
        port (
            clk: in std_logic;
            mode: in std_logic_vector(1 downto 0);
            clk_out: out std_logic
        );
    end component;

    component ASIP is --connects all the logic components
        port (
            clk : in std_logic;
            rst, hard_rst : in std_logic; --active high
            stop_prog, pause : in std_logic; --active low
            program: in std_logic_vector(2 downto 0);
            to_hex: out hex_array;
            pec: out std_logic_vector(3 downto 0)
        );
    end component;

    component debouncer is --ensures clean signals from keys and switches
		generic (timeout_cycles : integer := 5);
        port (
            clk : in std_logic;
            rst : in std_logic;
            switch : in std_logic;
            switch_debounced : out std_logic
        );
    end component;

    signal speed_ctrl: std_logic_vector(1 downto 0); --mode selector from switches to PreScale
    signal stop_prog, pause : std_logic; --user controls mapped to the keys
    signal rst, hard_rst : std_logic; --user controls mapped to the switches
    signal scaled_clk : std_logic;    --scaled clock from PreScaler to ASIP
    signal hexID : hex_array; --array of outputs send to the HEX displays
    signal reset : std_logic; --reset input for the debouncers

begin
    --assign reset key for debouncers
    reset <= NOT KEY(1);
    --instantiate prescaler
    PreScaler: PreScale
    port map (clk => CLOCK_50, clk_out => scaled_clk, mode => speed_ctrl);
    --instantiate ASIP
    Top_Level : ASIP
    port map (clk => scaled_clk, rst => rst, hard_rst => hard_rst, stop_prog => stop_prog, pause => pause, program => SW(2 downto 0), to_hex => hexID, pec => LEDG(3 downto 0));    
    --instantiate debouncers
    Speed4SW : debouncer
    port map (clk => CLOCK_50, rst => reset, switch => SW(4), switch_debounced=> speed_ctrl(0));
	 Speed5SW : debouncer
    port map (clk => CLOCK_50, rst => reset, switch => SW(5), switch_debounced=> speed_ctrl(1));
    PauseKey : debouncer
    port map (clk => CLOCK_50, rst => reset, switch => KEY(3), switch_debounced=> pause);
    StopKey : debouncer
    port map (clk => CLOCK_50, rst => reset, switch => KEY(2), switch_debounced=> stop_prog);
    ResetSW : debouncer
    port map (clk => CLOCK_50, rst => reset, switch => SW(17), switch_debounced=> rst);
    Hard_ResetSW : debouncer
    port map (clk => CLOCK_50, rst => reset, switch => SW(16), switch_debounced=> hard_rst);
    --connect array from ASIP to the HEX displays
    HEX0 <= hexID(0);
    HEX1 <= hexID(1);
    HEX2 <= hexID(2);
    HEX3 <= hexID(3);
    HEX4 <= hexID(4);
    HEX5 <= hexID(5);
    HEX6 <= hexID(6);
    HEX7 <= hexID(7);

end architecture;