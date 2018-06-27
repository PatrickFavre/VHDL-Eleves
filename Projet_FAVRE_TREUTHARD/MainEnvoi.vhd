library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity entite is
port(
		clk : in std_logic ;
		
		sortie : out std_logic;
		
		sortieDebug : out std_logic
);
end entite;


architecture arch of entite is

	component rs_232_envoi is
	port(
			Val_ligne : out std_logic;
			finTrans : out std_logic;
			clk_1M8 : in std_logic ;
			Caractere : in std_logic_vector (7 downto 0)
	);
	end component;
	
	type TAB_CAR is array (0 to 9) of std_logic_vector(7 downto 0);
	signal tableau : TAB_CAR :=(	"01000110", --F
									"01000001", --A
									"01001110", --N
									"01000110", --F
									"01000001", --A
									"01010010", --R
									"01001111", --O
									"01001110", --N
									"01001110", --N
									"01000101"); --E
							
	signal flagFin : std_logic;
	signal compteur : integer := 0;
	signal enableChangeCaractere : std_logic := '0';
	signal debug : std_logic := '0';
	
	begin
	
	

	envoi : rs_232_envoi port map(	finTrans => flagFin,
									clk_1M8 => clk,
									Caractere => tableau(compteur), 
									Val_ligne => sortie);
		
	
	
	-- Process qui met enableChangeCaractere à '1' toutes les secondes pendant 1 coup de clock

	process (clk)
		variable tick : integer := 0;
		-- Toutes les secondes on mets "enableChangeCaractere" à '1'
		begin
		if rising_edge(clk) then
			tick := tick + 1;
			if tick = 1843200 then
				tick := 0;
				enableChangeCaractere <= '1';
				debug <= not(debug);
			else
				enableChangeCaractere <= '0';
			end if;
		end if;
	end process;
	
	
	-- Process qui incrémente la lettre à afficher lorsqu'aucun caractère n'est en court d'envoi
	
	process (clk)
		variable enable:std_logic := '0';
		begin
		if enableChangeCaractere = '1' then
			enable := '1';
			
		end if;
		
		if enable = '1' and flagFin = '1' then
			enable := '0';
			compteur <= compteur + 1;
			if compteur = 10 then
				compteur <= 0;
			end if;
		end if;
	end process;

	sortieDebug <= debug;

end arch;
