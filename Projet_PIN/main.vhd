-----------------------------------------------------------------------------------//
-- Nom de code			    :naval task force feux rouge 
-- Nom du fichier 		    : main.vhd
-- Date de création 	    : 
-- Date de modification     :26.05.2017
-- Dernière modification 	:14.06.2017

-- Auteur 				    :je suuis une otarie
--
-- Description              : A l'aide d'une FPGA (EMP1270T144C5) et d'une carte 
--							  électronique créée par l'ETML-ES, 
--							  réalisation / simulation d'une gestion des feux d'un carrefour 
--
--
--							  configuration SW10 et SW11
--
--							      
-- Remarques 			    : lien
-- 							  1) https://fr.wikibooks.org/wiki/TD3_VHDL_Compteurs_et_registres
--								
----------------------------------------------------------------------------------//
-- déclaration standart des librairies standart pour le VHDL -- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;  
use ieee.numeric_std.all; 								-- pour les opérations mathématiques et convertion 

-- déclaration de l'entité (Entrées / Sorties) --

entity MAIN is
port (
		------------
		-- entrée --
		------------ 
		-- logique-- 
		
		CLK_int		: in std_logic;	--clock interne de 1.8432 MHz
		-- bus --
		S1,S2,S3,S4,S5,S6,S7,S8	: in std_logic;  -- switch physique N°9
		SEGMENTS_1 : out std_logic_vector(0 to 6);
		SEGMENTS_2 : out std_logic_vector(0 to 6);
		SReset		: in std_logic; -- switch de reset du programme
		
		
	    ------------
		-- sortie --
		------------ 
		
--		X10pin3		: out std_logic; --sortie de mesure sur la pin 3 du connecteur X10
--		X10pin4		: out std_logic; --sortie de mesure sur la pin 4 du connecteur X10
		
		LED_D1		: out std_logic;
		LED_D2		: out std_logic;
		LED_D3		: out std_logic;
		LED_D4		: out std_logic;
		LED_D5		: out std_logic;
		LED_D6		: out std_logic;
		LED_D8		: out std_logic;
		LED_D12		: out std_logic;
		LED_D13		: out std_logic
		
);
end MAIN;




architecture feux_rouge of MAIN is
signal waiting : std_logic;
signal clk_2Hz : std_logic;
signal Tic : integer range 0 to 1000000;
signal blink : std_logic;
signal index : integer;
signal Attente : integer;
signal etat : integer;
signal entree_A, entree_B : std_logic_vector (0 to 3);
signal code_verrou : std_logic_vector (0 to 7);
signal code_table : std_logic_vector (0 to 2);
signal S : std_logic;
signal Cout : std_logic;
signal suiveur : std_logic_vector (0 to 1);
--début programme --
	begin
	
		entree_A <= (S1,S2,S3,S4);
		entree_B <= (S5,S6,S7,S8);
		code_verrou <= (S1,S2,S3,S4,S5,S6,S7,S8);
		code_table <= (S1,S2,S3);
		LED_D1 <= S;
		LED_D2 <= Cout;
		--suiveur_7_segment <= (S10,S11);

	-- gestion des sorties 
	LED_D8 <= clk_2Hz; 



 comparaison : process (entree_A,entree_B)
	begin
		
			if (entree_A = entree_B) then
				SEGMENTS_1 <="0110000";
				SEGMENTS_2 <="0110000";
			end if;
				
			if (entree_A < entree_B) then
				SEGMENTS_1 <="0011000";
				SEGMENTS_2 <="0011000";
			end if;
				
			if (entree_A > entree_B) then
				SEGMENTS_1 <="0011000";
				SEGMENTS_2 <="0100000";
			end if;
end process;

verrouillage : process (code_verrou) --code pour le systeme de verrou 
	begin
			
			if (code_verrou = "01010111") then --interru <- de droite a gauche par apport au7seg // code a faire pour lever le verrou
				LED_D12 <= '0';
				LED_D13 <= '1';
			else
				LED_D12 <= '1';
				LED_D13 <= '0';
			end if;
			
end process;
				
----mode_1 : process (Switch)
----begin
----	 etat_led is
----	SIGNAL COUNT : interger := 0;
----	begin
---- 
----		case SW_6, SW_7, SW_8 is
----
----			when "0001" => SEGMENTS_1 <="1001111";
----						  
----			when "0010" => SEGMENTS_1 <="0010010";
----						  
----			when "0011" => SEGMENTS_1 <="0000110";
----						  
----			when "0100" => SEGMENTS_1 <="1001100";
----						  
----		    when "0101" => SEGMENTS_1 <="0100100";
----						  
----			when "0110" => SEGMENTS_1 <="0100000";
----						  
----			when "0111" => SEGMENTS_1 <="0001111";
----						  
----			when "1000" => SEGMENTS_1 <="0000000";
----						  
----			when "1001" => SEGMENTS_1 <="0000100";
----						  
----			when "1010" => SEGMENTS_1 <="0001000";A
----						 
----			when "1011" => SEGMENTS_1 <="1100000";b
----						 
----			when "1100" => SEGMENTS_1 <="1100010";c
----						  
----			when "1101" => SEGMENTS_1 <="1000010";d
----						  
----			when "1110" => SEGMENTS_1 <="0110000";
----						  
----			when "1111" => SEGMENTS_1 <="0001110";
----						 
--			
--		
----
process(code_table)
begin
    case code_table is
        when "001" => S <= '1';
        when "010" => S <= '1';
        when "100" => S <= '1';
        when "111" => S <= '1';
        when "011" => Cout <= '1'; 
        when others => S <='0';
        
        when "00 => Cout 
    end case;
end process;
--	Cout <= '0' when "000",
--	Cout <= '0' when "001",
--	Cout <= '0' when "010",
--	Cout <= '0' when "100",
--	Cout <= '1' when "others";
	
	
--Suiveur_7_segment : process (suiveur)
--	begin
--		
--		if(suiveur = "00") then
--			SEGMENTS_1 <= 
--	
--				
--end process;			
-----------------------------------------------------------------------
		compteur : process (CLK_int)
			begin

				if(CLK_int'event and CLK_int = '1') then
			
					if (Tic < 921600)then
						Tic <= Tic + 1;
					else 
						Tic <= 0;
					end if;
							
			end if;
			
			
		end process;
			
			clock2hz : process (Tic)
			begin

				--if(Tic = 1) then
			
					if (Tic < 460800)then
						clk_2Hz <= '1';
					else 
						clk_2Hz <= '0';
					end if;
							
			--end if;
			
			
		end process;
------------------------------------------------------------------------				
	clignottement : process (clk_2Hz) -- process utilisé pour le clignotement
	begin
		if (clk_2Hz'event) and clk_2Hz = '1'then 
			
			if blink = '1'then
				blink <= '0';
			else
				blink <= '1';
			end if;
			
		end if;
	end process;

			
			

--------------------------------------------------------------------------
changementetats : process (clk_2Hz)
begin
if (clk_2Hz'event) and clk_2Hz = '1'then 
	if (waiting = '1') then
		if index > (Attente-2) then --Attente = nbr de seconde -2 (tester et modifier en fct de la realité)
			index <= 0;
			if etat < 10 then --test si on est au dernier état on reviens au début
				etat <= etat + 1;
			else
				etat <= 1;
			end if;
		else
			index <= index + 1;
		end if;
	else
		index <= 0;
	
	end if;
	
	if SReset = '0' then --test du bouton reset
		etat <= 0;
	end if;
	
end if;
end process; 


end architecture;








