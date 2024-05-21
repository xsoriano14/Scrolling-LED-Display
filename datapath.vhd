library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions_package.all;

entity datapath is
    port (clk : in std_logic; --clock input
		rst, hard_rst : in std_logic; --resets (active high)
		stop_prog, pause: in std_logic; --pause and stop (active low)
		program: in std_logic_vector(2 downto 0);	--switches to select program
		pce: out std_logic_vector(3 downto 0):= "0000"; --counts program exuction
		inst: out std_logic_vector(5 downto 0)	--sent to the ControlUnit
        );
end datapath;

architecture rtl of datapath is
	 
	COMPONENT Scheduler is
		port (clk : in std_logic; --clock
			rst, hard_rst: in std_logic; --switches: active high
			stop_prog, pause : in std_logic; --key: active low
			program : in std_logic_vector(2 downto 0); --input from switches
			pce : out std_logic := '0'; --pulses when program executes properly
			inst_out : out std_logic_vector(5 downto 0) := "000000" --program instructions sent to the ControlUnit
		);
	end COMPONENT;

	signal pulse : std_logic:= '0'; --start the pulse at 0
	signal counter : unsigned(3 downto 0):="0000";--increments with successful program execution

begin
	 
	Schedule: Scheduler --instantiate the Scheduler
	port map(clk => clk, rst => rst, hard_rst => hard_rst, stop_prog => stop_prog, pause => pause, program => program, pce => pulse, inst_out => inst);
	
	--Program Execution Counter--
	process(clk)
	begin
		if rising_edge(clk) then
			if hard_rst='1' then --if hard reset is triggered
				counter<="0000";	--reset the counter
			elsif pulse = '1' and pause = '1' then
				counter <=counter + "0001"; --otherwise increment by 1
		   	end if; --if hard_rst
		end if;	--end rising_edge(clk)
	end process; -- end (clk)
	
	pce<=std_logic_vector(counter);

end architecture;