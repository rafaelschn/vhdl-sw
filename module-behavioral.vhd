
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity projeto_finalizado_vhdl_module is
    Port ( clock : in std_logic;
           reset : in std_logic;
           pin_s1 : in std_logic;
           pin_s2 : in std_logic;
           pin_s3 : in std_logic;
           pin_display_transistor : out std_logic_vector(3 downto 0);
           pin_display : out std_logic_vector(7 downto 0);
           pin_leds : out std_logic_vector(7 downto 0));
end projeto_finalizado_vhdl_module;

architecture Behavioral of projeto_finalizado_vhdl_module is

signal divisor_clock: integer range 50000000 downto 0 := 0;
signal leds: std_logic_vector (7 downto 0) := "00000000";
signal display_transistor: std_logic_vector (3 downto 0) := "1111";
signal display: std_logic_vector (7 downto 0) := "11111111";
signal unidade, dezena, centena, milhar: integer range 10 downto 0 := 0; -- Matrícula 3707
signal multiplex: integer range 1000000 downto 0 := 0;

begin

    process (clock, reset, pin_s1, pin_s2, pin_s3)
    begin
        if reset = '1' then -- reset do sistema
            divisor_clock <= 0;
			   multiplex <= 0;
			   unidade <= 0;
			   dezena <= 0;
			   centena <= 0;
			   milhar <= 0;
			   leds <= "00000000"; -- apaga todos os leds
			   display_transistor <= "0000"; -- liga todos os displays
			   --display <= "11000000"; -- mostra o valor zero nos displays
		  elsif clock = '1' and clock'event then -- clock geral do sistema
		
            if divisor_clock = 50000000 then -- passou 1 segundo (50MHz)
				
				    divisor_clock <= 0;
				
				    if pin_s1 = '1' then -- sequencial com os 8 leds do sistema
					     unidade <= 0;
			           dezena <= 0;
			           centena <= 0;
			           milhar <= 0;
						  if leds = "11111111" then -- conta até 255
						      leds <= "00000000";
					     else
						      leds <= leds + 1;
					     end if;
				    elsif pin_s2 = '1' then -- contador crescente de 0 até 7
			           centena <= 0;
			           milhar <= 0;
						  leds <= "00000000";
						  if dezena = 0 and unidade = 7 then
						      dezena <= 0;
						      unidade <= 0;
					     elsif unidade = 9 then
						      unidade <= 0;
						      dezena <= dezena + 1;
					     else
						      unidade <= unidade + 1;
					     end if;
				    elsif pin_s3 = '1' then -- contador decrescente 37 a zero
					     unidade <= 0;
			           dezena <= 0;
						  leds <= "00000000";
						  if milhar = 0 and centena = 0 then
						      milhar <= 3;
						      centena <= 7;
					     elsif centena = 0 then
						      centena <= 9;
						      milhar <= milhar - 1;
					     else
						      centena <= centena - 1;
					     end if;
				     else -- nenhuma chave ativa
					      unidade <= 0;
					      dezena <= 0;
					      centena <= 0;
					      milhar <= 0;
					      leds <= "00000000";
				     end if;

			   else
				    divisor_clock <= divisor_clock + 1;
				    multiplex <= multiplex + 1;
			   end if; -- endif 1 seg

			   if multiplex = 1000000 then
				    multiplex <= 0;
				    display_transistor <= "0111"; -- liga milhar
				    if    milhar = 0 then display <= "11000000"; -- 0
				    elsif milhar = 1 then display <= "11111001"; -- 1
				    elsif milhar = 2 then display <= "10100100"; -- 2
				    elsif milhar = 3 then display <= "10110000"; -- 3
				    elsif milhar = 4 then display <= "10011001"; -- 4
				    elsif milhar = 5 then display <= "10010010"; -- 5
				    elsif milhar = 6 then display <= "10000010"; -- 6
				    elsif milhar = 7 then display <= "11111000"; -- 7
				    elsif milhar = 8 then display <= "10000000"; -- 8
				    elsif milhar = 9 then display <= "10010000"; -- 9
				    end if;
			   elsif multiplex = 750000 then
				    display_transistor <= "1011"; -- liga centena
				    if    centena = 0 then display <= "11000000";
				    elsif centena = 1 then display <= "11111001";
				    elsif centena = 2 then display <= "10100100";
				    elsif centena = 3 then display <= "10110000";
				    elsif centena = 4 then display <= "10011001";
				    elsif centena = 5 then display <= "10010010";
				    elsif centena = 6 then display <= "10000010";
				    elsif centena = 7 then display <= "11111000";
				    elsif centena = 8 then display <= "10000000";
				    elsif centena = 9 then display <= "10010000";
				    end if;
			   elsif multiplex = 500000 then
				    display_transistor <= "1101"; -- liga dezena
				    if    dezena = 0 then display <= "11000000";
				    elsif dezena = 1 then display <= "11111001";
				    elsif dezena = 2 then display <= "10100100";
				    elsif dezena = 3 then display <= "10110000";
				    elsif dezena = 4 then display <= "10011001";
				    elsif dezena = 5 then display <= "10010010";
				    elsif dezena = 6 then display <= "10000010";
				    elsif dezena = 7 then display <= "11111000";
				    elsif dezena = 8 then display <= "10000000";
				    elsif dezena = 9 then display <= "10010000";
				    end if;
			   elsif multiplex = 250000 then
				    display_transistor <= "1110"; -- liga unidade
				    if    unidade = 0 then display <= "11000000";
				    elsif unidade = 1 then display <= "11111001";
				    elsif unidade = 2 then display <= "10100100";
				    elsif unidade = 3 then display <= "10110000";
				    elsif unidade = 4 then display <= "10011001";
				    elsif unidade = 5 then display <= "10010010";
				    elsif unidade = 6 then display <= "10000010";
				    elsif unidade = 7 then display <= "11111000";
				    elsif unidade = 8 then display <= "10000000";
				    elsif unidade = 9 then display <= "10010000";
				    end if;
			   end if; -- endif multiplex

        end if; -- endif clock
    end process;	

    pin_leds <= leds;
    pin_display_transistor <= display_transistor;
    pin_display <= display;

end Behavioral;
