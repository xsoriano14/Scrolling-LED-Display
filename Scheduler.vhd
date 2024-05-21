library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
USE work.definitions_package.all;

entity Scheduler is
	port (clk : in std_logic; 
		rst, hard_rst: in std_logic; --switches: active high
		stop_prog, pause : in std_logic; --key: active low
		program : in std_logic_vector(2 downto 0); --input from switches
		pce : out std_logic := '0'; --pulses when program 
		inst_out : out std_logic_vector(5 downto 0) := "000000"
	);
end Scheduler;

architecture behaviour of Scheduler is
	type RUNNER is (IDLE, RUNNING);
	signal present, next_state: RUNNER;
	type PROGRAMMER is (HOLD, P1, P2, P3, P4, ERROR);
	signal pst, nst: PROGRAMMER;
	signal start: std_logic := '0'; --0 for staying, 1 for switching FSMs
	signal done: std_logic := '1';
	signal counter: integer := 0;

begin
	--RUNNER SEQUENTIAL--
	process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' OR hard_rst = '1' then
				present <= IDLE;
			else
				present <= next_state;
			end if;
		end if;
	end process;
	
	--RUNNER COMBINATIONAL--
	process (program, present, done, rst, hard_rst)
	begin
		if rst = '1' or hard_rst = '1' then
			start <= '0';
			--next_state <= IDLE;
		else
			if done = '1' then
				start <= '0';
			end if;
			case present is
			when IDLE => --if current state is idle
				if program = "000" then --and input switches are off
					next_state <= IDLE;	--remain in idle
					start <= '0'; -- do not exit RUNNER
				else 
					next_state <= RUNNING; --if program switches are on, change state to RUNNING
					start <= '1'; -- transfer control to PROGRAMMER
				end if;
			when RUNNING => --if current state is RUNNINING
				if done = '1' AND program = "000" then --if PROGRAMMER is not running a process...
					start <= '0'; --do not exit RUNNER
					next_state <= IDLE; -- and change state to IDLE
				else 
					next_state <= RUNNING; --else program switches will be on and state will reamin RUNNING
					start <= '1'; -- and control should be transfered to PROGRAMMER
				end if;
			end case;
		end if;
	end process;
	
	--PROGRAMMER SEQUENTIAL--
	PROCESS(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' OR hard_rst = '1' then
				pst <= HOLD;
			else
				if start = '1' then
					pst <= nst;
				end if; --start = '1'
			end if; -- if rst.. or hard_rst...
		end if; -- if rising_edge(clk)...
	end process; -- clk
	
	--PROGRAMMER COMBINATIONAL--
	process (pst,start,clk, rst, hard_rst)
	begin
		if rising_edge(clk) then --check for next action on next clock cycle
			if rst = '1' OR hard_rst = '1' then
				done <= '1'; -- switch control back to RUNNER
				nst <= HOLD;
				counter <= 0;
				inst_out <= "000000";
			else	
				case pst is --programmer state logic
				when HOLD => --in holding state
					inst_out <= "000000";
					counter <= 0; --reset instruction counter
					pce <= '0'; --pulse program execution counter
					if program = "000" then
						nst <= HOLD;
						done <= '1';
					elsif program = "001" then --select program to run based on switches
						nst <= P1;
						done <= '0';
					elsif program = "010" then
						nst <= P2;
						done <= '0';
					elsif program = "011" then
						nst <= p3;
						done <= '0';
					elsif program = "100" then
						nst <= p4;
						done <= '0';
					else
						nst <= ERROR; --for switches outside of bounds, display error message
						pce <= '0';
					end if;	--'program'
				when P1 =>
					if counter < 18 then
						if counter = 17 then
							pce <= '1';
						end if;
						inst_out <= prog1(counter);
						if pause = '1' then
						counter <= counter + 1;
						end if;
					else
						nst <= HOLD;
						done <= '1';
						pce <= '0';
						inst_out <= "000000";
					end if;
				when P2 =>
					if counter < 11 then
						if counter = 10 then
							pce <= '1';
						end if;
						inst_out <= prog2(counter);
						if pause = '1' then
						counter <= counter + 1;
						end if;
					else
						nst <= HOLD;
						done<='1';
						pce <= '0';
						inst_out <= "000000";
					end if;	
				when P3 =>
					if counter < 11 then
						if counter =10 then
							pce<='1';
						end if;	
						inst_out <= prog3(counter);
						if pause = '1' then	
							counter <= counter + 1;
						end if;	
					else
						nst <= HOLD;
						done<='1';
						pce <= '0';
						inst_out <= "000000";
					end if;		
				when P4 =>
					if stop_prog = '0' then
						nst <= HOLD;
					--	done <= '1';
					else
						if counter < 18 then
							if counter =17 then
								pce<='1';
							end if;
							inst_out <= prog4(counter);
							if pause ='1' then	
								counter <= counter + 1;
							end if;	
						else
							nst <= P4;
							pce <= '0';
							counter <= 0;
							inst_out <= "000000";
						end if; --stop program
					end if; --stop progam = '0'
				when ERROR => --for switches outside of bounds, display error message
					inst_out <= "111111";
					if program = "101" or program ="110" or program ="111" then
						nst <= ERROR;
					else
						nst <= HOLD;
					end if;	--program has invalid input
				end case; -- 'pst'
			end if; --'rst' OR 'hard_rst'
		end  if; --'rising_edge(clk)'
	end process; --'pst', 'start', 'clk'

end behaviour;