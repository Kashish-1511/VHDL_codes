library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Gradient_Magnitude is
    port (
        Gx      : in  std_logic_vector(15 downto 0);  -- 16-bit Gx input
        Gy      : in  std_logic_vector(15 downto 0);  -- 16-bit Gy input
        G_out   : out std_logic_vector(15 downto 0)   -- 16-bit gradient magnitude output
    );
end entity Gradient_Magnitude;

architecture Behavioral of Gradient_Magnitude is
begin
    process (Gx, Gy)
        variable G : integer := 0;
    begin
        G := abs(to_integer(signed(Gx))) + abs(to_integer(signed(Gy)));  -- |Gx| + |Gy|
        G_out <= std_logic_vector(to_signed(G, 16));
    end process;
end Behavioral;
