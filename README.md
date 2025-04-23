# Graph Theory

<a href="http://ims.ostis.net/">Open Semantic Technology for Intelligent Systems (OSTIS)</a>

## Components

<a href="https://github.com/ostis-apps/gt-knowledge-base">Knowledge base</a>

<a href="https://github.com/ostis-apps/gt-knowledge-processing-machine">Solver</a>

<a href="https://github.com/ostis-apps/gt-book">Graph Theory Book</a>

<a href="https://github.com/ostis-apps/gt-ostis-drawings">Graph editor</a>

## Installation

Download project

```sh
git clone https://github.com/ostis-apps/ostis-discrete-math.git
cd ostis-discrete-math/scripts

```

Install pipx using [**pipx installation guide**](https://pipx.pypa.io/stable/installation/) if not already installed.

Ensure you are using **CMake version 3.24** or newer. Verify your version with:

```sh
cmake --version
```

To upgrade CMake, run:

```sh
# Use pipx to install cmake if not already installed
pipx install cmake
pipx ensurepath
# relaunch your shell after installation
exec $SHELL
```

Install Ninja generator for CMake, to use sc-machine CMake presets:
```sh
# Use pipx to install ninja if not already installed
pipx install ninja
pipx ensurepath
# relaunch your shell after installation
exec $SHELL
```

Install Conan, to build project with Conan-provided dependencies:

```sh
# Use pipx to install conan if not already installed
pipx install conan
pipx ensurepath
# relaunch your shell after installation
exec $SHELL
```

Install and build submodules:

```sh
./install.sh     

```

Build knowledge base

```sh
cd scripts 
./build_kb.sh 

```

Start project

```sh
cd scripts 
./run_sc_machine.sh 

```

Start web-server

```sh
cd scripts 
./run_sc_web.sh   

```

Open in browser <a href="http://localhost:8000/">http://localhost:8000/</a>
