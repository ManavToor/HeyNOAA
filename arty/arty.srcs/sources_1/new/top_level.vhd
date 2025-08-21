----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/21/2025 04:27:38 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( clk, ck_io0 : in STD_LOGIC;
           ck_io1, ck_io2 : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is
signal buff : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
signal ready: std_logic;

begin

    UART_RX: entity work.uart 
    port map(
        clk => clk,
        rx => ck_io0,
        ready => ready,
        buff => buff
    );
    
    AZIMUTH: entity work.pwm
    port map(
        pulse => buff(23 downto 13),
        clk => clk,
        ready => ready,
        sig_out => ck_io1
    );

    ELEVATION: entity work.pwm
    port map(
        pulse => buff(10 downto 0),
        clk => clk,
        ready => ready,
        sig_out => ck_io2
    );

end Behavioral;
