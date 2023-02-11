----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2022 23:51:29
-- Design Name: 
-- Module Name: SPI_Example - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_Example is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC; 
           sclk : out STD_LOGIC;
           cs : out STD_LOGIC;
           Mosi : out std_logic
           );
end SPI_Example;

architecture Behavioral of SPI_Example is
   
    
    signal inclk : std_logic;
    signal sinLUT : std_logic_vector(11 downto 0);--sine wave out
    signal cs_intern : std_logic := '0';
    signal sclk_intern :STD_LOGIC :='0'; --clk_out
    signal mosi_intern : std_logic :='0';
  
    component sine_lut
            port( clk : in STD_LOGIC;
                  rst : in STD_LOGIC;
                  o_sine : out STD_LOGIC_VECTOR (15 downto 0));  
    end component;
    component spi_int
           Port ( sin_in : in std_logic_vector(11 downto 0);
           clk : in STD_LOGIC;
           sclk : out STD_LOGIC;
           cs : out STD_LOGIC;
           MOSI : out STD_LOGIC;
           ask : out STD_LOGIC);  
    end component;                  
begin
    
    i1 : sine_lut
			port map(clk=> inclk, rst=> rst, o_sine => sinLUT);
	i0 : spi_int
	        port map(sin_in=>sinLUT,clk=> clk, sclk=>sclk, cs=>cs, MOSI=> Mosi, ask=>inclk);		
   
        
    cs <= cs_intern;
    sclk <= sclk_intern;
    mosi <= mosi_intern;


end Behavioral;
