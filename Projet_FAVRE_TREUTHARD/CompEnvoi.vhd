library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




entity rs_232_envoi is
port(
		Val_ligne : out std_logic;
		finTrans : out std_logic;
		clk_1M8 : in std_logic ;
		Caractere : in std_logic_vector (7 downto 0)
);
end rs_232_envoi;

architecture RS_232_envoi of rs_232_envoi is

	signal index : integer := -1;  
	signal tick_envoi : integer := 0;
	signal compteur :integer := 0;
	
	begin 
	
	-- Process qui s'occupe de balayer l'index de 0 à 9 à 9600 [bd] et qui met 5ms entre chaque trame
	
	clock:process(clk_1M8)
		begin
		if (rising_edge(clk_1M8)) then
			tick_envoi <= tick_envoi+1;
			-- Si on est dans la phase d'attente de 5 ms
			if index = 9 then
				finTrans <= '1';
				if tick_envoi > 9000 then
					index <= -1;
					tick_envoi <= 0;
				end if;
			-- Si on est dans la phase de transmission
			else
				finTrans <= '0';
				if tick_envoi > 186 then
					index <= index + 1;
					tick_envoi <= 0;
				end if;
			end if;
		end if;
	end process;
	
	

	-- Process qui met 1 ou 0 sur la ligne de communication selon l'index
	
	envoi:process(index)
		begin
			if index = 0 then
				Val_ligne <= '1'; -- Start bit
			elsif index = 9 then
				Val_ligne <= '0'; -- Stop bit
			else
				Val_ligne <= Caractere(index - 1); -- Valeur dépendante du caractère
			end if;
	end process;
end RS_232_envoi;
	
	
	
	
	
	
	
	
	
	
	
	
	
