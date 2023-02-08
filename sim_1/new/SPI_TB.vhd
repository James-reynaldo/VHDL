----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2022 11:26:50
-- Design Name: 
-- Module Name: SPI_TB - Behavioral
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
use std.env.stop;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_TB is
--  Port ( );
end SPI_TB;

architecture Behavioral of SPI_TB is

component SPI_EXAMPLE
    Port ( clk : in STD_LOGIC;
           sclk : out STD_LOGIC;
           cs : out STD_LOGIC;
           Mosi : out STD_LOGIC;
           sine : in std_logic_vector(15 downto 0));
end component;


component sine_lut
 Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           o_sine : out STD_LOGIC_VECTOR (15 downto 0));  

end component;

signal i_clk : std_logic := '0';
signal o_sclk: std_logic := '0';
signal o_cs : std_logic := '0';
signal o_Mosi : std_logic := '0';
signal i_rst : std_logic := '1';


begin

u0: SPI_EXAMPLE
    port map(clk => i_clk,sclk => o_sclk,cs=>o_cs,Mosi=> o_Mosi, sine=>o_sine );
    
u1: sine_lut
    port map(clk => i_clk,rst =>i_rst, o_sine => sine);
    
    
--    i_clk <= not i_clk after 0.5 ms;
    
--    stop_sim: process
--    begin
--        wait for 11000 ms;
--        stop;
--    end process;

end Behavioral;
