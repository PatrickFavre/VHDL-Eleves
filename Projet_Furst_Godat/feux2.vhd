library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity GFeux is
	port
	(
	
	S9 : in STD_LOGIC;
	
	clk_1M8 : in STD_LOGIC;
	Led_123 : out STD_LOGIC_VECTOR(2 downto 0);
	Led_456 : out STD_LOGIC_VECTOR(2 downto 0)
--	LedD1 : out STD_LOGIC; 
--	LedD2 : out STD_LOGIC; 
--	LedD3 : out STD_LOGIC;
--	LedD4 : out STD_LOGIC;
--	LedD5 : out STD_LOGIC;
--	LedD6 : out STD_LOGIC

	);
	end GFeux;
	
	architecture GESTION_FEUX of GFeux is
	
	signal cpt1,cpt2,cpt5s,i,delay2 : integer :=0;
	signal flag_delay2 : integer :=0;
	signal flag_delay5 : integer :=0;
	signal start : integer :=1;
	signal S9valid : integer :=0;
	signal etat: integer :=0;
	signal S_Led_123 : STD_LOGIC_VECTOR (2 downto 0);
	signal S_Led_456 : STD_LOGIC_VECTOR (2 downto 0);
	signal Hz2: STD_LOGIC;
	signal Hz10: STD_LOGIC;
	
	begin
	
	process(start)
	begin
		if(start = 1) then
--			LedD2 <= Hz2;
--			LedD5 <= Hz2;
			S_Led_123 (1) <= Hz2;
			S_Led_456 (1) <= Hz2;		
		end if;
	end process;	
	
	process(clk_1M8)    					--utilisation du quartz de 1.8MHz de la carte
		begin	
			if (rising_edge(clk_1M8)) then
				if(cpt1 < 921600) then			--création d'un compteur pour diviser la fréquence du clock			
					cpt1 <= cpt1+1;				-- 1843200 / 2 = 921600
				else				
					cpt1 <= 0;				
				end if;
				if(cpt2 < 184320) then			--création d'un compteur pour diviser la fréquence du clock			
					cpt2 <= cpt2+1;				-- 1843200 / 10 = 184320
				else				
					cpt2 <= 0;				
				end if;			
			end if;	
	end process;
	
	process(cpt1) 
		begin	
			if (cpt1 < 460800) then				--utilisation du compteur pour générer une f de 2Hz
												
					Hz2 <= '1';
			else
					Hz2 <= '0';					
			end if;
			
	end process;
	
	process(cpt2) 
		begin	
			if (cpt2 < 92160) then				--utilisation du compteur pour générer une f de 2Hz
												
					Hz10 <= '1';
			else
					Hz10 <= '0';					
			end if;
			
	end process;
	
	
	process(Hz2)
		begin
			if rising_edge(Hz2) then
				if (flag_delay2 = 1) then
					if (i < 4) then 
						i <= i+1;
					else 
						i <= 0;
					end if;
				elsif (S9 = '1') then 
					i <= 0; 
				end if; 
			end if;
	end process;
	
	process(i)
	begin
		if(i >= 4) then
			delay2 <= 1;
		else 
			delay2 <= 0;
		end if;
	end process;
	
	process(Hz10)
		begin
			if (rising_edge(Hz10)) then
				if (S9 = '0') then
					if (S9valid = 0)then
						flag_delay2 <= 1;
						if (delay2 = 1) then
							flag_delay2 <= 0;
							S9valid <= 1;
							flag_delay5 <= 1;
							etat <= 1;
							start <= 0;
						end if;
					end if;
				else
					flag_delay2 <= 0;
				end if;
			end if;
	end process;
	
	process(Hz2)
		begin
			if (rising_edge(Hz2)) then
				if(flag_delay5 = 1) then
					flag_delay5 <= 0;
					cpt5s <= 0;
				elsif (cpt5s >= 10) then 
					cpt5s <= 0;
				else
					cpt5s <= cpt5s +1;
				end if;
			end if;
	end process;
	
	process(cpt5s)
		begin
			if(cpt5s >= 10) then
				etat <= etat +1;
				
			end if;	
	end process;
	
	
	process(etat)
	begin
		if(etat = 1) then
			S_Led_123 <= "101";
			S_Led_456 <= "111";	
		elsif (etat = 2) then
			S_Led_123 <= "011";
			S_Led_456 <= "111";
		elsif (etat = 3) then
			S_Led_123 <= "111";
			S_Led_456 <= "101";
		elsif (etat = 4) then
			S_Led_123 <= "111";
			S_Led_456 <= "110";
		elsif (etat = 5) then
			S_Led_123 <= "111";
			S_Led_456 <= "101";
		elsif (etat = 6) then
			S_Led_123 <= "111";
			S_Led_456 <= "011";
		elsif (etat = 7) then
			S_Led_123 <= "101";
			S_Led_456 <= "111";
		elsif (etat = 8) then
			S_Led_123 <= "110";
			S_Led_456 <= "111";
		elsif (etat = 0) then
		
		end if;
		
	end process;
	
	Led_123 <= S_Led_123;
	Led_456 <= S_Led_456;
	
	end GESTION_FEUX;