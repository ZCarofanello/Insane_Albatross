-------------------------------------------------------------------------------
-- Title      : Testbench for design "PIController"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PIController_tb.vhdl
-- Author     :   <Aidan@shader.me>
-- Company    : 
-- Created    : 2016-10-08
-- Last update: 2016-10-08
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-10-08  1.0      Aidan	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use ieee.math_real.all;

-------------------------------------------------------------------------------

entity PIController_tb is

end entity PIController_tb;

-------------------------------------------------------------------------------

architecture test of PIController_tb is

  -- component generics
  constant WIDTH : integer := 16;

  -- component ports
  signal set_point  : sfixed(WIDTH downto -WIDTH)     := to_sfixed(1.0, WIDTH, -WIDTH);
  signal sample     : sfixed(WIDTH downto -WIDTH)     := to_sfixed(0.0, WIDTH, -WIDTH);
  signal gain_p     : sfixed(WIDTH downto -WIDTH)     := to_sfixed(0.1, WIDTH, -WIDTH);
  signal gain_i     : sfixed(WIDTH downto -WIDTH)     := to_sfixed(1.0, WIDTH, -WIDTH);
  signal acc_in     : sfixed(WIDTH downto -WIDTH)     := to_sfixed(0.0, WIDTH, -WIDTH);
  signal delta_time : sfixed(WIDTH downto -WIDTH)     := to_sfixed(400.0E-3, WIDTH, -WIDTH);
  signal result     : sfixed(WIDTH downto -WIDTH);
  signal acc_out    : sfixed(WIDTH downto -WIDTH);

  -- clock
  signal Clk : std_logic := '1';

  signal run : std_logic := '1';
  
begin  -- architecture test

  -- component instantiation
  DUT: entity work.PIController
    generic map (
      WIDTH => WIDTH)
    port map (
      set_point  => set_point,
      sample     => sample,
      gain_p     => gain_p,
      gain_i     => gain_i,
      acc_in     => acc_in,
      delta_time => delta_time,
      result     => result,
      acc_out    => acc_out);

  -- clock generation
  Clk <= (not Clk and run) after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
 
    for i in 0 to 100 loop
      
      wait until clk = '1';
      acc_in <= acc_out;
      sample <= result;
    end loop;
    
    wait until Clk = '1';
    run <= '0';
    wait;
  end process WaveGen_Proc;

  

end architecture test;

-------------------------------------------------------------------------------

configuration PIController_tb_test_cfg of PIController_tb is
  for test
  end for;
end PIController_tb_test_cfg;

-------------------------------------------------------------------------------
