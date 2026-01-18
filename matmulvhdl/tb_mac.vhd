
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_mac is
end entity;

architecture tb of tb_mac is
  constant Nbits : integer := 4;

  signal a_tb       : std_logic_vector(Nbits - 1 downto 0)     := (others => '0');
  signal b_tb       : std_logic_vector(Nbits - 1 downto 0)     := (others => '0');
  signal acc_tb     : std_logic_vector(2 * Nbits - 1 downto 0) := (others => '0');
  signal clk, reset : std_logic;

begin

  dut: entity work.mac
    generic map (Nbits => Nbits)
    port map (mac_a   => a_tb,
              mac_b   => b_tb,
              acc_out => acc_tb,
              clk     => clk,
              reset   => reset);

  process
  begin
    --   période de 4ns
    clk <= '1';
    wait for 2 ns;
    clk <= '0';
    wait for 2 ns;
  end process;

  process
  begin
    report "Début de la simulation";

    reset <= '1';
    a_tb <= std_logic_vector(to_unsigned(2, Nbits));
    b_tb <= std_logic_vector(to_unsigned(3, Nbits));
    wait for 40 ns; -- on attend 10 cycles avant de lancer le calcul
    reset <= '0';
    wait for 40 ns;
    assert to_integer(unsigned(acc_tb)) = 60 report "Test: 10x3x2=60 (FAILED)";
    reset <= '1';
    a_tb <= std_logic_vector(to_unsigned(10, Nbits));
    b_tb <= std_logic_vector(to_unsigned(0, Nbits));
    wait for 40 ns;
    reset <= '0';
    wait for 40 ns;

    assert to_integer(unsigned(acc_tb)) = 0 report "Test: 10x0=0 (FAILED)";
    report "Fin de la simulation";
    wait;
  end process;
end architecture;
