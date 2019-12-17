LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

ENTITY vga IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        H_SYNC : OUT STD_LOGIC;
        V_SYNC : OUT STD_LOGIC;
        R : OUT STD_LOGIC;
        G : OUT STD_LOGIC;
        B : OUT STD_LOGIC);
END vga;

ARCHITECTURE arch OF vga IS

    COMPONENT VGASync IS
        PORT (
            RESET : IN STD_LOGIC;
            F_CLOCK : IN STD_LOGIC;
            F_HSYNC : OUT STD_LOGIC;
            F_VSYNC : OUT STD_LOGIC;
            F_ROW : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            F_COLUMN : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
            F_DISP_ENABLE : OUT STD_LOGIC
        );
    END COMPONENT VGASync;

    COMPONENT PixelGen IS
        PORT (
            RESET : IN STD_LOGIC;
            F_CLOCK : IN STD_LOGIC;
            F_ON : IN STD_LOGIC;
            F_ROW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            F_COLUMN : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            R_OUT : OUT STD_LOGIC;
            G_OUT : OUT STD_LOGIC;
            B_OUT : OUT STD_LOGIC
        );
    END COMPONENT PixelGen;

    --Índice da linha/coluna atual
    SIGNAL CURRENT_ROW : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL CURRENT_COLUMN : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL DISP_ENABLE : STD_LOGIC;

BEGIN

    --Módulo de sincronismo
    VGA : VGASync PORT MAP(
        RESET => RESET,
        F_CLOCK => CLOCK_50,
        F_HSYNC => H_SYNC,
        F_VSYNC => V_SYNC,
        F_ROW => CURRENT_ROW,
        F_COLUMN => CURRENT_COLUMN,
        F_DISP_ENABLE => DISP_ENABLE);

    --Módulo para gerar os pixels
    PIXELS : PixelGen PORT MAP(
        RESET => RESET,
        F_CLOCK => CLOCK_50,
        F_ON => DISP_ENABLE,
        F_ROW => CURRENT_ROW,
        F_COLUMN => CURRENT_COLUMN,
        R_OUT => R,
        G_OUT => G,
        B_OUT => B);

END arch;