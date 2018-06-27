library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity ------------------------------------------------------------------------------

entity entite is
port(
	clk : in std_logic;
	entree : in std_logic;
	sortieDebug : out std_logic;
	sortie_7seg : out std_logic_vector(0 to 6)
);
end entite;

-- Architecture ------------------------------------------------------------------------

architecture arch of entite is
	
	component rs_232_reception is
	port(
		Val_ligne : in std_logic;
		clk_1M8 : in std_logic;
		Caractere : out std_logic_vector(7 downto 0);
		sDebug : out std_logic;
		fin_trans : out std_logic
	);
	end component;

	signal lettreAff : std_logic_vector(7 downto 0);
	signal ready_fin : std_logic := '0';
	
	begin

	reception : rs_232_reception port map(	Val_ligne => entree,
											clk_1M8 => clk,
											Caractere => lettreAff,
											sDebug => sortieDebug,
											fin_trans => ready_fin);
											
	-- Ce process affiche le caractère reçu sur les affichage 7 segment lorsque 
	-- les données sont valides.
											
	process (lettreAff)
		begin
			if ready_fin = '1' then
				case (lettreAff) is
					when "01000110" => sortie_7seg 	<= "1110000";
						-- Afficher F
						
					when "01000001" => sortie_7seg 	<= "0010000";
						-- Afficher A
						
					when "01001110" => sortie_7seg 	<= "1010110";
						-- Afficher N
						
					when "01010010" => sortie_7seg 	<= "1110110";
						-- Afficher R
						
					when "01001111" => sortie_7seg	<= "0000001";
						-- Afficher O
						
					when "01000101" => sortie_7seg 	<= "1100000";
						-- Afficher E
						
					when "11111111" => sortie_7seg 	<= "1100000";
						-- Afficher E (Debug)
						
					when others => sortie_7seg 		<= "1111111";
						-- Afficher -
				end case;
			end if;
	end process;
	

end arch;
