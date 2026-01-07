This example illustrates the structure of an OSVVM verification environment.

The mem_blk_tb implements the "test harness" connecting the verification components:
- Clock generator
- Reset generator
- Device Under Verification instance (the mem_blk_wrapper)
- AXI lite manager
- Monitor
- Test Control

![](./img/osvvm_structure.svg "The structure of OSVVM verification environment")

The AXI lite manager is the bus master, it can be made to perform read or write transactions using the ManagerRec. There exists also AXI lite subordinate component which can be used to verify manager DUVs.

The test control entity represents the reusable part of test cases. For each test, a unique architecture is plugged for the TestCTRL_e.

The test architecture typically contains separate processes, one to control the flow of the simulation, and one to generate transactions from the manager record (and or subordinate record). 

