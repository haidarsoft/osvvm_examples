library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.numeric_std.all;
  
library OSVVM; 
  context OSVVM.OsvvmContext; 

library osvvm_Axi4;
  context osvvm_Axi4.Axi4LiteContext; 


entity TestCtrl is
  port (
    -- Global Signal Interface
    Clk            : In    std_logic;
    nReset         : In    std_logic;
    -- Transaction Interfaces
    ManagerRec     : inout AddressBusRecType
  );
    constant AXI_ADDR_WIDTH : integer := ManagerRec.Address'length; 
    constant AXI_DATA_WIDTH : integer := ManagerRec.DataToModel'length;  

end entity TestCtrl;