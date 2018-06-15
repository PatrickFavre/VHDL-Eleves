-----------------------------------------------------------------------------------//
-- Nom du projet 		    : DutyCycle
-----------------------------------------------------------------------------------//
-- Nom du projet 		    : DutyCycle
-- Nom du fichier 		    : DutyCycle.vhd
-- Date de cr�ation 	    : 03.05.2018
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
-- D�claration des librairies standart pour le VHDL -- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Duty_Cycle is
	port (
	-- Entr�e --

	clk_1M8 : in std_logic ;					-- Clock du signal d'horloge
	PECS12 : in std_logic;						-- Bouton de s�lection fr�quence
	
	-- Sortie --
	D7, D9, D10, D11, D8 : out std_logic		-- Led s�lection de la fr�quence
	
);
end Duty_Cycle; 

architecture ARCH_DUTY_CYCLE of Duty_Cycle is 
---------------------------------------------------------------------------------
------------------- Composant du compteur qui compte de 0 � 100 -----------------
-- D�claration de l'architecture --
	Component Composant_Compteur is
	port (
	-- Entr�e --
	clk_1M8_1 : in std_logic 			-- Clock du signal d'horloge
);
end Component;

--------------------------- Composant selection Frequence -----------------------------
-- D�claration de l'architecture --
	Component Composant_Frequence is
	port (
	-- Entr�e --

	clk_1M8_2 : in std_logic ;						-- Clock du signal d'horloge
	PECS : in std_logic;
	
	-- Sortie --
	D7A, D9A, D10A, D11A, D8A : out std_logic		-- Led s�lection de la fr�quence 
);
end Component ;

-------------------------------- Composant AntiRebond ----------------------------------

-- d�claration de l'entit� (Entr�es / Sorties) 
Component ANTIREBOND is
	port(
		-- Entr�e -- 
		SW_X : in std_logic; 
		nRST : in std_logic; 
		CLK	 : in std_logic; 
		
		-- Sortie -- 
		SW_OUT_P : out std_logic
	);
end Component ;

----------------------------- D�claration des composants -------------------------------
begin

-- Compteur jusqu'� 100 --
CompCompteur : Composant_Compteur port map (clk_1M8_1 => clk_1M8); 
---------------------------------------------------------------------------------
-- AntiRebond --
CompAntiRebond : ANTIREBOND port map (SW_X => PECS12, CLK => clk_1M8, 
									  SW_OUT_P => PECS); 
---------------------------------------------------------------------------------
-- S�lection des fr�quences  --
CompSelectFreq : Composant_Frequence port map (clk_1M8_2 => clk_1M8,
											  D7A => D7, D8A => D8, D9A => D9, 
											  D10A => D10, D11A => D11, PECS => PECS12); 
---------------------------------------------------------------------------------
end ARCH_DUTY_CYCLE; 