-- Produit matriciel M@X=Y

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mat_mul is
  generic (Nbits, Ndata, Mdata : integer := 4);
  port (
    clk, reset : in  std_logic;
    M          : in  std_logic_vector(Mdata * Ndata * Nbits - 1 downto 0);
    X          : in  std_logic_vector(Ndata * Nbits - 1 downto 0);
    Y          : out std_logic_vector(Mdata * (2 * Nbits) - 1 downto 0)
  );
end entity;

architecture rtl of mat_mul is
begin

  gen: for i in 0 to Mdata - 1 generate
    sp_inst: entity work.scalar_product
      generic map (Ndata => Ndata, Nbits => Nbits)
      port map (clk   => clk,
                reset => reset,
                a     => M((i + 1) * Ndata * Nbits - 1 downto i * Ndata * Nbits),
                b     => X(Ndata * Nbits - 1 downto 0),
                c     => Y((i + 1) * 2 * Nbits - 1 downto i * 2 * Nbits));
  end generate;

end architecture;
