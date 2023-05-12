## compile/update release

- `mkdir build && cd build`
- `cmake .. -DCMAKE_BUILD_TYPE=Release [-GNinja]`
- `cmake --build .`
- CHECK:
  - cf tests/deb/test_deb_exe.dockerfile comments
  - cf tests/deb/test_deb_lib.dockerfile; NOTE this one will recompile from scratch, it is mostly a CI-like
- `cpack`

## dev(ie use the .deb)

- install: eg `apt-get install -y yosys-0.1.29-Linux.deb`
- cf tests/deb for details:
    - in source: BEFORE calling yosys_setup() `Yosys::yosys_share_dirname = "/usr/share/yosys/";`