-- S�lection Fr�quence --
-- Permet de s�lectionner, selon le switch, la fr�quence d�sir�e avec
-- le nombre de tics 
-- D�claration des librairies standart pour le VHDL -- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Composant_Frequence is
	port (
	-- Entr�e --

	clk_1M8_2 : in std_logic; 						-- Clock du signal d'horloge
	PECS : in std_logic;							-- Switch S12 
	
	-- Sortie --

	D7A, D9A, D10A, D11A, D8A, test : out std_logic			-- Led s�lection de la fr�quence 
	
);
end Composant_Frequence ;
		
architecture ARCH_Composant_Frequence of Composant_Frequence is 

	signal tic : integer := 0; 
	signal NbTics_Freq : integer := 0; 
	signal Incr : integer := 0; 
	signal clock_test : std_logic; 
		
	begin
		-- Compteur pour la s�lection des fr�quences 
process (PECS)
	begin
	if ( PECS = '0') then
		
		if  Incr > 3 then
			Incr <= 0;
		else
		
		Incr <= Incr + 1;
		end if;		
	end if;
	
end process;		
	
Selection_Frequence : process (clk_1M8_2, PECS, Incr)
	begin
	case Incr is 
		when 0 =>
				NbTics_Freq <= 1843200000; -- S�lection 1Hz
				D7A <= '0';
				D9A <= '1';
				D10A <= '1';
				D11A <= '1';

		when 1 =>
				NbTics_Freq <= 184320000 ; 	-- S�lection 10Hz
				D7A <= '1';
				D9A <= '0';
				D10A <= '1';
				D11A <= '1';
		when 2 =>
				NbTics_Freq <= 1843200 ; 	-- S�lection 1kHz
				D7A <= '1';
				D9A <= '1';
				D10A <= '0';
				D11A <= '1';
		when 3 =>
				NbTics_Freq <= 1843 ; 		-- S�lection 1MHZ
				D7A <= '1';
				D9A <= '1';
				D10A <= '1';
				D11A <= '0';
		when others =>
				NbTics_Freq <= 1843200000; -- S�lection 1Hz
				D7A <= '0';
				D9A <= '1';
				D10A <= '1';
				D11A <= '1';
	end case; 

		if (rising_edge (clk_1M8_2)) then
			tic <= tic + 1 ;
			if tic >= NbTics_Freq then
				tic <= 0;
			end if;
		end if ; 		
end process ; 		


	process (tic)
		begin 
			if (tic <= NbTics_Freq/2 ) then 
				clock_test <= '1'; 
			else 
				clock_test <= '0'; 
			end if;
	end process; 
	
	test <= clock_test; 
	
end ARCH_Composant_Frequence;