-------------------------------------------------------------------------------
-- Title      : Speed Controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SpeedController.vhdl
-- Author     :   <Aidan@shader.me>
-- Company    : 
-- Created    : 2016-10-06
-- Last update: 2016-10-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: PWM ESC speed variable speed controller
-------------------------------------------------------------------------------
-- Copyright (c) 2016 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-10-06  1.0      Aidan   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-------------------------------------------------------------------------------

entity SpeedController is

  generic (
    OFF_WIDTH    : real := 1.0E-3;      -- Time in seconds
    ON_WIDTH     : real := 2.0E-3;      -- Time in seconds
    REFRESH_FREQ : real := 400.0;       -- ESC update freq
    CLOCK_FREQ   : real := 50.0E6       -- FPGA freq
    );

  port (
    clk       : in  std_logic;
    rst_n     : in  std_logic;
    width     : in  std_logic_vector(integer(ceil(log2((ON_WIDTH-OFF_WIDTH)*CLOCK_FREQ)))-1 downto 0);
    pulse_out : out std_logic
    );

  -- Pulse width difference
  constant WIDTH_DIFFERENCE : real := ON_WIDTH-OFF_WIDTH;

  -- Input count width
  constant INPUT_WIDTH : integer := integer(ceil(log2(WIDTH_DIFFERENCE*CLOCK_FREQ)));

  -- Internal counter width
  constant COUNTER_WIDTH : integer := integer(ceil(log2(CLOCK_FREQ/REFRESH_FREQ)));

  -- Max count
  constant MAX_COUNT : integer := integer(floor(CLOCK_FREQ/REFRESH_FREQ));

  -- Min count to ensure at least off width is met
  constant PULSE_MIN_COUNT : integer := integer(OFF_WIDTH*CLOCK_FREQ);

  -- Max count to ensurse we don't overrun on width
  constant PULSE_MAX_COUNT : integer := integer(ON_WIDTH*CLOCK_FREQ);

end entity SpeedController;

-------------------------------------------------------------------------------

architecture str of SpeedController is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal internal_count : std_logic_vector(COUNTER_WIDTH-1 downto 0);
  signal next_count     : std_logic_vector(COUNTER_WIDTH-1 downto 0);

  signal locked_in_width : std_logic_vector(INPUT_WIDTH-1 downto 0);

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- purpose: Manages the internal counter
  -- type   : sequential
  -- inputs : clk, rst_n, next_count
  -- outputs: internal_count
  internal_counter : process (clk, rst_n) is
  begin  -- process internal_counter
    if rst_n = '0' then                 -- asynchronous reset (active low)
      internal_count <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if to_integer(unsigned(next_count)) >= MAX_COUNT then
        internal_count <= (others => '0');
      else
        internal_count <= next_count;
      end if;
    end if;
  end process internal_counter;

  next_count <= std_logic_vector(to_unsigned(to_integer(unsigned(internal_count)) + 1, COUNTER_WIDTH));

  -- purpose: Pulse generator
  -- type   : sequential
  -- inputs : clk, rst_n, internal_count
  -- outputs: pulse_out
  pulse_generator : process (clk, rst_n) is
  begin  -- process pulse_generator
    if rst_n = '0' then                 -- asynchronous reset (active low)
      pulse_out <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
    elsif to_integer(unsigned(internal_count)) > (PULSE_MIN_COUNT + to_integer(unsigned(locked_in_width))) or
      to_integer(unsigned(internal_count)) > PULSE_MAX_COUNT then
      pulse_out <= '0';
    else
      pulse_out <= '1';
    end if;
  end process pulse_generator;

  -- purpose: Locks in the current desired pulse width
  -- type   : sequential
  -- inputs : cllk, rst_n, width
  -- outputs: lock_in_width
  lockin_process : process (clk, rst_n) is
  begin  -- process lockin_process
    if rst_n = '0' then                 -- asynchronous reset (active low)
      locked_in_width <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if internal_count = (internal_count'length-1 downto 0 => '0') then
        locked_in_width <= width;
      end if;
    end if;
  end process lockin_process;

end architecture str;

-------------------------------------------------------------------------------
