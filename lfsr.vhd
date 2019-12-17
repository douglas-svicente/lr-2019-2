-------------------------------------------------------------------------------
-- File downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
-- Description:
-- A LFSR or Linear Feedback Shift Register is a quick and easy
-- way to generate pseudo-random data inside of an FPGA. The LFSR can be used
-- for things like counters, test patterns, scrambling of data, and others.
-- This module creates an LFSR whose width gets set by a generic. The
-- o_LFSR_Done will pulse once all combinations of the LFSR are complete. The
-- number of clock cycles that it takes o_LFSR_Done to pulse is equal to
-- 2^g_Num_Bits-1. For example, setting g_Num_Bits to 5 means that o_LFSR_Done
-- will pulse every 2^5-1 = 31 clock cycles. o_LFSR_Data will change on each
-- clock cycle that the module is enabled, which can be used if desired.
--
-- Generics:
-- g_Num_Bits - Set to the integer number of bits wide to create your LFSR.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY LFSR IS
    GENERIC (
        g_Num_Bits : INTEGER := 10
    );
    PORT (
        i_Clk : IN std_logic;
        i_Enable : IN std_logic;

        -- Optional Seed Value
        i_Seed_DV : IN std_logic;
        i_Seed_Data : IN std_logic_vector(g_Num_Bits - 1 DOWNTO 0);

        o_LFSR_Data : OUT std_logic_vector(g_Num_Bits - 1 DOWNTO 0);
        o_LFSR_Done : OUT std_logic
    );
END ENTITY LFSR;

ARCHITECTURE RTL OF LFSR IS

    SIGNAL r_LFSR : std_logic_vector(g_Num_Bits DOWNTO 1) := (OTHERS => '0');
    SIGNAL w_XNOR : std_logic;

BEGIN

    -- Purpose: Load up LFSR with Seed if Data Valid (DV) pulse is detected.
    -- Othewise just run LFSR when enabled.
    p_LFSR : PROCESS (i_Clk) IS
    BEGIN
        IF rising_edge(i_Clk) THEN
            IF i_Enable = '1' THEN
                IF i_Seed_DV = '1' THEN
                    r_LFSR <= i_Seed_Data;
                ELSE
                    r_LFSR <= r_LFSR(r_LFSR'left - 1 DOWNTO 1) & w_XNOR;
                END IF;
            END IF;
        END IF;
    END PROCESS p_LFSR;

    -- Create Feedback Polynomials. Based on Application Note:
    -- http://www.xilinx.com/support/documentation/application_notes/xapp052.pdf
    g_LFSR_3 : IF g_Num_Bits = 3 GENERATE
        w_XNOR <= r_LFSR(3) XNOR r_LFSR(2);
    END GENERATE g_LFSR_3;

    g_LFSR_4 : IF g_Num_Bits = 4 GENERATE
        w_XNOR <= r_LFSR(4) XNOR r_LFSR(3);
    END GENERATE g_LFSR_4;

    g_LFSR_5 : IF g_Num_Bits = 5 GENERATE
        w_XNOR <= r_LFSR(5) XNOR r_LFSR(3);
    END GENERATE g_LFSR_5;

    g_LFSR_6 : IF g_Num_Bits = 6 GENERATE
        w_XNOR <= r_LFSR(6) XNOR r_LFSR(5);
    END GENERATE g_LFSR_6;

    g_LFSR_7 : IF g_Num_Bits = 7 GENERATE
        w_XNOR <= r_LFSR(7) XNOR r_LFSR(6);
    END GENERATE g_LFSR_7;

    g_LFSR_8 : IF g_Num_Bits = 8 GENERATE
        w_XNOR <= r_LFSR(8) XNOR r_LFSR(6) XNOR r_LFSR(5) XNOR r_LFSR(4);
    END GENERATE g_LFSR_8;

    g_LFSR_9 : IF g_Num_Bits = 9 GENERATE
        w_XNOR <= r_LFSR(9) XNOR r_LFSR(5);
    END GENERATE g_LFSR_9;

    g_LFSR_10 : IF g_Num_Bits = 10 GENERATE
        w_XNOR <= r_LFSR(10) XNOR r_LFSR(7);
    END GENERATE g_LFSR_10;

    g_LFSR_11 : IF g_Num_Bits = 11 GENERATE
        w_XNOR <= r_LFSR(11) XNOR r_LFSR(9);
    END GENERATE g_LFSR_11;

    g_LFSR_12 : IF g_Num_Bits = 12 GENERATE
        w_XNOR <= r_LFSR(12) XNOR r_LFSR(6) XNOR r_LFSR(4) XNOR r_LFSR(1);
    END GENERATE g_LFSR_12;

    g_LFSR_13 : IF g_Num_Bits = 13 GENERATE
        w_XNOR <= r_LFSR(13) XNOR r_LFSR(4) XNOR r_LFSR(3) XNOR r_LFSR(1);
    END GENERATE g_LFSR_13;

    g_LFSR_14 : IF g_Num_Bits = 14 GENERATE
        w_XNOR <= r_LFSR(14) XNOR r_LFSR(5) XNOR r_LFSR(3) XNOR r_LFSR(1);
    END GENERATE g_LFSR_14;

    g_LFSR_15 : IF g_Num_Bits = 15 GENERATE
        w_XNOR <= r_LFSR(15) XNOR r_LFSR(14);
    END GENERATE g_LFSR_15;

    g_LFSR_16 : IF g_Num_Bits = 16 GENERATE
        w_XNOR <= r_LFSR(16) XNOR r_LFSR(15) XNOR r_LFSR(13) XNOR r_LFSR(4);
    END GENERATE g_LFSR_16;

    g_LFSR_17 : IF g_Num_Bits = 17 GENERATE
        w_XNOR <= r_LFSR(17) XNOR r_LFSR(14);
    END GENERATE g_LFSR_17;

    g_LFSR_18 : IF g_Num_Bits = 18 GENERATE
        w_XNOR <= r_LFSR(18) XNOR r_LFSR(11);
    END GENERATE g_LFSR_18;

    g_LFSR_19 : IF g_Num_Bits = 19 GENERATE
        w_XNOR <= r_LFSR(19) XNOR r_LFSR(6) XNOR r_LFSR(2) XNOR r_LFSR(1);
    END GENERATE g_LFSR_19;

    g_LFSR_20 : IF g_Num_Bits = 20 GENERATE
        w_XNOR <= r_LFSR(20) XNOR r_LFSR(17);
    END GENERATE g_LFSR_20;

    g_LFSR_21 : IF g_Num_Bits = 21 GENERATE
        w_XNOR <= r_LFSR(21) XNOR r_LFSR(19);
    END GENERATE g_LFSR_21;

    g_LFSR_22 : IF g_Num_Bits = 22 GENERATE
        w_XNOR <= r_LFSR(22) XNOR r_LFSR(21);
    END GENERATE g_LFSR_22;

    g_LFSR_23 : IF g_Num_Bits = 23 GENERATE
        w_XNOR <= r_LFSR(23) XNOR r_LFSR(18);
    END GENERATE g_LFSR_23;

    g_LFSR_24 : IF g_Num_Bits = 24 GENERATE
        w_XNOR <= r_LFSR(24) XNOR r_LFSR(23) XNOR r_LFSR(22) XNOR r_LFSR(17);
    END GENERATE g_LFSR_24;

    g_LFSR_25 : IF g_Num_Bits = 25 GENERATE
        w_XNOR <= r_LFSR(25) XNOR r_LFSR(22);
    END GENERATE g_LFSR_25;

    g_LFSR_26 : IF g_Num_Bits = 26 GENERATE
        w_XNOR <= r_LFSR(26) XNOR r_LFSR(6) XNOR r_LFSR(2) XNOR r_LFSR(1);
    END GENERATE g_LFSR_26;

    g_LFSR_27 : IF g_Num_Bits = 27 GENERATE
        w_XNOR <= r_LFSR(27) XNOR r_LFSR(5) XNOR r_LFSR(2) XNOR r_LFSR(1);
    END GENERATE g_LFSR_27;

    g_LFSR_28 : IF g_Num_Bits = 28 GENERATE
        w_XNOR <= r_LFSR(28) XNOR r_LFSR(25);
    END GENERATE g_LFSR_28;

    g_LFSR_29 : IF g_Num_Bits = 29 GENERATE
        w_XNOR <= r_LFSR(29) XNOR r_LFSR(27);
    END GENERATE g_LFSR_29;

    g_LFSR_30 : IF g_Num_Bits = 30 GENERATE
        w_XNOR <= r_LFSR(30) XNOR r_LFSR(6) XNOR r_LFSR(4) XNOR r_LFSR(1);
    END GENERATE g_LFSR_30;

    g_LFSR_31 : IF g_Num_Bits = 31 GENERATE
        w_XNOR <= r_LFSR(31) XNOR r_LFSR(28);
    END GENERATE g_LFSR_31;

    g_LFSR_32 : IF g_Num_Bits = 32 GENERATE
        w_XNOR <= r_LFSR(32) XNOR r_LFSR(22) XNOR r_LFSR(2) XNOR r_LFSR(1);
    END GENERATE g_LFSR_32;
    o_LFSR_Data <= r_LFSR(r_LFSR'left DOWNTO 1);
    o_LFSR_Done <= '1' WHEN r_LFSR(r_LFSR'left DOWNTO 1) = i_Seed_Data ELSE
        '0';

END ARCHITECTURE RTL;