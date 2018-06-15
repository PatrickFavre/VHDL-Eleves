library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity entite is
port(
		clk : in std_logic ;
		
		sortie : out std_logic
);
end entite;


architecture arch of entite is

	component rs_232_envoi is
	port(
			Val_ligne : out std_logic;
			enable : in std_logic;
			finTrans : out std_logic;
			readyEnvoi : out std_logic;
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
							
	signal i : integer := 0;
	signal toggleI : std_logic := '0';
	signal flagEnable : std_logic;
	signal flagFin : std_logic;
	signal flagReady : std_logic;
		
	begin
	
	

	envoi : rs_232_envoi port map(	enable => flagEnable,
									finTrans => flagFin,
									readyEnvoi => flagReady,
									clk_1M8 => clk,
									Caractere => tableau(4), 
									Val_ligne => sortie);
		
	process (flagReady, flagFin, toggleI)
		begin
			-- Traitement enable
			if flagFin = '1' then
				flagEnable <= '0';
				--if toggleI = '0' then
					i <= i + 1;
					--toggleI <= '1';	
					if i > 6 then
						i <= 6;
					end if;
				--end if;
			--else
				--toggleI <= '0';
			end if;
			
			if flagReady = '1' then
				flagEnable <= '1';
			end if;
	end process;
	
	

end arch;