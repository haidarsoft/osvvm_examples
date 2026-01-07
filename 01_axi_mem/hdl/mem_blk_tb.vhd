library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library osvvm;
  context osvvm.OsvvmContext;

library osvvm_Axi4;
  context osvvm_Axi4.Axi4LiteContext;

entity mem_blk_tb  is
end entity mem_blk_tb;

architecture TestHarness of mem_blk_tb is

  constant AXI_ADDR_WIDTH : integer := 32 ;
  constant AXI_DATA_WIDTH : integer := 32 ;
  constant AXI_STRB_WIDTH : integer := AXI_DATA_WIDTH/8 ;

  constant tperiod_Clk : time := 10 ns ;
  constant tpd         : time := 2 ns ;

  signal Clk         : std_logic ;
  signal nReset      : std_logic ;

  signal ManagerRec, SubordinateRec  : AddressBusRecType(
          Address(AXI_ADDR_WIDTH-1 downto 0),
          DataToModel(AXI_DATA_WIDTH-1 downto 0),
          DataFromModel(AXI_DATA_WIDTH-1 downto 0)
        );

  -- AXI Manager Functional Interface
  signal AxiBus : Axi4LiteRecType(
    WriteAddress( Addr (AXI_ADDR_WIDTH-1 downto 0) ),
    WriteData   ( Data (AXI_DATA_WIDTH-1 downto 0),   Strb(AXI_STRB_WIDTH-1 downto 0) ),
    ReadAddress ( Addr (AXI_ADDR_WIDTH-1 downto 0) ),
    ReadData    ( Data (AXI_DATA_WIDTH-1 downto 0) )
  );

  component TestCtrl is
    port (
      -- Global Signal Interface
      Clk                 : In    std_logic ;
      nReset              : In    std_logic ;
      -- Transaction Interfaces
      ManagerRec          : inout AddressBusRecType
    );
  end component TestCtrl ;

begin

  -- create Clock
  Osvvm.ClockResetPkg.CreateClock (
    Clk        => Clk,
    Period     => Tperiod_Clk
  ) ;

  -- create nReset
  Osvvm.ClockResetPkg.CreateReset (
    Reset       => nReset,
    ResetActive => '0',
    Clk         => Clk,
    Period      => 7 * tperiod_Clk,
    tpd         => tpd
  );


  mem_blk_i : entity work.mem_blk_wrapper
    port map( 
      S_AXI_ACLK    => Clk,
      S_AXI_ARESETN => nReset,
      
      S_AXI_AWADDR  => AxiBus.WriteAddress.ADDR(11 downto 0),
      S_AXI_AWPROT  => AxiBus.WriteAddress.PROT,
      S_AXI_AWVALID => AxiBus.WriteAddress.VALID,
      S_AXI_AWREADY => AxiBus.WriteAddress.READY,
      
      S_AXI_WDATA   => AxiBus.WriteData.DATA,
      S_AXI_WSTRB   => AxiBus.WriteData.STRB,
      S_AXI_WVALID  => AxiBus.WriteData.VALID,
      S_AXI_WREADY  => AxiBus.WriteData.READY,
      
      S_AXI_BRESP   => AxiBus.WriteResponse.RESP,
      S_AXI_BVALID  => AxiBus.WriteResponse.VALID,
      S_AXI_BREADY  => AxiBus.WriteResponse.READY,
      
      S_AXI_ARADDR  => AxiBus.ReadAddress.ADDR(11 downto 0),
      S_AXI_ARPROT  => AxiBus.ReadAddress.PROT,
      S_AXI_ARVALID => AxiBus.ReadAddress.VALID,
      S_AXI_ARREADY => AxiBus.ReadAddress.READY,
      
      S_AXI_RDATA   => AxiBus.ReadData.DATA,
      S_AXI_RRESP   => AxiBus.ReadData.RESP,
      S_AXI_RVALID  => AxiBus.ReadData.VALID,
      S_AXI_RREADY  => AxiBus.ReadData.READY
    );

  Manager_1 : entity osvvm_Axi4.Axi4LiteManager
  port map (
    -- Globals
    Clk         => Clk,
    nReset      => nReset,
    -- AXI Manager Functional Interface
    AxiBus      => AxiBus,
    -- Testbench Transaction Interface
    TransRec    => ManagerRec
  );


  Monitor_1 : entity osvvm_Axi4.Axi4LiteMonitor
  port map (
    -- Globals
    Clk         => Clk,
    nReset      => nReset,
    -- AXI Manager Functional Interface
    AxiBus      => AxiBus
  );


  TestCtrl_1 : TestCtrl
  port map (
    -- Globals
    Clk            => Clk,
    nReset         => nReset,
    -- Testbench Transaction Interfaces
    ManagerRec     => ManagerRec
  );

end architecture TestHarness ;