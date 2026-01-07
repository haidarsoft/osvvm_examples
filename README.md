# Introduction

This repository provides examples to learn how to use Open Source Verification Methodology OSVVM in vivado xsim. The advantage of this approach is to be able to simulate designs containing Xilinx IP cores royalty free. This was tested to work only with Vivado 2025.2.

[OSVVM website](https://osvvm.org/)

[Git repo](https://github.com/OSVVM)

Installation for Vivado xsim

- Clone the repository
```bash
    mkdir osvvm
    cd osvvm
    git clone --recursive https://GitHub.com/OSVVM/OsvvmLibraries
```
- Build the libraries with xsim, start vivado and use the tcl console:
```bash
    mkdir sim
    cd sim
    source ../OsvvmLibraries/Scripts/StartXSIM.tcl
    build  ../OsvvmLibraries

    # The compiled libraries are inside:
    test\sim\xsim.dir 
```

- Add the libraries to xsim

```bash
    # Copy all folders to:
    AMDDesignTools\2025.2\data\xsim\vhdl

    # Rename the folders by adding _2008 suffix, since OSVVM uses VHDL-2008 features

    # locate the xsim ini file:
    AMDDesignTools\2025.2\data\xsim\xsim.ini

    # To add the AXI libraries for example, add the following lines:
    osvvm=$RDI_DATADIR/xsim/vhdl/osvvm_2008
    osvvm_common=$RDI_DATADIR/xsim/vhdl/osvvm_common_2008
    osvvm_axi4=$RDI_DATADIR/xsim/vhdl/osvvm_axi4_2008

```
- Run the example design 01_axi_memory
```bash
    # using vivado tcl console
    cd 01_axi_memory
    source create_project.tcl
```

- Wait for synthesis to complete
- Open the project with Vivado 2025.2 or newer and click "Run Simulation".
