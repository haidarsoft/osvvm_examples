architecture basic_rw_test of TestCtrl is

  signal TestDone, ManagerDone : integer_barrier := 1;
 
begin

  ------------------------------------------------------------
  -- ControlProc
  --   Set up AlertLog and wait for end of test
  ------------------------------------------------------------
  ControlProc : process
  begin
    -- Initialization of test
    SetTestName("TbAxi4_MemoryReadWrite1");
    SetLogEnable(PASSED, TRUE);    -- Enable PASSED logs
    SetLogEnable(INFO, TRUE);    -- Enable INFO logs

    -- Wait for testbench initialization 
    wait for 0 ns;  wait for 0 ns;
    TranscriptOpen;
    SetTranscriptMirror(TRUE); 

    -- Wait for Design Reset
    wait until nReset = '1';  
    ClearAlerts;

    -- Wait for test to finish
    WaitForBarrier(TestDone, 35 ms);
    
    TranscriptClose; 
    -- Printing differs in different simulators due to differences in process order execution
    -- AffirmIfTranscriptsMatch(PATH_TO_VALIDATED_RESULTS) ;

    EndOfTestReports(TimeOut => (now >= 35 ms)); 
    std.env.stop; 
    wait; 
  end process ControlProc ; 

  ------------------------------------------------------------
  -- ManagerProc
  --   Generate transactions for AxiManager
  ------------------------------------------------------------
  ManagerProc : process
    variable Data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  begin
    wait until nReset = '1';  
    WaitForClock(ManagerRec, 2); 
    log("Write and Read with ByteAddr = 0, 4 Bytes");
    Write(ManagerRec, X"008", X"12345678" );
    
    Read(ManagerRec,  X"008", Data);
    AffirmIfEqual(Data, X"12345678", "Manager Read Data: ");
    
    WaitForBarrier(ManagerDone);
    -- Wait for outputs to propagate and signal TestDone
    WaitForClock(ManagerRec, 2);
    WaitForBarrier(TestDone);
    wait;
  end process ManagerProc;

end basic_rw_test;

Configuration basic_rw_test_c of mem_blk_tb is
  for TestHarness
    for TestCtrl_1 : TestCtrl
      use entity work.TestCtrl(basic_rw_test); 
    end for; 
  end for; 
end basic_rw_test_c; 