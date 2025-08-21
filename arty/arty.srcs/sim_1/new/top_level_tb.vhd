library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_level is
end tb_top_level;

architecture sim of tb_top_level is
    -- DUT ports
    signal clk      : std_logic := '0';
    signal ck_io0   : std_logic := '1';  -- UART RX line (idle = '1')
    signal ck_io1   : std_logic;
    signal ck_io2   : std_logic;

    -- UART config (example: 115200 baud @ 125 MHz clk)
    constant CLK_FREQ   : integer := 125_000_000; -- Hz
    constant BAUD_RATE  : integer := 115200;
    constant BIT_PERIOD : time := 1 sec / BAUD_RATE;

begin
    -- Clock generation (125 MHz)
    clk_process : process
    begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1';
        wait for 4 ns; -- period = 8 ns ? 125 MHz
    end process;

    -- DUT instantiation
    DUT : entity work.top_level
        port map (
            clk    => clk,
            ck_io0 => ck_io0,
            ck_io1 => ck_io1,
            ck_io2 => ck_io2
        );

    -- UART Stimulus process
    stim_proc : process
        -- procedure to send one UART frame (8 data bits, no parity, 1 stop)
        procedure uart_send_byte(signal tx : out std_logic; data : std_logic_vector(7 downto 0)) is
        begin
            -- Start bit
            tx <= '0';
            wait for BIT_PERIOD;
            -- Data bits (LSB first)
            for i in 0 to 7 loop
                tx <= data(i);
                wait for BIT_PERIOD;
            end loop;
            -- Stop bit
            tx <= '1';
            wait for BIT_PERIOD;
        end procedure;
    begin
        wait for 1 us;

        -- Example: send 3 bytes = 24-bit packet
        -- Suppose buff <= x"123456"
        uart_send_byte(ck_io0, x"12");
        uart_send_byte(ck_io0, x"34");
        uart_send_byte(ck_io0, x"56");

        wait for 5 ms;

        -- Send another packet (for testing)
        uart_send_byte(ck_io0, x"AA");
        uart_send_byte(ck_io0, x"55");
        uart_send_byte(ck_io0, x"0F");

        wait for 5 ms;
        wait;
    end process;
end sim;
