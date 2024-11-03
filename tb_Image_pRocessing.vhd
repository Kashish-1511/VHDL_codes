library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;  -- For file I/O
use ieee.std_logic_textio.all;

entity Image_Processing_Accelerator_tb is
end entity;

architecture Behavioral of Image_Processing_Accelerator_tb is
    -- Signal declarations
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal wr_en       : std_logic := '0';
    signal img_data_in : std_logic_vector(7 downto 0);
    signal img_addr_in : std_logic_vector(15 downto 0);
    signal processed_data_out : std_logic_vector(7 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- DUT instantiation
    DUT: entity work.Image_Processing_Accelerator
        port map (
            clk                => clk,
            rst                => rst,
            img_data_in        => img_data_in,
            img_addr_in        => img_addr_in,
            wr_en              => wr_en,
            processed_data_out => processed_data_out
        );

    -- Stimulus process
    stimulus_process: process
        -- Variable declarations must be inside the process
        file image_pixels_file : text open read_mode is "image_pixels_16x16.txt";
        variable image_line    : line;
        variable pixel_data    : std_logic_vector(7 downto 0);
        variable pixel_count   : integer := 0;
        variable temp_pixel    : unsigned(7 downto 0);
    begin
        -- Reset the system
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Start reading pixel data from the file
        while not endfile(image_pixels_file) loop
            readline(image_pixels_file, image_line);  -- Read a line of binary pixel data
            read(image_line, pixel_data);             -- Convert to binary value

            -- Convert the pixel_data bit_vector to an integer
            temp_pixel := unsigned(pixel_data);

            -- Drive the pixel data and address
            img_data_in <= std_logic_vector(temp_pixel);
            img_addr_in <= std_logic_vector(to_unsigned(pixel_count, 16));
            wr_en <= '1';  -- Write enable

            -- Increment address for next pixel
            pixel_count := pixel_count + 1;
            wait for clk_period;

            wr_en <= '0';  -- Disable write enable
        end loop;

        -- Wait for processing to finish
        wait for 100 ns;

        -- Complete simulation
        assert false report "Simulation complete" severity note;
        wait;
    end process;

end Behavioral;

