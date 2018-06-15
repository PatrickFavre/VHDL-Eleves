



-- Matrice 8X8. Debut tableau dans l archi + repris COMPTEUR et CLOCK 2Hz du projet feux


--14.12, 15h19
--Library
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops

--------------------------------------------------------------------------------------------------
entity entite is 
port(
S1 : in std_logic ;
clk : in std_logic ;
Mode : in std_logic_vector(0 to 1);   -- choix d un des 4 modes en binaire
Port_1: out std_logic_vector(0 to 7);
Port_2: out std_logic_vector(0 to 7);
Port_7seg_1: out std_logic_vector(0 to 7); --port pour septseg 1
Port_7seg_2: out std_logic_vector(0 to 7)--port pour septseg 2
);
end entite;

------------------------------------------------------------------------------------------------

architecture archi of entite is
signal tailleT : integer := 7;	--à modifier par raport à un coté de la matrice - 1 ex: matrice 8x8 -> 8-1 = 7
type int is array(0 to tailleT, 0 to tailleT)of std_logic ; -- déclaration du tableau 2D 8X8(0 to 7)
signal nomtableau : int ;--faudrait definir le tableau en sortie
signal I1, I2 ,I3 : integer range 0 to tailleT := 0 ;--indices pour le système ligne colonne
signal animation : integer range 0 to 4 := 0;
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------


--signaux pour COMPTEUR ET CLOCK 2Hz
signal count: integer := 0 ; 
signal Hz2: std_logic := '0' ; 


begin

Port_7seg_1 <= "11100011"; -- On affiche L sur le sept segments de gauche
							--Sur le sept segments 2, on affihcera le numéro du mode
							
							
							
CHOIX : process (S1)
	begin
		if rising_edge(S1) then			-- <-- ATENTION TRèS CERTAINEMENT FAUX
			animation <= animation + 1;
		end if;
	end process CHOIX;
	
	
INIT2DT : process (animation)			
	begin
		case animation is
			when 0 =>	--etient tout
				Port_7seg_2 <= "10001100";  --écrire le bon truc sur le 7 seg
				for I1 in 0 to tailleT loop
					for I2 in 0 to tailleT loop		--trouver un meilleur moyens(avec range si possible)
						nomtableau(I1,I2) <= '0';
					end loop;
				end loop;
			when 1 =>	--allume tout
				Port_7seg_2 <= "00011101";  --écrire le bon truc sur le 7 seg
				for I1 in 0 to tailleT loop			
					for I2 in 0 to tailleT loop
						nomtableau(I1,I2) <= '1';
					end loop;
				end loop;
			when 2 =>	--diagonale gauche droite
				Port_7seg_2 <= "10101101";  --écrire le bon truc sur le 7 seg
				for I1 in 0 to tailleT loop			
					for I2 in 0 to tailleT loop
						if I3 = 0 then
							I3 <= 1;			--diagonale dans un sens
							if I1 = I2 then	
								nomtableau(I1,I2) <= '1';
							else 
								nomtableau(I1,I2) <= '0';
							end if;
						elsif I3 = 1 then
							I3 <= 0;			--diagonale dans l'autre sens
							if I1 = tailleT - I2 then
								nomtableau(I1,tailleT-I2) <= '1';
							else 
								nomtableau(I1,tailleT-I2) <= '0';
							end if;
						else
							I3 <= 0;
						end if;
					end loop;
				end loop;
			when 3 =>	--carré-, carré de plus en plus petit
				Port_7seg_2 <= "10101010";  --écrire le bon truc sur le 7 seg
				for I1 in 0 to tailleT loop			
					for I2 in 0 to tailleT loop
						if I1 = I3 then
							nomtableau(I1,I2) <= '1';
						elsif tailleT - I1 = I3 then
							nomtableau(I1,I2) <= '1';
						elsif I2 = I3 then
							nomtableau(I1,I2) <= '1';
						elsif tailleT - I2 = 7 then
							nomtableau(I1,I2) <= '1';
						else
							nomtableau(I1,I2) <= '0';
						end if;
						if I3 = tailleT/2 then	--peut poser probleme avec les arondie 
							I3 <= 0;				--ou pour les matrice paire/impaire.
						else
							I3 <= I3 + 1;
						end if;
					end loop;
				end loop;
			when others =>	--carré+, carré de plus en plus grand
				Port_7seg_2 <= "11100100";  --écrire le bon truc sur le 7 seg
				for I1 in 0 to tailleT loop			
					for I2 in 0 to tailleT loop
						if I1 = I3 then
							nomtableau(I1,I2) <= '1';
						elsif tailleT - I1 = I3 then
							nomtableau(I1,I2) <= '1';
						elsif I2 = I3 then
							nomtableau(I1,I2) <= '1';
						elsif tailleT - I2 = 7 then
							nomtableau(I1,I2) <= '1';
						else
							nomtableau(I1,I2) <= '0';
						end if;
						if I3 = 0 then			--peut poser probleme avec les arondie 
							I3 <= tailleT/2;		--ou pour les matrice paire/impaire.
						else
							I3 <= I3 - 1;
						end if;
					end loop;
				end loop;
		end case;
	end process INIT2DT;
					
							

COMPTEUR : process (clk)------------------Process par le clock externe---------------------------------------------------------------------
	begin
		if ((clk'event) and clk = '1') then --Génération clock interne
			count <= (count + 1);
			if (count >= 921600) then
				count <= 0;
			end if ;
		end if ;
	end process COMPTEUR;----------------------------------------------------------------------------------------
		
CLOCK_2Hz : process (count)------------------------------------------------------------------------------------------------
	begin							
				if (count <= 460800)then
					Hz2 <= '1';
				elsif (count >= 921600)then
					Hz2 <= '0';						
				end if ;		
	end process CLOCK_2Hz;------------------------------------------------------------------------------
 


-----------------------------------------------------------------------------------------------------
--système ligne colonne(ESSAI TRUC NICO 17.05,15h09)

Matrice : process (nomtableau)
	begin
		for I1 in 0 to 7 loop
			case I1 is
				when 0 =>
				port_1 <= "10000000";
				when 1 =>
				port_1 <= "01000000";
				when 2 =>
				port_1 <= "00100000";
				when 3 =>
				port_1 <= "00010000";
				when 4 =>
				port_1 <= "00001000";
				when 5 =>
				port_1 <= "00000100";
				when 6 =>
				port_1 <= "00000010";
				when 7 =>
				port_1 <= "00000001";
				when others =>
				port_1 <= "00000000";
			end case;		
				for I2 in 0 to 7 loop
					if (nomtableau(I1,I2) >= '1')then
						case I2 is
							when 0 =>
							port_2 <= "10000000";
							when 1 =>
							port_2 <= "01000000";
							when 2 =>
							port_2 <= "00100000";
							when 3 =>
							port_2 <= "00010000";
							when 4 =>
							port_2 <= "00001000";
							when 5 =>
							port_2 <= "00000100";
							when 6 =>
							port_2 <= "00000010";
							when 7 =>
							port_2 <= "00000001";
							when others =>
							port_2 <= "00000000";
						end case;		
					else
						port_2 <= "00000000";
					end if;
				end loop;
		end loop ;
			
	end process Matrice ;
	
	
end archi ;

--PIN PLANNER avec comme choix X3 & X4 POUR LES PORTS DE SORTIE

--cahier des charges :

--Mode, on affiche L & le N° du mode sur les 7segements. 1Eteint 2Allumer 3diagonaleGD 4carré- 5carré+
--Faire avec un tableau dynamique

--regarder si besoin adapté avec les leds de la matrice, faire un vero

--les sorties sont actif HAUT pour les colonnes et BAS pour les lignes