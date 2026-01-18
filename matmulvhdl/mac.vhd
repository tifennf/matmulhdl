library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity mac is
  generic (Nbits : integer := 4);
  port (
    clk, reset   : in  std_logic;
    mac_a, mac_b : in  std_logic_vector(Nbits - 1 downto 0);
    acc_out      : out std_logic_vector(2 * Nbits - 1 downto 0));
end entity;

architecture rtl of mac is
  signal oprod   : std_logic_vector(2 * Nbits - 1 downto 0);
  signal acc_reg : std_logic_vector(2 * Nbits - 1 downto 0);
begin

  mul_inst: entity work.mul
    generic map (
      Nbits => Nbits
    )
    port map (
      a => mac_a,
      b => mac_b,
      y => oprod
    );

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        acc_reg <= (others => '0');
      else
        acc_reg <= std_logic_vector(unsigned(oprod) + unsigned(acc_reg));
      end if;
    end if;
  end process;

  acc_out <= acc_reg;
end architecture;
