Running Keystone with QEMU
====================================

`QEMU <https://www.qemu.org>`_ is an open source machine emulator.
The latest QEMU supports RISC-V ISA.

Keystone is tested in the latest RISC-V QEMU (`GitHub <https://github.com/riscv/riscv-qemu>`_).
The upstream QEMU might not work because it has a bug in the PMP module (`See GitHub issue <>`.
The fix will be upstreamed in the future.

Installing Dependencies
----------------------------

We tested Keystone with QEMU Ubuntu 16.04/18.04 and derivatives.

Ubuntu
#######################

::

  sudo apt update
  sudo apt install autoconf automake autotools-dev bc bison build-essential curl \
  expat libexpat1-dev flex gawk gcc git gperf libgmp-dev libmpc-dev libmpfr-dev \
  libtool texinfo tmux patchutils zlib1g-dev wget bzip2 patch vim-common lbzip2 \
  python pkg-config libglib2.0-dev libpixman-1-dev libssl-dev device-tree-compiler

.. note::

    Some of the utilities also use ``expect`` so we recommend that you install that as well though it is not strictly necessary.
    ::
      sudo apt install expect

Quick Setup
----------------------------

In this stage, you will (1) install RISC-V toolchain, and (2) checkout git submodules.

You can quickly setup everything by running ``./fast-setup.sh``
::

  ./fast-setup.sh

NOTE: the prebuilt toolchain in fast-setup is known to have problems
on Ubuntu 18.04 due to library versioning mismatches.

This will download pre-compiled RISC-V tools and extract it to ``riscv`` directory.

If you want to compile RISC-V tools from source code, run ``./setup.sh`` instead.

To keep environment variables, add export PATH=$PATH:<path/to/keystone>/riscv/bin to your .bashrc. You can also manually run ``source source.sh`` to set the environment variables.


Compile Sources
-----------------------------

Build All
########################

If you want to build all, simply run ``make``.

``PATH`` must include the RISC-V tool path.

::

  make

If you want to manually build each individual component, please follow the instructions below.
Otherwise, skip to :ref:`LaunchQEMU`.


Build RISC-V QEMU
##################

You should apply patches before building the QEMU.

::

  ./scripts/apply-patch.sh
  cd riscv-qemu
  ./configure --target-list=riscv64-softmmu,riscv32-softmmu
  make
  cd ..

Build Linux Kernel
################################################

This is handled as part of the top-level make, see ``hifive.mk`` for
details.

Build Berkeley Bootloader (BBL) with Keystone Security Monitor
##############################################################

This is handled as part of the top-level make, see ``hifive.mk`` for
details.

Optionally, add ``--with-target-platform=PLATFORM`` if you have a
platform specific set of files for the security monitor (defined in ``riscv-pk/

Build Root-of-Trust Boot ROM
###############################

::

  cd bootrom
  make
  cd ..

Build Keystone Driver
##############################

::

  cd linux-keystone-driver
  make
  cd ..

Build Keystone SDK
#############################

Keystone SDK includes sample enclave programs and some useful libraries. To run sample programs, you should compile SDK library and apps, and copy all of them into the disk image. This is done automatically during the top-level build. If you have modified the applications, simply re-run the top-level ``make``.

::

  cd sdk
  make
  cd ..


.. _LaunchQEMU:

Launch QEMU
--------------------------------------

Now, you're ready to run Keystone.

The following script will run QEMU, start executing from the emulated silicon root of trust.
The root of trust then jumps to the SM, and the SM boots Linux!

::

   ./scripts/run-qemu.sh

Login as ``root`` with the password ``sifive``.


You can exit QEMU by ``ctrl-a``+``x`` or using ``poweroff`` command

Note that the launch scripts for QEMU will start ssh on a random
forwarded localhost port (this is to allow multiple qemu test runs on
the same development machine). The script will print what port it has
forwarded ssh to on start.

Insert Keystone Driver
##################################

Insert the keystone driver.

::

    insmod keystone-driver.ko

Run Tests
##################################

You can run Keystone enclaves by using an untrusted host application. We already implemented a simple host ``test-runner.riscv`` for running tests.
Following command will create and execute the enclave.

You can find each of the test enclave in ``sdk/tests/<name>``

Currently, Keystone is only compatible with a prototype runtime, ``eyrie-rt``, which you can find in ``sdk/runtime``.

::

  ./test-runner.riscv <user elf> <runtime elf>

To run all tests, you could simply run

::

  ./test
