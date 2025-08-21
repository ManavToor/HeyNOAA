----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manav
-- 
-- Create Date: 08/20/2025 06:13:45 PM
-- Design Name: UART RX
-- Module Name: uart - Behavioral
-- Project Name: HeyNOAA
-- Target Devices: Arty Z7-10 (Zynq 7000)
-- Tool Versions: 
-- Description: 32-bit UART Receiver
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

entity uart is
    Port ( clk, rx : in STD_LOGIC;
           ready : out STD_LOGIC;
           buff : out STD_LOGIC_VECTOR (23 downto 0));
end uart;

architecture Behavioral of uart is
signal mark : std_logic := '1'; -- 1 if rx line idle, 0 when transmission begins
signal counter: unsigned(10 downto 0) := (others => '0'); -- count clock cycles
signal offset: unsigned(9 downto 0) := (others => '0'); -- offset counter to not sample on rising edge
signal index: integer range 0 to 23; -- index position of message

begin
process(clk)
begin
if rising_edge(clk) then
    
    -- wait for transmission
    if mark = '1' then
        if rx = '0' then
            mark <= '0';
            ready <= '0';
        end if;
    
    -- end of packet
    elsif index = 24 then
        index <= 0;
        mark <= '1';
        counter <= (others => '0');
        offset <= (others => '0');
        ready <= '0';
    
    -- read transmission
    else
        
        -- sample time is offset by half a bit
        if offset = 543 then -- (125 MHz / 115200) / 2
            
            -- time to sample
            if counter = 1085 then -- 125 MHz / 115200
                counter <= (others => '0');
                
                buff(index) <= rx;
                index <= index + 1;
                
                ready <= '1';
                
            -- not time to sample
            else
                counter <= counter + 1;
            end if;
            
        -- offset sampling by half a bit   
        else
            offset <= offset + 1;
        end if;
    end if;
end if;
end process;
end Behavioral;
