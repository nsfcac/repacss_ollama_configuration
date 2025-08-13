# Running Open-Source LLMs on TTU REPACSS Clusters using Ollama

A hands-on guide and accompanying scripts for running Ollama (local LLM inference) on REPACSS GPU clusters (e.g., NVIDIA H100).

## Overview

This repository contains:

- **`ollama.sh`**: A helper script to launch and manage the Ollama server.  
- **`test.py`**: An example Python script to verify your Ollama server is working.
- **`tutorial.ipynb`**: A Jupyter notebook that connects to your Ollama server.
- **`requirements.txt`**: Python libraries needed to run the notebook.

## Prerequisites

- Access to the TTU REPACSS cluster.
- Your account must be able to access GPU nodes.
- `apptainer` module must be available.

---

## Quick Start Guide

Follow the steps below to run Ollama on a GPU node.

### Step 1: Request a GPU Node (H100)

Use the following command to start an interactive job with 4 GPUs for 8 hours:

```bash
interactive -p h100 -t 02:00:00 -g 1
```

---

### Step 2: Clone the Ollama_repacss Repository

Clone this repository to your project space. On REPACSS, we suggest you to use home directory.

we are using ollama 0.6.8 in this version:

```bash
cd $HOME
cd <your_project>
git clone https://github.com/nsfcac/ollama_repacss.git
cd ollama_repacss
```

### Step 3:Download ollama and Configure Environment

First, Please download the ollama (we suggest to use ollama 0.6.8 version for now) and then set SCRATCH_BASE environment variable:

```bash
apptainer pull ollama.sif docker://ollama/ollama:0.6.8

export SCRATCH_BASE=/mnt/<Your Group Name>/home/$USER
```

---

### Step 4: Source the Ollama Wrapper

This sets up a wrapper function to easily start the Ollama server and issue commands:

```bash
source ollama.sh
```

---

### Step 5: Launch Ollama sever:

Ollama server has been launched in the background:

```bash
ollama serve &
```

---

### Step 7: We are using a shared LLM directory on REPACSS. 

Check the model list first and use the existing models:
```bash
ollama list
ollama run falcon3:1b
```

if you want to use a new model, please choose a model supported by Ollama and pull it. Example:

```bash
ollama pull llama3.1:8b
```
---

### Step 8: Run Inference

Test the model directly with a simple prompt:

```bash
ollama run llama3.1:8b
>>> what is the capital of Texas?
```

---

### Step 9: Verify Server Status from Login Node

From a login node (not the GPU node), check if the Ollama server is running:

```bash
curl http://<hostname>:<port>
```
You can find a host.txt and port.txt in your ~/ollama folder/ Replace <hostname> with your GPU node's hostname and <port> with your Ollama server's port number. 

You should see:

```
Ollama is running
```

## Optional: Jupyter Notebook

From a login node (not the GPU node), or any other nodes, you could run 

```bash
jupyter notebook --no-browser --ip=127.0.0.1 --port=8081
```

Then on your terminal of local machine: 
	
```bash
ssh -L 8081:127.0.0.1:8081 -l <your_account> -fN repacss.ttu.edu
```
Then you can explore the tutorial.ipynb in your browser (127.0.0.1:8081)
