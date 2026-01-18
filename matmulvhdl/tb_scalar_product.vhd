library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_sp is
end entity;

architecture tb of tb_sp is
  constant Nbits, Ndata : integer := 4;

  signal clk, reset : std_logic;
  signal a_tb       : std_logic_vector(Ndata * Nbits - 1 downto 0) := (others => '0');
  signal b_tb       : std_logic_vector(Ndata * Nbits - 1 downto 0) := (others => '0');
  signal c_tb       : std_logic_vector(2 * Nbits - 1 downto 0)     := (others => '0');

begin

  dut: entity work.scalar_product
    generic map (Ndata => Ndata, Nbits => Nbits)
    port map (clk   => clk,
              reset => reset,
              a     => a_tb,
              b     => b_tb,
              c     => c_tb);

  process
  begin
    -- période de 4ns
    clk <= '1';
    wait for 2 ns;
    clk <= '0';
    wait for 2 ns;
  end process;

  process
  begin
    report "Début de la simulation";

    -- Initialisation
    reset <= '1';

    a_tb <= x"2321";
    b_tb <= x"1456";
    wait for 40 ns;
    reset <= '0';
    wait for 40 ns;
    assert to_integer(unsigned(c_tb)) = 30
      report "Test: (1,2,3,2) @ (6,5,4,1) = 30 (FAILED)";

    a_tb <= x"1FFF";
    b_tb <= x"1FFF";
    wait for 40 ns;
    reset <= '1';
    wait for 40 ns;
    reset <= '0';
    wait for 40 ns;
    assert to_integer(unsigned(c_tb)) < 256 report "Test: (1,15,15,15)@(1,15,15,15) -> overflow (FAILED)";
    wait for 40 ns;
    report "Test Complete";

    wait;
  end process;

end architecture;
