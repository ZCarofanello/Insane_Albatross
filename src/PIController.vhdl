-------------------------------------------------------------------------------
-- Title      : PI controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : PIController.vhdl
-- Author     :   <Aidan@shader.me>
-- Company    : 
-- Created    : 2016-10-08
-- Last update: 2016-10-08
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Single step PI controller
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

entity PIController is

  generic (
    WIDTH               : integer       := 16
    );

  port (
    -- Inputs
    set_point   : in    sfixed(WIDTH downto -WIDTH);
    sample      : in    sfixed(WIDTH downto -WIDTH);
    gain_p      : in    sfixed(WIDTH downto -WIDTH);
    gain_i      : in    sfixed(WIDTH downto -WIDTH);
    acc_in      : in    sfixed(WIDTH downto -WIDTH);
    delta_time  : in    sfixed(WIDTH downto -WIDTH);
    -- Outputs
    result      : out   sfixed(WIDTH downto -WIDTH);
    acc_out     : out   sfixed(WIDTH downto -WIDTH)
    );

end entity PIController;

-------------------------------------------------------------------------------

architecture str of PIController is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal error_sig : sfixed(WIDTH+1 downto -WIDTH);
  signal error_time_adj : sfixed((WIDTH*2+2) downto -(WIDTH*2));
  signal acc_internal : sfixed((WIDTH*2+3) downto -(WIDTH*2));
  signal integral_part : sfixed((WIDTH*2+1) downto -(WIDTH*2));
  signal proportional_part : sfixed((WIDTH*2+2) downto -(WIDTH*2));
  signal raw_result : sfixed((WIDTH*2+3) downto -(WIDTH*2));
  
begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- Compute error signal
  error_sig <= set_point - sample;

  -- Adjust the error signal for delta time
  error_time_adj <= error_sig * delta_time;

  -- Compute the new accumlate
  acc_internal <= acc_in + error_time_adj;

  --acc_limiter : process(acc_internal)
  --begin
  --  -- Sign check
  --  if (acc_internal(WIDTH+1) = '0') then
  --    -- Check if acc_internal is too big
  --    if (to_real(acc_internal) > to_real(to_sfixed(signed((WIDTH*WIDTH-1 downto 0 => '1')), WIDTH, -WIDTH))) then
  --      -- Cap it
  --      acc_internal <= to_sfixed((WIDTH*WIDTH-1 downto 0 => '1'), WIDTH, -WIDTH);
  --    end if;
  --  else
  --    -- Check if acc_internal is too small
  --    if (to_real(acc_internal) < to_real(to_sfixed(signed((WIDTH*WIDTH downto 0 => '1')), WIDTH, -WIDTH))) then
  --      -- Cap it
  --      acc_internal <= to_sfixed((WIDTH*WIDTH downto 0 => '1'), WIDTH, -WIDTH);
  --    end if;
  --  end if;
  --end process;

  -- Assign acc out
  acc_out <= acc_internal(WIDTH downto -WIDTH);

  -- Compute integral part
  integral_part <= gain_i * acc_internal(WIDTH downto -WIDTH);

  -- Proportional part
  proportional_part <= gain_p * error_sig;

  -- Parts to raw result
  raw_result <= integral_part + proportional_part;

  result <= raw_result(WIDTH downto -WIDTH);
  
end architecture str;

-------------------------------------------------------------------------------
