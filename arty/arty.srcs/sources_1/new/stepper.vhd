----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/20/2025 03:42:07 PM
-- Design Name: 
-- Module Name: stepper - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stepper is
    Port ( buff : in STD_LOGIC_VECTOR (31 downto 0);
           ready: in STD_LOGIC;
           output : out STD_LOGIC_VECTOR(3 downto 0));
end stepper;

architecture Behavioral of stepper is

begin
process(ready)
begin
    if ready = '1' then
        output <= buff(3 downto 0);
    end if;
end process;
end Behavioral;
