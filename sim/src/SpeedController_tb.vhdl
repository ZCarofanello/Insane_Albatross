-------------------------------------------------------------------------------
-- Title      : Testbench for design "SpeedController"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SpeedController_tb.vhdl
-- Author     :   <Aidan@shader.me>
-- Company    : 
-- Created    : 2016-10-06
-- Last update: 2016-10-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-10-06  1.0      Aidan	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-------------------------------------------------------------------------------

entity SpeedController_tb is

end entity SpeedController_tb;

-------------------------------------------------------------------------------

architecture test of SpeedController_tb is

  -- component generics
  constant OFF_WIDTH    : real := 1.0E-3;
  constant ON_WIDTH     : real := 2.0E-3;
  constant REFRESH_FREQ : real := 400.0;
  constant CLOCK_FREQ   : real := 50.0E6;

  -- Max count (50000)
  constant MAX_COUNT : integer := 50E3;

  -- component ports
  signal rst_n     : std_logic := '0';
  signal width     : std_logic_vector(integer(ceil(log2((ON_WIDTH-OFF_WIDTH)*CLOCK_FREQ)))-1 downto 0);
  signal pulse_out : std_logic;
  
  -- clock
  signal Clk : std_logic := '1';

  signal run : std_logic := '1';
  
begin  -- architecture test

  -- component instantiation
  DUT: entity work.SpeedController
    generic map (
      OFF_WIDTH    => OFF_WIDTH,
      ON_WIDTH     => ON_WIDTH,
      REFRESH_FREQ => REFRESH_FREQ,
      CLOCK_FREQ   => CLOCK_FREQ)
    port map (
      clk       => clk,
      rst_n     => rst_n,
      width     => width,
      pulse_out => pulse_out);

  -- clock generation
  Clk <= (not Clk and run) after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    wait until clk = '1';
    rst_n <= '1';
    
    for i in 0 to 8 loop
      width <= std_logic_vector(to_unsigned(integer(real(MAX_COUNT)/8.0*real(i)), width'length));
      wait for 2.5 ms;
    end loop;
    
    run <= '0';
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end architecture test;

-------------------------------------------------------------------------------

configuration SpeedController_tb_test_cfg of SpeedController_tb is
  for test
  end for;
end SpeedController_tb_test_cfg;

-------------------------------------------------------------------------------
