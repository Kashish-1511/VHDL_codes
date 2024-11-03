library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Sobel_Unit is
    port (
        clk          : in  std_logic;
        pixel_window : in  std_logic_vector(71 downto 0);  -- 3x3 window of 8-bit pixels
        Gx_out       : out std_logic_vector(15 downto 0);  -- 16-bit Gx result
        Gy_out       : out std_logic_vector(15 downto 0)   -- 16-bit Gy result
    );
end entity Sobel_Unit;

architecture Behavioral of Sobel_Unit is
signal Gx : signed(15 downto 0);
    signal Gy : signed(15 downto 0);
begin
    process (clk)
        
    begin
        if rising_edge(clk) then
            -- Apply Sobel Gx kernel
            Gx <= -1 * signed(pixel_window(71 downto 64)) +
                   1 * signed(pixel_window(63 downto 56)) +
                  (-1 * 2)* signed(pixel_window(47 downto 40)) +
                   2 * signed(pixel_window(39 downto 32))
                  -1 * signed(pixel_window(23 downto 16)) +
                   1 * signed(pixel_window(15 downto 8));

            -- Apply Sobel Gy kernel
            Gy <= -1 * signed(pixel_window(71 downto 64)) +
                  (-1 * 2) * signed(pixel_window(55 downto 48))
                  -1 * signed(pixel_window(39 downto 32)) +
                   1 * signed(pixel_window(23 downto 16)) +
                   2 * signed(pixel_window(7 downto 0)) +
                   1 * signed(pixel_window(15 downto 8));
            
            Gx_out <= std_logic_vector(Gx);
            Gy_out <= std_logic_vector(Gy);
        end if;
    end process;
end Behavioral;
