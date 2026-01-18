
library ieee;
  use ieee.std_logic_1164.all;

entity tb_mat_mul is
end entity;

architecture tb of tb_mat_mul is
  constant Nbits, Ndata, Mdata : integer := 4;

  signal clk, reset : std_logic;
  signal M_tb       : std_logic_vector(Mdata * Ndata * Nbits - 1 downto 0) := (others => '0');
  signal X_tb       : std_logic_vector(Ndata * Nbits - 1 downto 0)         := (others => '0');
  signal Y_tb       : std_logic_vector(Mdata * 2 * Nbits - 1 downto 0)     := (others => '0');

begin

  dut: entity work.mat_mul
    generic map (Nbits => Nbits, Ndata => Ndata, Mdata => Mdata)
    port map (clk   => clk,
              reset => reset,
              M     => M_tb,
              X     => X_tb,
              Y     => Y_tb);

  process
  begin
    clk <= '1';
    wait for 2 ns;
    clk <= '0';
    wait for 2 ns;
  end process;

  process
  begin
    report "Début de la simulation";

    reset <= '1';

    M_tb <= (others => '0');
    X_tb <= (others => '0');

    wait for 40 ns;

    M_tb(Ndata * Nbits - 1 downto 0) <= x"5671";
    M_tb(2 * Ndata * Nbits - 1 downto Ndata * Nbits) <= x"4321";
    M_tb(3 * Ndata * Nbits - 1 downto 2 * Ndata * Nbits) <= x"4500";
    M_tb(4 * Ndata * Nbits - 1 downto 3 * Ndata * Nbits) <= x"1352";
    X_tb <= x"1211";

    wait for 100 ns;
    reset <= '0';

    wait for 100 ns;
    report "Test Complete";
    wait;
  end process;

end architecture;

