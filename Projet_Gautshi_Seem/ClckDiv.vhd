library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;  
use ieee.numeric_std.all; 	


entity CLOCK is 
	port(
			CLK_IN : in std_logic;						--Clock d'entrée
			
			ValMax : in std_logic_vector(0 to 23);		--Valeur de division du clock
			
			CLK_OUT	: out std_logic  					--Signal divisé
		
		);
end CLOCK; 

architecture comp_clock of CLOCK is 
	
	signal ValMaxComp : integer := 0;
	signal Compteur : integer := 0;
	
	begin
	
		compteur2 <= to_integer(unsigned(ValMax));
	
	ClkCompte : process (CLK_IN)
	begin
		Compteur <= (Compteur + 1);
	end process;
	
	
	ClkDiv()
end architecture;