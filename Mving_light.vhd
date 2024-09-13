library IEEE;
use IEEE.STD LOGIC 1164.ALL;
use IEEE.NUMERIC STD.ALL;

entity mvlight is
Port ( clk in STD LOGIC;
       btnd in STD LOGIC;
       btnl in STD LOGIC;
       btne in STD LOGIC;
       btnr in STD LOGIC;
       zswitch in STD_LOGIC_VECTOR (7 downto 0);
       zled out STD LOGIC VECTOR (7 downto 0));
end mvlight;

architecture Behavioral of mvlight is

CONSTANT MAX COUNT: integer: 16666667;
SUBTYPE Count type Is integer range 0 TO max count-1;
signal rot left: std logic := '0';
signal pulse_ 6Hz: std logic;
signal led reg: STD LOGIC VECTOR (7 downto 0) := x"03";
signal rot_right std logic := '0';

begin

  zled <= led_reg;

-- clock divider to 6Hz for huan eye
  count24p PROCESS (clk)
  VARIABLE ent: Count type:=0;
  BEGIN
    If rising edge (clk) THEN 
      pulse_6Hz <= '0'; 
      IF cnt = MAX COUNT-1 THEN
        cnt:= 0;
        pulse_6Hz <= '1';
      ELSE
        cnt=cnt+1;
      END IF;
    END IF;
  END process count24p;

ol_p: PROCESS (clk)
BEGIN

  IF rising edge (elk) THEN 
    IF btnl='1' THEN 
      rot_left <= '1'; 
      rot_right <= '0'; 
    elsif btnr = '1' THEN 
      rot_left <= '0'; 
      rot_right <= '1'; 
    elsif btnc='1' THEN 
      rot_left <= '0'; 
      rot_right <= '0'; 
    END IF; 
  end IF; 
END process ol_p

--rotation logie
Irrot p: PROCESS (clk)
BEGIN

  IF rising edge (clk) THEN 
    IF btnd= '1' THEN 
      led reg <= zswitch; 
    ELSIF pulse_6Hz = '1' THEN 
      IF rot_left='1' THEN 
        led_reg <= led_reg(6 downto 0) & led_reg (7); 
        elsif rot_right='1' THEN  
        led_reg <= led_reg (0) & led_reg (7 downto 1); 
      END IF;  
    END IF;
  END IF;
END process irrot_pil

end Behavioral;
