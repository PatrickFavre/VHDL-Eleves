-- Compteur qui compte de 0 à 100 -- 
-- Déclaration des librairies standart pour le VHDL -- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Composant_Compteur is
	port (
	-- Entrée --

	clk_1M8_1 : in std_logic 			-- Clock du signal d'horloge
);
end Composant_Compteur ;
	
architecture ARCH_Composant_Compteur of Composant_Compteur is 

	signal count : integer := 0; 
	begin	

process (clk_1M8_1)
	begin
	if (rising_edge (clk_1M8_1)) then
		if count > 100 then
			count <= 0;
		else 
			count <= count + 1; 
		end if;
	end if ;
end process ; 
end ARCH_Composant_Compteur; 