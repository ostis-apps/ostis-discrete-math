# Graph Theory

<a href="http://ims.ostis.net/">Open Semantic Technology for Intelligent Systems (OSTIS)</a>

## Components

<a href="https://github.com/ostis-apps/gt-knowledge-base">Knowledge base</a>

<a href="https://github.com/ostis-apps/gt-knowledge-processing-machine">Solver</a>

<a href="https://github.com/ostis-apps/gt-book">Graph Theory Book</a>

<a href="https://github.com/ostis-apps/gt-ostis-drawings">Graph editor</a>

## Installation

Download and build project

```sh
git clone https://github.com/ostis-apps/gt.ostis
cd gt.ostis/scripts 
./prepare.sh     

```

Build knowledge base

```sh
cd scripts 
./build_kb.sh 

```

Start project

```sh
cd scripts 
./run_sc_server.sh 

```

Start web-server

```sh
cd scripts 
./run_sc_web.sh   

```

Open in browser <a href="http://localhost:8000/">http://localhost:8000/</a>
