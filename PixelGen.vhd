--package cobra is 
--	type INT_VECTOR IS ARRAY (60 downto 0) OF INTEGER RANGE 0 TO 100;
--end package;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE work.cobra.all;

-- USE IEEE.STD_LOGIC_ARITH.ALL;
-- USE IEEE.math_real.ALL;

ENTITY PixelGen IS
	GENERIC (
		ALTURA : INTEGER := 60;
		LARGURA : INTEGER := 80;
		MAX_COMIDA : INTEGER := 10;
		g_Num_Bits : INTEGER := 10
	);

	PORT (
		RESET : IN STD_LOGIC; -- Entrada para reiniciar o estado do controlador
		F_CLOCK : IN STD_LOGIC; -- Entrada de clock (50 MHz)
		F_ON : IN STD_LOGIC; --Indica a região ativa do frame
		F_ROW : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Índice da linha que está sendo processada
		F_COLUMN : IN STD_LOGIC_VECTOR(10 DOWNTO 0); -- Índice da coluna que está sendo processada
		
		COBRA_MORTA_X: IN INT_VECTOR;
		COBRA_MORTA_Y: IN INT_VECTOR;

		R_OUT : OUT STD_LOGIC; -- Componente R
		G_OUT : OUT STD_LOGIC; -- Componente G
		B_OUT : OUT STD_LOGIC; -- Componente B
		LED_OUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END ENTITY PixelGen;

ARCHITECTURE arch OF PixelGen IS

	COMPONENT LFSR IS
		GENERIC (
			g_Num_Bits : INTEGER := 10
		);

		PORT (
			i_Clk : IN std_logic;
			i_Enable : IN std_logic;

			-- Optional Seed Value
			--		i_Seed_DV : in std_logic;
			--	i_Seed_Data : in std_logic_vector(g_Num_Bits-1 downto 0);

			o_LFSR_Data : OUT std_logic_vector(g_Num_Bits - 1 DOWNTO 0);
			o_LFSR_Done : OUT std_logic
		);
	END COMPONENT LFSR;

	TYPE T_COMIDA IS ARRAY(MAX_COMIDA * 2 + 1 DOWNTO 0) OF INTEGER;
	SIGNAL COMIDA : T_COMIDA;
	SIGNAL qnt_atual_comida : INTEGER RANGE 0 TO MAX_COMIDA * 2 := 0;

	SIGNAL RGBn_int : INTEGER RANGE 0 TO 7;
	SIGNAL RGBp_int : INTEGER RANGE 0 TO 7;
	SIGNAL RGBp : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Valor atual do pixel
	SIGNAL RGBn : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Último valor definido
	SIGNAL i : INTEGER RANGE 0 TO 800 := 0;
	SIGNAL j : INTEGER RANGE 0 TO 600 := 0;
	--	SIGNAL k : INTEGER RANGE 0 TO MAX_COMIDA := 0;
	SIGNAL o_LFSR_Data_u : UNSIGNED(g_Num_Bits - 1 DOWNTO 0);
	SIGNAL o_LFSR_Data_aux : std_logic_vector(g_Num_Bits - 1 DOWNTO 0);
	SIGNAL o_LFSR_Done_aux : std_logic;

BEGIN

	L : LFSR PORT MAP(
		i_Clk => F_CLOCK,
		i_Enable => '1',
		o_LFSR_Data => o_LFSR_Data_aux,
		o_LFSR_Done => o_LFSR_Done_aux
	);

	-- Cada componente deve ser ativada somente se o frame estiver na região ativa
	R_OUT <= RGBp(2) AND F_ON;
	G_OUT <= RGBp(1) AND F_ON;
	B_OUT <= RGBp(0) AND F_ON;

	o_LFSR_Data_u <= unsigned(o_LFSR_Data_aux);

	LED_OUT <= o_LFSR_Data_aux(9 DOWNTO 0);

	PROCESS (F_CLOCK, RESET, COMIDA)
		VARIABLE count : INTEGER RANGE 0 TO 50_000_000 := 0;
		VARIABLE flag_comida : STD_LOGIC;
	BEGIN

		IF (RESET = '0') THEN
			RGBp <= (OTHERS => '0');
		ELSIF RISING_EDGE(F_CLOCK) THEN
			RGBp <= RGBn;
			count := count + 1;
		END IF;

		FOR m IN 0 TO 100 LOOP
			IF (COBRA_MORTA_X(m) > 0 AND COBRA_MORTA_Y(m) > 0) THEN
				qnt_atual_comida <= qnt_atual_comida + 2;
				COMIDA(qnt_atual_comida) <= COBRA_MORTA_X(m);
				COMIDA(qnt_atual_comida + 1) <= COBRA_MORTA_Y(m);
			END IF;
		END LOOP;

		IF (count < 50_000_000) THEN
			--- DESENHAR MAPA ---
			flag_comida := '0';
			FOR k IN 0 TO MAX_COMIDA * 2 - 1 LOOP
				IF (F_COLUMN > COMIDA(k) AND F_COLUMN < COMIDA(k) + 10 AND F_ROW > COMIDA(k + 1) AND F_ROW < COMIDA(k + 1) + 10) THEN
					flag_comida := '1';
				END IF;
				-- IF (F_COLUMN IN COMIDA) THEN
				-- 	flag_comida := '1'
				-- 	END IF;
			END LOOP;

			IF (flag_comida = '1') THEN
				RGBn <= "100";
			ELSIF (F_COLUMN = 0 OR F_COLUMN = 799 OR F_ROW = 0 OR F_ROW = 599) THEN
				RGBn <= "100";
			ELSE
				RGBn <= "111";
			END IF;
			--- FIM DESENHAR MAPA ---
		ELSE
			i <= i + 50;
			IF (i > 800) THEN
				i <= 0;
			ELSE
				-- i <= (i/2) * 23 + 783;
				-- IF ((i) * 5 + to_integer(o_LFSR_Data_u) > 800) THEN
				-- 	i <= 0;
				-- ELSE
				-- 	i <= (i) * 5 + to_integer(o_LFSR_Data_u);
				-- END IF;
			END IF;

			j <= j + 50;
			IF (j > 600) THEN
				j <= 0;
			ELSE
				-- j <= (j/2) * 37 + 582;
				-- IF ((j) * 3 + to_integer(o_LFSR_Data_u) > 600) THEN
				-- 	j <= 0;
				-- ELSE
				-- 	j <= (j) * 3 + to_integer(o_LFSR_Data_u);
				-- END IF;
			END IF;

			IF (qnt_atual_comida < MAX_COMIDA * 2 - 1) THEN
				qnt_atual_comida <= qnt_atual_comida + 2;
				COMIDA(qnt_atual_comida) <= i;
				COMIDA(qnt_atual_comida + 1) <= j;
			END IF;

			count := 0;
		END IF;
	END PROCESS;
END ARCHITECTURE arch;