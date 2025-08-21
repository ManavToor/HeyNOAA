----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/20/2025 03:11:54 PM
-- Design Name: 
-- Module Name: pwm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
    Port ( pulse : in STD_LOGIC_VECTOR (10 downto 0);
           clk, ready : in STD_LOGIC;
           sig_out : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is
signal pulse_time       : unsigned(10 downto 0) := (others => '0'); -- holder for pulse time
signal pulse_clk_cycles : unsigned(17 downto 0) := (others => '0'); -- pulse time in clock cycles
signal counter          : unsigned(21 downto 0) := (others => '0'); -- count clock cycles
signal pulse_counter    : unsigned(21 downto 0) := (others => '0'); -- count pulse time

begin
pulse_clk_cycles <= to_unsigned(125 * to_integer(pulse_time), 18); -- 125 MHz * pulse_time (us)

process(clk)
begin
if rising_edge(clk) then

    -- update pulse_time if new UART buffer received
    if ready = '1' then
        pulse_time <= unsigned(pulse(10 downto 0));
    end if;

    -- period starts
    if counter = 2500000 then -- 125MHz / 50 Hz
        pulse_counter <= (others => '0');
        counter <= (others => '0');
        
    -- period ongoing
    else
        -- pulse over
        if pulse_counter >= pulse_clk_cycles then
                sig_out <= '0';
        
        -- pulse ongoing
        else
            sig_out <= '1';
            pulse_counter <= pulse_counter + 1;
        end if;
        
        counter <= counter + 1;
    end if;
end if;
end process;
end Behavioral;
