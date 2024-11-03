library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Image_Processing_Accelerator is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        img_data_in : in  std_logic_vector(7 downto 0);  -- Pixel input
        img_addr_in : in  std_logic_vector(15 downto 0); -- Pixel address
        wr_en       : in  std_logic;
        processed_data_out : out std_logic_vector(7 downto 0); -- Output after processing
	Gx_outt : out std_logic_vector(15 downto 0);
	Gy_outt : out std_logic_vector(15 downto 0)
    );
end entity Image_Processing_Accelerator;

architecture Behavioral of Image_Processing_Accelerator is
    signal pixel_window : std_logic_vector(71 downto 0); -- 3x3 pixel window
    signal Gxx, Gyy, G : std_logic_vector(15 downto 0);

    -- Component declarations
    component Image_Memory
        port (
            clk       : in  std_logic;
            wr_en     : in  std_logic;
            address   : in  std_logic_vector(15 downto 0);
            data_in   : in  std_logic_vector(7 downto 0);
            data_out  : out std_logic_vector(7 downto 0)
        );
    end component;

    component Sobel_Unit
        port (
            clk          : in  std_logic;
            pixel_window : in  std_logic_vector(71 downto 0);
            Gx_out       : out std_logic_vector(15 downto 0);
            Gy_out       : out std_logic_vector(15 downto 0)
        );
    end component;

    component Gradient_Magnitude
        port (
            Gx      : in  std_logic_vector(15 downto 0);
            Gy      : in  std_logic_vector(15 downto 0);
            G_out   : out std_logic_vector(15 downto 0)
        );
    end component;

begin
    -- Instantiate image memory
    mem: Image_Memory
        port map (
            clk => clk,
            wr_en => wr_en,
            address => img_addr_in,
            data_in => img_data_in,
            data_out => pixel_window(71 downto 64) -- Just for simplicity, connect part of the window
        );

    -- Instantiate Sobel Unit
    sobel: Sobel_Unit
        port map (
            clk => clk,
            pixel_window => pixel_window,
            Gx_out => Gxx,
            Gy_out => Gyy
        );

    -- Instantiate Gradient Magnitude
    grad: Gradient_Magnitude
        port map (
            Gx => Gxx,
            Gy => Gyy,
            G_out => G
        );

    -- Output processed data
    processed_data_out <= G(7 downto 0); -- Output the least significant 8 bits of the gradient magnitude
	Gx_outt <= Gxx;
	Gy_outt <= Gyy;
end Behavioral;

