

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity debouncer is
    Generic (
        counter_limit: integer := 250000
    );
    
    Port (
        CLK: in std_logic;
        input_signal: in std_logic;
        debounced: out std_logic
     );
end debouncer;

architecture Behavioral of debouncer is

signal debounced_sig: std_logic;
signal counter: integer; 
signal debounce_ff: std_logic_vector(1 downto 0);
signal should_reset: std_logic;

begin

    should_reset <= debounce_ff(0) xor debounce_ff(1);

    process(CLK, input_signal, debounced_sig, counter, debounce_ff) is begin
        if rising_edge(CLK) then
            debounce_ff(0) <= input_signal;
            debounce_ff(1) <= debounce_ff(0);
            if should_reset = '1' then
                counter <= 0;
            elsif counter < counter_limit then
                counter <= counter + 1;
            else 
                debounced <= debounce_ff(1);
            end if;
            
        end if;
    end process;

end Behavioral;
