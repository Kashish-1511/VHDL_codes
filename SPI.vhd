library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI_Master is
    Port (
        clk         : in  STD_LOGIC;       -- System clock
        reset       : in  STD_LOGIC;       -- Asynchronous reset
        start       : in  STD_LOGIC;       -- Start signal for SPI transaction
        MOSI        : out STD_LOGIC;       -- Master Out Slave In
        MISO        : in  STD_LOGIC;       -- Master In Slave Out
        SCK         : out STD_LOGIC;       -- Serial Clock
        SS          : out STD_LOGIC;       -- Slave Select
        sensor_data : out std_logic_vector(7 downto 0)  -- Data received from the sensor
    );
end SPI_Master;

architecture Behavioral of SPI_Master is
    type state_type is (IDLE, SEND, RECEIVE, DONE);
    signal state, next_state : state_type;
    signal clk_div      : integer := 0;
    signal clk_div_reg  : STD_LOGIC := '0';
    signal bit_counter : integer := 0;
    signal shift_reg   : std_logic_vector(7 downto 0) := (others => '0');
    signal data        : std_logic_vector(7 downto 0) := (others => '0');
begin

    -- Clock divider to generate SPI clock
    process(clk, reset)
    begin
        if reset = '1' then
            clk_div <= 0;
            clk_div_reg <= '0';
            SCK <= '0';
        elsif rising_edge(clk) then
            clk_div <= clk_div + 1;
            if clk_div = 50 then -- Adjust this value for SPI clock frequency
                clk_div_reg <= not clk_div_reg;
                SCK <= clk_div_reg;
                clk_div <= 0;
            end if;
        end if;
    end process;

    -- State machine for SPI control
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            SS <= '1';
            bit_counter <= 0;
            MOSI <= '0';
            sensor_data <= (others => '0');
        elsif rising_edge(clk) then
            state <= next_state;
            case state is
                when IDLE =>
                    SS <= '1';
                    if start = '1' then
                        next_state <= SEND;
                    else
                        next_state <= IDLE;
                    end if;

                when SEND =>
                    SS <= '0';  -- Activate sensor
                    if bit_counter < 8 then
                        MOSI <= data(7 - bit_counter);  -- Send data bit to sensor
                        bit_counter <= bit_counter + 1;
                        next_state <= SEND;
                    else
                        bit_counter <= 0;
                        next_state <= RECEIVE;
                    end if;

                when RECEIVE =>
                    if bit_counter < 8 then
                        shift_reg <= shift_reg(6 downto 0) & MISO;  -- Receive data bit from sensor
                        bit_counter <= bit_counter + 1;
                        next_state <= RECEIVE;
                    else
                        sensor_data <= shift_reg;  -- Store received data
                        next_state <= DONE;
                    end if;

                when DONE =>
                    SS <= '1';  -- Deactivate sensor
                    if start = '0' then
                        next_state <= IDLE;
                    else
                        next_state <= DONE;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;

