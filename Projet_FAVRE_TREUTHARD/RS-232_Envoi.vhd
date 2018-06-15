library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




entity rs_232_envoi is
port(
		Val_ligne : out std_logic;
		enable : in std_logic;
		finTrans : out std_logic;
		readyEnvoi : out std_logic;
		
		clk_1M8 : in std_logic ;
		Caractere : in std_logic_vector (7 downto 0)
);
end rs_232_envoi;

architecture RS_232_envoi of rs_232_envoi is

	signal clock_envoi : std_logic;
	signal index : integer := -1;  
	signal enable_prec : std_logic;
	signal tick_envoi : integer := 0;
	signal compteur :integer := 0;
	
	begin 
	
	
	clock:process(clk_1M8, enable)
		begin
		if (rising_edge(clk_1M8)) then
			if enable = '1' then
				readyEnvoi <= '0';
				if tick_envoi < 187 then
					tick_envoi <= tick_envoi+1;
				else 
					tick_envoi <= 0;
					index <= index+1;
					if index >= 9 then
						index <= 9;
						finTrans <= '1';
					else
						finTrans <= '0';
					end if;	
				end if; 
			else
				tick_envoi <= tick_envoi + 1;
				if(tick_envoi > 9000) then	-- On a passer 5ms
					readyEnvoi <= '1';
				end if;
				index <= -1;
			end if;	
		end if;	
	end process;
	
	

	
	envoi:process(clock_envoi, index)
		
		begin
			case(index) is
				when 0 => Val_ligne <= '1';
				
				when 1 => Val_ligne <= Caractere(0);
				
				when 2 => Val_ligne <= Caractere(1);
				
				when 3 => Val_ligne <= Caractere(2);
				
				when 4 => Val_ligne <= Caractere(3);
				
				when 5 => Val_ligne <= Caractere(4);
				
				when 6 => Val_ligne <= Caractere(5);
				
				when 7 => Val_ligne <= Caractere(6);
			
				when 8 => Val_ligne <= Caractere(7);
				
				when 9 => Val_ligne <= '0';
				
				when others => Val_ligne <= '0';
			end case;
	end process;
end RS_232_envoi;
	
	
	
	
	
	
	
	
	
	
	
	
	