library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity scalar_product is
  generic (Ndata, Nbits : integer := 4);
  port (
    clk, reset : in  std_logic;
    a, b       : in  std_logic_vector(Ndata * Nbits - 1 downto 0);
    c          : out std_logic_vector(2 * Nbits - 1 downto 0)
  );
end entity;

architecture sp of scalar_product is
  signal a_reg, b_reg : std_logic_vector(Ndata * Nbits - 1 downto 0);
  signal index        : unsigned(Ndata - 1 downto 0);
  signal u, v         : std_logic_vector(Nbits - 1 downto 0);
  signal acc          : std_logic_vector(2 * Nbits - 1 downto 0);
begin

  mac_inst: entity work.mac
    generic map (Nbits => Nbits)
    port map (clk     => clk,
              reset   => reset,
              mac_a   => u,
              mac_b   => v,
              acc_out => acc);

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        a_reg <= a;
        b_reg <= b;
        u <= (others => '0');
        v <= (others => '0');
        index <= (others => '0');
      elsif index <= Ndata then
        -- shift right de Nbits à chaque cycle pour changer les entrées du MAC
        u <= a_reg(Nbits - 1 downto 0);
        v <= b_reg(Nbits - 1 downto 0);

        a_reg <= std_logic_vector(shift_right(unsigned(a_reg), Nbits));
        b_reg <= std_logic_vector(shift_right(unsigned(b_reg), Nbits));
        index <= index + 1;
      else
        c <= acc;
      end if;
    end if;
  end process;
end architecture;
