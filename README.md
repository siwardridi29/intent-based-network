# 🧠 Intent-Based Networking (IBN) System

Manage an SDN network by telling it **what** you want, not **how** to do it.

This system understands network intents written in **French**, translates them into **OpenFlow rules** on a **Ryu** controller, applies **QoS** policies, and continuously monitors the network to **self-correct** violations.

Built for the PFA II project (2025-2026) at **ENIT – École Nationale d'Ingénieurs de Tunis**, supervised by Mme Mariem Kassar.

## Example

```
You type:  "Applique un bas débit entre le Directeur et le Serveur"

→ Intent classified (QOS)
→ Entities resolved (h1 ↔ h10, profile BRONZE)
→ Decision validated, then OpenFlow/QoS rules deployed
→ Network monitored, violations corrected automatically
```

## How it works

1. **Classification**: TF-IDF + linear SVM sorts the intent into `BREAK`, `RESTORE`, `QOS` or `NETWORK_WIDE` (deterministic fallback if confidence < 55%).
2. **Entity extraction**: business names (*Directeur*, *Serveur*) are resolved into hosts, switches (DPID), ports and QoS profiles.
3. **JSON manifest**: all parameters are pre-computed, which restricts the LLM's decision space and limits hallucinations.
4. **LLM agent**: a LangChain agent (LLaMA 3 via Groq) picks the right network tool from the manifest.
5. **Validation**: a Random Forest policy validator checks every decision before execution.
6. **Deployment**: Flask API → Ryu → OpenFlow rules on Open vSwitch.
7. **Assurance**: telemetry, congestion detection, intent registry, watchdog and autonomous corrector (no LLM call needed for corrections).

## Architecture

| Layer | Folder | Role |
|---|---|---|
| Intention (AI) | `LangChain_Tool/` | Classifier, extractor, agent, validator, registry, scheduler, corrector |
| Management | `Api/` | Flask REST API (port 5000) and web dashboard |
| Control | `ryu/` | Ryu apps: OpenFlow rules, DSCP, port telemetry |
| Data plane | `Start-mininet.sh` | Mininet: 9 OVS switches, 10 hosts |

**QoS profiles** (DSCP marking at access switches + OVS/HTB queues):

| Profile | Queue | DSCP | Class |
|---|---|---|---|
| GOLD | Q3 | 46 | EF |
| SILVER | Q4 | 26 | AF31 |
| BRONZE | Q2 | 10 | AF11 |
| STANDARD | Q0 | 0 | BE |

## Results

Tested on an emulated network (Kali Linux VM, 2 vCPU, 8 GB RAM):

| Metric | Result |
|---|---|
| Intent classification accuracy | 94.5 % |
| Agent execution success rate | 99.2 % |

## Project structure

```
intent-based-network/
├── Api/                    # Flask API + dashboard (templates/, static/)
├── LangChain_Tool/         # AI layer
│   ├── sdn_ai_retroactif.py    # LangChain agent and tools
│   ├── Extracteur/             # Intent classifier and entity extraction
│   ├── Control/                # Policy validation
│   ├── congestion_detector.py
│   ├── correcteur.py
│   ├── intent_registry.py
│   ├── intent_scheduler.py
│   └── .env.example
├── ryu/                    # Controller (simple_switch_13.py, qos_telemetry.py)
├── automatisation/         # Automation scripts
└── Start-mininet.sh
```

## Getting started

**Requirements:** Linux, Python 3.10, Mininet, Open vSwitch, a free [Groq API key](https://console.groq.com).

```bash
git clone https://github.com/siwardridi29/intent-based-network.git
cd intent-based-network
pip install -r requirements.txt
cp LangChain_Tool/.env.example LangChain_Tool/.env   # add your GROQ_API_KEY
```

Ryu runs best in its own Python environment (`pip install ryu eventlet`).

**Run (3 terminals, in this order):**

```bash
sudo ./Start-mininet.sh          # 1. virtual network
cd ryu && ./Start-ryu.sh         # 2. controller + telemetry
cd Api && ./Start-api.sh         # 3. API, dashboard, AI layer
```

Open **http://localhost:5000** and try:

- `Coupe h1`
- `Assure-toi que le serveur reste toujours actif`
- `Applique un bas débit entre le Directeur et le Serveur`
- `Assure un bas débit sur tout le réseau`
- <img width="1312" height="685" alt="Capture d&#39;écran 2026-10-07 185656" src="https://github.com/user-attachments/assets/83b829a3-8a03-483a-afc7-b5f9d3961397" />
<img width="1655" height="969" alt="Capture d&#39;écran 2026-03-22 040752" src="https://github.com/user-attachments/assets/728a8b40-36a8-448d-81f9-c8816695bc43" />


## Limitations

- ML models trained on synthetic data (220 samples for the classifier, 900 for the congestion detector).
- Tested only on an emulated tree topology (no loops, no redundancy).
- Depends on an external LLM API (Groq).

## Future work

Security and VLAN intents, physical testbed, online learning, local LLM (Ollama / vLLM).

## Authors

 **Siwar Dridi** · **Yannick Wendyaoda Dima**


