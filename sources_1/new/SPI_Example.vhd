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
    type LUT_TYPE is array (0 to 499) of integer;
    constant LUT : LUT_TYPE :=
(
    2500,
2506,2512,2518,2525,2531,2537,2544,2550,2556,2562,2569,2575,2581,2588,2594,2600,2606,2613,2619,2625,
2631,2638,2644,2650,2656,2662,2669,2675,2681,2687,2693,2700,2706,2712,2718,2724,2730,2736,2743,2749,
2755,2761,2767,2773,2779,2785,2791,2797,2803,2809,2815,2821,2827,2833,2839,2845,2851,2857,2862,2868,
2874,2880,2886,2892,2897,2903,2909,2915,2920,2926,2932,2937,2943,2949,2954,2960,2966,2971,2977,2982,
2988,2993,2999,3004,3009,3015,3020,3026,3031,3036,3042,3047,3052,3057,3063,3068,3073,3078,3083,3088,
3093,3098,3103,3108,3113,3118,3123,3128,3133,3138,3143,3148,3152,3157,3162,3167,3171,3176,3181,3185,
3190,3194,3199,3203,3208,3212,3217,3221,3225,3230,3234,3238,3242,3247,3251,3255,3259,3263,3267,3271,
3275,3279,3283,3287,3291,3295,3298,3302,3306,3310,3313,3317,3321,3324,3328,3331,3335,3338,3342,3345,
3348,3352,3355,3358,3361,3364,3368,3371,3374,3377,3380,3383,3386,3389,3392,3394,3397,3400,3403,3405,
3408,3411,3413,3416,3418,3421,3423,3425,3428,3430,3432,3435,3437,3439,3441,3443,3445,3447,3449,3451,
3453,3455,3457,3459,3461,3462,3464,3466,3467,3469,3470,3472,3473,3475,3476,3477,3479,3480,3481,3482,
3483,3485,3486,3487,3488,3489,3489,3490,3491,3492,3493,3493,3494,3495,3495,3496,3496,3497,3497,3498,
3498,3498,3499,3499,3499,3499,3499,3499,3499,3499,3499,3499,3499,3499,3499,3499,3498,3498,3498,3497,
3497,3496,3496,3495,3495,3494,3493,3493,3492,3491,3490,3489,3489,3488,3487,3486,3485,3483,3482,3481,
3480,3479,3477,3476,3475,3473,3472,3470,3469,3467,3466,3464,3462,3461,3459,3457,3455,3453,3451,3449,
3447,3445,3443,3441,3439,3437,3435,3432,3430,3428,3425,3423,3421,3418,3416,3413,3411,3408,3405,3403,
3400,3397,3394,3392,3389,3386,3383,3380,3377,3374,3371,3368,3364,3361,3358,3355,3352,3348,3345,3342,
3338,3335,3331,3328,3324,3321,3317,3313,3310,3306,3302,3298,3295,3291,3287,3283,3279,3275,3271,3267,
3263,3259,3255,3251,3247,3242,3238,3234,3230,3225,3221,3217,3212,3208,3203,3199,3194,3190,3185,3181,
3176,3171,3167,3162,3157,3152,3148,3143,3138,3133,3128,3123,3118,3113,3108,3103,3098,3093,3088,3083,
3078,3073,3068,3063,3057,3052,3047,3042,3036,3031,3026,3020,3015,3009,3004,2999,2993,2988,2982,2977,
2971,2966,2960,2954,2949,2943,2937,2932,2926,2920,2915,2909,2903,2897,2892,2886,2880,2874,2868,2862,
2857,2851,2845,2839,2833,2827,2821,2815,2809,2803,2797,2791,2785,2779,2773,2767,2761,2755,2749,2743,
2736,2730,2724,2718,2712,2706,2700,2693,2687,2681,2675,2669,2662,2656,2650,2644,2638,2631,2625,2619,
2613,2606,2600,2594,2588,2581,2575,2569,2562,2556,2550,2544,2537,2531,2525,2518,2512,2506,2500);
    
    signal lut_sig : unsigned(11 downto 0 ); -- sine wave property
    signal state_sine : std_logic := '0'; -- sine wave property
    
    type condition is(idle,start,transfer,last);
    signal state : condition := idle;
    
    type ram is array (0 to 1) of std_logic_vector(15 downto 0);
    signal sinLUT : std_logic_vector(11 downto 0);
    signal reg : std_logic_vector(3 downto 0) := "1011";
    signal to_send : std_logic_vector(15 downto 0);
    signal kHz1counter : unsigned(13 downto 0) := to_unsigned(0,14); 
    signal bit16counter : unsigned(3 downto 0) := "0000";
    constant FULL1KHZ : integer := 2; -- generic possibility, idle time
    signal cs_intern : std_logic := '0';
    signal sclk_intern :STD_LOGIC :='0'; --clk_out
    signal mosi_intern : std_logic :='0';
  
    component sine_lut
            port( clk : in STD_LOGIC;
                  rst : in STD_LOGIC;
                  o_sine : out STD_LOGIC_VECTOR (15 downto 0));  
    end component;              
begin
    
    
    sinLUT <= std_logic_vector(lut_sig) when state_sine='0' else -- assign sine value
    std_logic_vector(5000-lut_sig); --180 rotation
    to_send <= reg & sinLUT; -- complete message
    StartSendWord : process(clk,rst)
    variable cnt : integer range 0 to 500; -- sine wave property
    begin
        if rst = '0' then -- process reset
        cnt := 0;
        lut_sig <= (others => '0');
        end if;
        if rising_edge(clk) then
            case state is
                when idle=>
                    cs_intern<='1';
                    sclk_intern<='0';
                    
                    if(kHz1counter=FULL1KHZ) then
                        kHz1counter <= (others => '0');
                        lut_sig <= to_unsigned(LUT(cnt),12);
                        state <= start;
                    else
                        kHz1counter <= kHz1counter + 1;    --wait 12000 * clk period
                    end if;
                        
                when start =>
                    
                    cs_intern <='0';
                    bit16counter <= "1111";
                    mosi_intern <= to_send(15);
                    state <= transfer;
                    
                when transfer =>
                    if(sclk_intern = '0') then
                        sclk_intern<='1';
                        bit16counter <= Bit16counter -1;
                    else
                        sclk_intern <= '0';
                        mosi_intern <= to_send(to_integer(bit16counter));
                        if(bit16counter =0) then
                            state <= last;
                        end if;        
                    end if;
                when last =>
                    if(sclk_intern = '0') then
                        sclk_intern <= '1';
                    else
                        sclk_intern <= '0';
                        mosi_intern<= '0';
                        state <= idle;
                        if cnt >498 then
                            cnt := 0;
                            state_sine <= not state_sine;
                        else
                            cnt:= cnt+1;
                        end if;
                    end if;
                                
            end case;
                
        end if;    
    end process;
        
    cs <= cs_intern;
    sclk <= sclk_intern;
    mosi <= mosi_intern;


end Behavioral;
