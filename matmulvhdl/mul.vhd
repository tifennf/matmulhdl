library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity mul is
  generic (Nbits : integer := 4);
  port (
    a, b : in  std_logic_vector(Nbits - 1 downto 0);
    y    : out std_logic_vector(2 * Nbits - 1 downto 0));
end entity;

architecture rtl of mul is
begin
  y <= std_logic_vector(unsigned(a) * unsigned(b));
end architecture;
