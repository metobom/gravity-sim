----------------------------------------------------------------------------------
-- Company: ESOGU
-- Engineer: Mertcan Karık
-- 
-- Create Date: 12/22/2021 11:22:42 AM
-- Design Name: Gravity
-- Module Name: gravity - Behavioral
-- Project Name: VGA_Gravity_Project
-- Target Devices: Basys3
-- Description: VGA Driver.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
library UNISIM;
use UNISIM.VComponents.all;


entity VGA_driver is
    Port (
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
end VGA_driver;

architecture Behavioral of VGA_driver is
    -- horizontal 
    constant WSIZE: integer := 1040; 
    constant HORIZONTAL_FRONT_PORCH: integer := 56;
    constant HORIZONTAL_SYNC_PULSE: integer := 120;
    constant HORIZONTAL_BACK_PORCH: integer := 64;
    constant WIDTH: integer := WSIZE - HORIZONTAL_BACK_PORCH - HORIZONTAL_FRONT_PORCH - HORIZONTAL_SYNC_PULSE - 1;
    -- vertical 
    constant HSIZE: integer := 666; 
    constant VERTICAL_FRONT_PORCH: integer := 37;
    constant VERTICAL_SYNC_PULSE: integer := 6;
    constant VERTICAL_BACK_PORCH: integer := 23;
    constant HEIGHT: integer := HSIZE - VERTICAL_BACK_PORCH - VERTICAL_FRONT_PORCH - VERTICAL_SYNC_PULSE - 1;
    
    -- metastability signals 
    signal xcoord: integer := 0;
    signal ycoord: integer := 0;
    -- 
    signal isValid: std_logic := '0';

begin


    -- set horizontal counter
    process(CLK, Reset, xcoord) is begin
        if Reset = '1' then
            xcoord <= 0;
        elsif rising_edge(CLK) then
            if xcoord = WSIZE - 1 then
                xcoord <= 0;
            else
                xcoord <= xcoord + 1;
            end if;
        end if;
    end process;
    
    -- set vertical counter 
    process(CLK, Reset, ycoord) is begin
        if Reset = '1' then
            ycoord <= 0;
        elsif rising_edge(CLK) then
            if xcoord = WSIZE - 1 then
                if ycoord = HSIZE - 1 then
                    ycoord <= 0;
                else
                    ycoord <= ycoord + 1;
                end if;
            end if;
        end if;
    end process; 

    -- horizontal sync
    process(CLK, Reset, xcoord) is begin
        if Reset = '1' then
            HSync <= '0';
        elsif rising_edge(CLK) then
            if (xcoord <= (WIDTH + HORIZONTAL_FRONT_PORCH)) or (xcoord > (WIDTH + HORIZONTAL_FRONT_PORCH + HORIZONTAL_SYNC_PULSE)) then
                HSync <= '1';
            else
                HSync <= '0';
            end if;
        end if; 
    end process;

    -- veritcal sync 
    process(CLK, Reset, ycoord, xcoord) is begin
        if Reset = '1' then
            VSync <= '1';
        elsif rising_edge(CLK) then
            if (ycoord <= (HEIGHT + VERTICAL_FRONT_PORCH)) or (ycoord > (HEIGHT + VERTICAL_FRONT_PORCH + VERTICAL_SYNC_PULSE)) then
                VSync <= '0';
            else
                VSync <= '1';
            end if;
        end if;
    end process;

    -- check if counters are on display region
    process(CLK, Reset, xcoord, ycoord) is begin
        if Reset = '1' then
            isValid <= '0';
        elsif rising_edge(CLK) then
            if (xcoord <= WIDTH) and (ycoord <= HEIGHT) then 
                isValid <= '1';
            else
                isValid <= '0'; 
            end if;
        end if;
    end process;
     
    -- draw rectangle
    process(CLK, Reset, xcoord, ycoord, isValid) is begin
        if Reset = '1' then
            RGB <= "000";
        elsif rising_edge(CLK) then
            if isValid = '1' then
                if (xcoord >= x1 and  xcoord <= x1 + rw) and (ycoord >= y1 and ycoord <= y1 + rh) then
                    RGB <= color;
                else 
                    RGB <= "110"; -- background color
                end if;
            else
                RGB <= "000";
            end if;
        end if;
    end process; 


    

end Behavioral;
