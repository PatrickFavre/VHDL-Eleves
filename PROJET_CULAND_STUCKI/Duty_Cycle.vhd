-----------------------------------------------------------------------------------//
-- Nom du projet 		    : DutyCycle
-----------------------------------------------------------------------------------//
-- Nom du projet 		    : DutyCycle
-- Nom du fichier 		    : DutyCycle.vhd
-- Date de création 	    : 03.05.2018
-- Date de modification     : 15.03.2018
--
-- Auteurs 				    : Julie Culand
--							: Alain Stucki
--
-- Description              : 
--							
--
-- Remarques 			    : lien
-- 							 
----------------------------------------------------------------------------------//
-- Déclaration des librairies standart pour le VHDL -- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Duty_Cycle is
	port (
	-- Entrée --

	clk_1M8 : in std_logic ;					-- Clock du signal d'horloge
	PECS12 : in std_logic;						-- Bouton de sélection fréquence
	
	-- Sortie --
	D7, D9, D10, D11, D8 : out std_logic		-- Led sélection de la fréquence
	
);
end Duty_Cycle; 

architecture ARCH_DUTY_CYCLE of Duty_Cycle is 
---------------------------------------------------------------------------------
------------------- Composant du compteur qui compte de 0 à 100 -----------------
-- Déclaration de l'architecture --
	Component Composant_Compteur is
	port (
	-- Entrée --
	clk_1M8_1 : in std_logic 			-- Clock du signal d'horloge
);
end Component;

--------------------------- Composant selection Frequence -----------------------------
-- Déclaration de l'architecture --
	Component Composant_Frequence is
	port (
	-- Entrée --

	clk_1M8_2 : in std_logic ;						-- Clock du signal d'horloge
	PECS : in std_logic;
	
	-- Sortie --
	D7A, D9A, D10A, D11A, D8A : out std_logic		-- Led sélection de la fréquence 
);
end Component ;

-------------------------------- Composant AntiRebond ----------------------------------

-- déclaration de l'entité (Entrées / Sorties) 
Component ANTIREBOND is
	port(
		-- Entrée -- 
		SW_X : in std_logic; 
		nRST : in std_logic; 
		CLK	 : in std_logic; 
		
		-- Sortie -- 
		SW_OUT_P : out std_logic
	);
end Component ;

----------------------------- Déclaration des composants -------------------------------
begin

-- Compteur jusqu'à 100 --
CompCompteur : Composant_Compteur port map (clk_1M8_1 => clk_1M8); 
---------------------------------------------------------------------------------
-- AntiRebond --
CompAntiRebond : ANTIREBOND port map (SW_X => PECS12, CLK => clk_1M8, 
									  SW_OUT_P => PECS); 
---------------------------------------------------------------------------------
-- Sélection des fréquences  --
CompSelectFreq : Composant_Frequence port map (clk_1M8_2 => clk_1M8,
											  D7A => D7, D8A => D8, D9A => D9, 
											  D10A => D10, D11A => D11, PECS => PECS12); 
---------------------------------------------------------------------------------
end ARCH_DUTY_CYCLE; 