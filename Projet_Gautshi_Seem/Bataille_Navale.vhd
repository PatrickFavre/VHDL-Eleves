library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity BATNAV is  --Monde réel (qu'est-ce qui rentre et qu'est-ce qui sort de la boite noire)
	port(

	--Entrées
	clk : in std_logic;		--Clock externe
	CodeurA : in std_logic;
	CodeurB : in std_logic;
	PressCode : in std_logic;
	--Sorties
	PortLettre : out std_logic_vector (0 to 7);
	PortChiffre : out std_logic_vector (0 to 7);
	SEG_CHIFFRE : out std_logic_vector(0 to 6); 		-- Affichage 7Seg -> ABCDEFG 
	SEG_LETTRE : out std_logic_vector(0 to 6) 		-- Affichage 7Seg -> ABCDEFG 
);
end BATNAV;

architecture ARCH_BATNAV of BATNAV is		-- "connectique" interne de la boite noire (fonctionnement  de la boite)
						
	signal ValCodeur : integer := 0;
	signal PressEncodeur : std_logic;
	signal VarTableauLettre : std_logic_vector(0 to 6);
	signal VarTableauChiffre : std_logic_vector(0 to 6);
	
	signal AntiRebond : std_logic;
	signal SansRebond : std_logic;
	signal SauvegardeB : std_logic;
	signal SauvegardeFlanc : std_logic;
	
	signal Compteur20ms : integer := 0;
	
	type TABLEAU is array (0 to 7) of std_logic_vector (0 to 7);
	type TB_AFF_VAL_NUM is array (0 to 7) of std_logic_vector(0 to 6); 	-- tableau de 10 cases => => type std_logic_vector 
	
	signal ARENE : TABLEAU := ("00000000",  --A
							   "00000000",  --B
						   	   "00000000",  --C
							   "00000000",  --D
							   "00000000",  --E
							   "00000000",  --F
							   "00000000",  --G
							   "00000000");  --H
--							   "0000000000",  --I
--							   "0000000000");  --J

	 
		
											 --ABCDEFG--
	constant AFF_NUM_1_8 : TB_AFF_VAL_NUM := ("1001111",  -- 1
											  "0010010",  -- 2 
											  "0000110",  -- 3
											  "1001100",  -- 4
											  "0100100",  -- 5
											  "0100000",  -- 6
											  "0001111",  -- 7
											  "0000000"); -- 8


	constant AFF_NUM_A_H : TB_AFF_VAL_NUM := ("0001000",  -- A
											  "1100000",  -- b
											  "1110010",  -- c
											  "1000010",  -- d
											  "0110000",  -- E
											  "0111000",  -- F
											  "0100001",  -- G
											  "1001000"); -- H
											  
											  
	
	
	component CLOCK is
	port(
		CLK_IN : in std_logic;						--Clock d'entrée
		
		ValMax : in std_logic_vector(0 to 23);		--Valeur de division du clock
		
		CLK_OUT	: out std_logic  					--Signal divisé
		
		);
	end component;
						
	---------------------

	-- début programme --
	---------------------
						
	begin 

	SEG_CHIFFRE <= VarTableauLettre;
	SEG_LETTRE <= VarTableauChiffre;

	LECTURE_CODEUR : process (CodeurA)
	begin
		if (falling_edge (CodeurA)) then
			AntiRebond <= not AntiRebond;
			SauvegardeB <= CodeurB;
		end if ;
	end process;
	
	ANTI_REBOND : process (clk)
	begin
	
		if (AntiRebond /= SauvegardeFlanc) then
			Compteur20ms <= Compteur20ms + 1;
			SauvegardeFlanc <= AntiRebond;
		elsif (AntiRebond = SauvegardeFlanc) then
			Compteur20ms <= 0;
		end if;
		if (Compteur20ms >= 5000) then
			SansRebond <= not SansRebond;
			Compteur20ms <= 0;
		end if;
	end process;
	
	
	
	AFF7SEG : process (ValCodeur)
	begin
		if (PressEncodeur = '0')then
			VarTableauLettre <= AFF_NUM_1_8(ValCodeur);
		elsif (PressEncodeur /= '0') then
			VarTableauChiffre <= AFF_NUM_A_H(ValCodeur);
		end if;
		
	end process ;
	
	
	ENTER_CODEUR : process (PressCode)
	begin
		if (falling_edge (PressCode)) then
			if (PressEncodeur = '0') then
				PressEncodeur <= '1';
			elsif (PressEncodeur /= '0') then
				PressEncodeur <= '0';
			end if;
		end if;
	
	end process ;

		
	VERIF_REBOND : process (SansRebond)
	begin
		if (CodeurA = '0') then
			if (SauvegardeB = '0') then			
				if (ValCodeur <= 7) then
					ValCodeur <= ValCodeur + 1;	
				elsif (ValCodeur > 7) then
					ValCodeur <= 8;
				end if;
			end if;
		
			if (SauvegardeB = '1') then			
				if (ValCodeur >= 0) then
					ValCodeur <= ValCodeur - 1;				
				elsif (ValCodeur < 1) then
					ValCodeur <= 0;
				end if;		
			end if;
		end if;
		
	end process;
















						
end ARCH_BATNAV;


