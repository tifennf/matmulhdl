library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_mul is
end entity;

architecture tb of tb_mul is
  constant Nbits : integer := 4;

  signal a_tb : std_logic_vector(Nbits - 1 downto 0) := (others => '0');
  signal b_tb : std_logic_vector(Nbits - 1 downto 0) := (others => '0');
  signal y_tb : std_logic_vector(2 * Nbits - 1 downto 0);

begin

  dut: entity work.mul
    generic map (Nbits => Nbits)
    port map (a => a_tb,
              b => b_tb,
              y => y_tb);

  p_stimulus: process
  begin
    report "Début de la simulation";

    a_tb <= std_logic_vector(to_unsigned(2, Nbits));
    b_tb <= std_logic_vector(to_unsigned(3, Nbits));
    wait for 10 ns;
    assert y_tb = '6'
      report "Test: 3x2=6 (FAILED)";
    a_tb <= std_logic_vector(to_unsigned(10, Nbits));
    b_tb <= std_logic_vector(to_unsigned(0, Nbits));
    wait for 10 ns;
    a_tb <= std_logic_vector(to_unsigned(1, Nbits));
    b_tb <= std_logic_vector(to_unsigned(3, Nbits));
    wait for 10 ns;
    a_tb <= std_logic_vector(to_unsigned(10, Nbits));
    b_tb <= std_logic_vector(to_unsigned(2, Nbits));
    wait for 10 ns;
    report "Fin de la simulation";
    wait;
  end process;
end architecture;
