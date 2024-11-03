library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Image_Memory is
    port (
        clk       : in  std_logic;
        wr_en     : in  std_logic;
        address   : in  std_logic_vector(15 downto 0);  -- 16-bit address
        data_in   : in  std_logic_vector(7 downto 0);   -- 8-bit pixel input
        data_out  : out std_logic_vector(7 downto 0)    -- 8-bit pixel output
    );
end entity Image_Memory;

architecture Behavioral of Image_Memory is
    type mem_array is array (0 to 65535) of std_logic_vector(7 downto 0); -- Memory for 256x256 image
    signal memory : mem_array;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                memory(to_integer(unsigned(address))) <= data_in;
            end if;
            data_out <= memory(to_integer(unsigned(address)));
        end if;
    end process;
end Behavioral;
