----------------------------------------------------------------------------------
-- Company: ESOGU
-- Engineer: Mertcan Karık
-- 
-- Create Date: 12/22/2021 11:22:42 AM
-- Design Name: Gravity
-- Module Name: gravity - Behavioral
-- Project Name: VGA_Gravity_Project
-- Target Devices: Basys3
-- Description: This project is made for Intro. to VHDL/FPGA class. 
-- 
----------------------------------------------------------------------------------

-- TODO:
--      Implement gravity buttons and rules.


library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
library UNISIM;
use UNISIM.VComponents.all;

entity gravity is
    Generic(
        CLK25MHZ_count_lim: integer := 1;
        CLK2HZ_count_lim: integer := 2000000
    );

    Port(
        gravity: in std_logic_vector(3 downto 0);
        stiffness: in std_logic_vector(3 downto 0);
        -- general IO
        spawn_button: in std_logic;
        CLK100MHZ: in std_logic;
        Reset: in std_logic; 
        LED: out std_logic_vector(2 downto 0); -- to show which RGB is set by switches
        -- VGA IO
        color: in std_logic_vector(2 downto 0); -- RGB
        HSync: out std_logic;
        VSync: out std_logic; 
        RGB: out std_logic_vector(2 downto 0) 
    );
end gravity;

architecture Behavioral of gravity is
        
    component VGA_driver is
        port(
            -- inputs 
            CLK: in std_logic; -- should be 25 MHz
            color: in std_logic_vector(2 downto 0);
            Reset: in std_logic;
            x1, y1: in integer; -- top left of rectangle
            rw, rh: in integer; -- w and h of rectangle  
            -- outputs
            HSync: out std_logic;
            VSync: out std_logic; 
            RGB: out std_logic_vector(2 downto 0)
        );
    end component;

    -------------- components -------------- 

    component debouncer is 
        Port (
            CLK: in std_logic;
            input_signal: in std_logic;
            debounced: out std_logic
        );
    end component;
        

    -------------- signals --------------

    -- counter for random number generation
    signal rand_counter_x: integer := 0;
    signal rand_counter_y: integer := 0;

    -- buttons
    signal db_spawn_button, db_spawn_buttonx: std_logic; -- one debounced one to catch rising edge 

    -- clocks
    signal CLK25MHZ_counter: integer := 0;
    signal CLK25MHZ: std_logic;
    signal CLK2HZ_counter: integer := 0;
    signal CLK2HZ: std_logic; 

    -- x, y coords of top left of rect.
    signal x1: integer := 0; 
    signal y1: integer := 0;
    -- w and h of rect.
    constant rect_w: integer := 45;
    constant rect_h: integer := 35;
    constant SCREEN_WIDTH: integer := 640;
    constant SCREEN_HEIGHT: integer := 480;

    -- simulation
    signal simulation_time: integer := 0;

    -- bouncing offset
    signal bounce_offset: integer := 0;
    signal bounce_height: integer := 0; -- how many pixel will ball bounce

    -- acceleration due to gravity
    signal acceleration: integer;

    -- speed of object (px)
    constant INITIAL_SPEED_x: integer := 1;
    constant INITIAL_SPEED_y: integer := 2;    
    signal SPEEDy: integer := INITIAL_SPEED_y; 
    signal SPEEDx: integer := INITIAL_SPEED_x;

    -- locks
    signal UP_LOCK: std_logic; 
    signal DOWN_LOCK: std_logic;
    signal LEFT_LOCK: std_logic;
    signal RIGHT_LOCK: std_logic;

    
begin   
    
    -- debounce spawn button.
    debounce_spawn_button: debouncer port map(CLK => CLK25MHZ, input_signal => spawn_button, debounced => db_spawn_button);

    -- Generate VGA Driver clock     
    process(CLK100MHZ, CLK25MHZ) is
        begin
        if rising_edge(CLK100MHZ) then
            --CLK25MHZ <= not CLK25MHZ;
            if CLK25MHZ_counter = CLK25MHZ_count_lim then
                CLK25MHZ_counter <= 0;
              CLK25MHZ <= not CLK25MHZ;
            else
                CLK25MHZ_counter <= CLK25MHZ_counter + 1;
            end if;
        end if;
    end process;

    -- Generate drawing clock
    process(CLK100MHZ, CLK2HZ) is begin
        if rising_edge(CLK100MHZ) then
            --CLK25MHZ <= not CLK25MHZ;
            if CLK2HZ_counter = CLK2HZ_count_lim then
                CLK2HZ_counter <= 0;
              CLK2HZ <= not CLK2HZ;
            else
                CLK2HZ_counter <= CLK2HZ_counter + 1;
            end if;
        end if;
    end process;
    

    -- process to light leds to show which RGB is set by switches. 
    process(CLK100MHZ, color) is begin    
        if rising_edge(CLK100MHZ) then
            LED <= color;
        end if;
    end process;

    -- process to handle random counters
    process(CLK100MHZ, rand_counter_x, rand_counter_y) is begin
        if rising_edge(CLK100MHZ) then
            if rand_counter_x > 639 then
                rand_counter_x <= 0;
            else
                rand_counter_x <= rand_counter_x + 4;
            end if;

            if rand_counter_y > 639 then
                rand_counter_y <= 0;
            else
                rand_counter_y <= rand_counter_y + 2;
            end if;
        end if;
    end process; 
    
    -- gravity decoder for acceleration and leds
    with gravity select
        acceleration <= 0 when "0000",
                        1 when "0001",
                        2 when "0010",
                        3 when "0100",
                        4 when "1000",
                        0 when others; 

    -- stiffness deocder 
    with stiffness select
        bounce_offset <= 0 when "0000",
                        256  when "0001", 
                        192 when "0010",
                        128 when "0100",
                        64 when "1000",
                        0 when others;      
 
    -- randomly spawn rectangle in somewhere and control locks 
    process(CLK2Hz, x1, y1) is begin 
        if rising_edge(CLK2Hz) then
            SPEEDy <= SPEEDy + acceleration;                        
            -- Use rand_counter_xy counter for random number generation. Take mod of them by $SCREEN_WIDTH and $SCREEN_HEIGHT
            if db_spawn_buttonx = '0' and db_spawn_button = '1' then
                SPEEDy <= INITIAL_SPEED_y;
                --x1 <= rand_counter_x mod SCREEN_WIDTH;
                y1 <= rand_counter_y mod SCREEN_HEIGHT;                 
                bounce_height <= rand_counter_y mod SCREEN_HEIGHT + 6;
                UP_LOCK <= '1';
                DOWN_LOCK <= '0';
            -- if movement is over, stop the object
            elsif bounce_height > SCREEN_HEIGHT then           
                y1 <= SCREEN_HEIGHT;
            -- set locks along y
            elsif y1 > SCREEN_HEIGHT - 5 then -- set locks
                UP_LOCK <= '0';
                DOWN_LOCK <= '1'; 
                bounce_height <= bounce_height + bounce_offset; 
                y1 <= SCREEN_HEIGHT - 6;
            elsif y1 < bounce_height then -- set locks 
                UP_LOCK <= '1';
                DOWN_LOCK <= '0';
                y1 <= bounce_height + 6;
            -- set movement along y
            elsif UP_LOCK = '1' and DOWN_LOCK = '0' then
                y1 <= y1 + SPEEDy;
            elsif UP_LOCK = '0' and DOWN_LOCK = '1' then   
                y1 <= y1 - SPEEDy - 2;
            end if;

            SPEEDx <= SPEEDx + 1; 
            if db_spawn_buttonx = '0' and db_spawn_button = '1' then
                SPEEDx <= INITIAL_SPEED_x;
                x1 <= rand_counter_x mod SCREEN_WIDTH;
                LEFT_LOCK <= '1';
                RIGHT_LOCK <= '0';
            -- if movement is over, stop the object
            elsif bounce_height > SCREEN_HEIGHT then           
                SPEEDx <= 0;                
            -- set locks along x
            elsif x1 > SCREEN_WIDTH then
                LEFT_LOCK <= '0';
                RIGHT_LOCK <= '1';
                x1 <= SCREEN_WIDTH - 5;                
            elsif x1 < 0 then
                LEFT_LOCK <= '1';
                RIGHT_LOCK <= '0';
                x1 <= 5;
            -- set movement along x
            elsif LEFT_LOCK = '0' and RIGHT_LOCK = '1' then 
                x1 <= x1 - SPEEDx;
            elsif LEFT_LOCK = '1' and RIGHT_LOCK = '0' then
                x1 <= x1 + SPEEDx;
            end if;

            db_spawn_buttonx <= db_spawn_button;
        end if;
    end process;



    DISPLAY: VGA_driver port map(CLK => CLK25MHZ, color => color, Reset => Reset, 
                        x1 => x1, y1 => y1, rw => rect_w, rh => rect_h,
                        HSync => HSync, VSync => Vsync, RGB => RGB);

end Behavioral;
