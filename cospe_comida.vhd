package cobra is 
	type INT_VECTOR IS ARRAY (60 downto 0) OF INTEGER RANGE 0 TO 100;
	TYPE T_COMIDA IS ARRAY(10 * 2 + 1 DOWNTO 0) OF INTEGER; --CORRIGIR 10 para max comida
end package;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.cobra.all;

entity cospe_comida is
   generic (
		MAX_FOOD 	: integer := 10
	);
   port (									 
			clk, morre_p1, morre_p2 	 								: 	in  std_logic;			
			estadoJogo 	 					 								: 	in  natural range 1 to 3;
			x_jogador_1,y_jogador_1, x_jogador_2, y_jogador_2	: 	in  INT_VECTOR;			
			x_novas_comidas, y_novas_comidas							: 	out T_COMIDA	
	 );
end entity;

library ieee; use ieee.numeric_std.all;

architecture cospe_comidaa of cospe_comida is
begin
	
	process(clk)
		variable k, i : NATURAL := 0;
	begin
	
		if estadoJogo = 1 then
			--nao faz nada	
		elsif estadoJogo = 2 then
			k := 0;
			if rising_edge(clk) then
				if (morre_p1 = '1') then					
					while i < (10 * 2 + 1) loop --mudar para constante max comidas
						x_novas_comidas(i) <= x_jogador_1(k);
						y_novas_comidas(i) <= y_jogador_1(k);
						k := k+2;
						i := i+1;
					end loop;
				end if;
			end if;
			
			if rising_edge(clk) then
				if (morre_p2 = '1') then					
					while i < (10 * 2 + 1) loop --mudar para constante max comidas
						x_novas_comidas(k) <= x_jogador_2(k);
						y_novas_comidas(k) <= y_jogador_2(k);
						k := k+2;
						i := i+1;
					end loop;
				end if;
			end if;
		elsif estadoJogo = 3 then
			--nao faz nada
		end if;
			
	end process;
	
end architecture;
