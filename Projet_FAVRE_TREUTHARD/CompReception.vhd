library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity ----------------------------------------------------------------------------------

entity rs_232_reception is
port(
	Val_ligne : in std_logic;
	clk_1M8 : in std_logic;
	Caractere : out std_logic_vector(7 downto 0);
	sDebug : out std_logic;
	fin_trans : out std_logic
);
end rs_232_reception;

-- Architecture ----------------------------------------------------------------------------

architecture RS_232_reception of rs_232_reception is
	signal start_trans : std_logic;
	signal demiIndex : integer := 0;
	signal toggleDebug : std_logic;
	begin 
		
	
	process (Val_ligne)
		begin

	end process;
	
	sDebug <=  toggleDebug;
	
	
	-- Process qui incrémente "demiIndex" deux fois plus vite que le baudrate de l'émetteur
	-- Tick = 1M8 / (9600 * 2) = ~93
	process (start_trans, clk_1M8)
			variable tick : integer := 0;
		begin
			if start_trans = '1' then
				if rising_edge(clk_1M8) then
					if tick < 93 then
						tick := tick + 1;
					else
						tick := 0;
						demiIndex <= demiIndex + 1;
						-- Une pin de debug est mise en place pour contrôler que le recepteur
						-- réagis bien lors de la réception
						--toggleDebug <= not(toggleDebug);
					end if;
				end if;
			else
				demiIndex <= 0;
				tick := 0;
			end if;
	end process;	
--			
--	-- Ce process récupère les différents bits sur le bus est les mets dans Caractere.
--	-- Le bit "fin_trans" est mis à 1 lorsque les données sont valides.
	process (Val_ligne, demiIndex)
			begin
			
			if Val_ligne = '1' then
				start_trans <= '1';
			elsif demiIndex = 21 and Val_ligne = '0' then 
				start_trans <= '0';
			end if;
	end process; 
--		
--		
	process (demiIndex)
		variable enableValue : std_logic := '0';
		begin 
			if start_trans = '1' then
				if enableValue = '1' then
					case(demiIndex) is
						when 3 =>
							toggleDebug <= not(toggleDebug);
							Caractere(0) <= Val_ligne;
							enableValue := '0';
						when 5 => 
							Caractere(1) <= Val_ligne;
							enableValue := '0';
						when 7 =>
							Caractere(2) <= Val_ligne;
							enableValue := '0';
						when 9 => 
							Caractere(3) <= Val_ligne;
							enableValue := '0';
						when 11 =>
							Caractere(4) <= Val_ligne;
							enableValue := '0';
						when 13 => 
							Caractere(5) <= Val_ligne;
							enableValue := '0';
						when 15 =>
							Caractere(6) <= Val_ligne;
							enableValue := '0';
						when 17 => 
							Caractere(7) <= Val_ligne;
							enableValue := '0';
						when 21 =>
							--start_trans <= '0';
							fin_trans <= '0';
							--toggleDebug <= not(toggleDebug);
						when others =>
							--enableValue := '1';
					end case;
					
				elsif demiIndex mod 2 = 0 then
					enableValue := '1';
				end if;
			end if;
	end process;

	


end RS_232_reception;
	
	
	
	
	
	
