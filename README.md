# Muscle Legends Assistant

Version: 0.1.0  
Target data reference: Muscle Legends 3.7.3  
Inspection reference: Lycoles Universal Inspector 2.16.0  
Scan ID: `2E6FE304-4373-4303-980C-A39392A2ADA2`

## Scope

This is a Roblox Studio companion UI for an experience you own or are authorised to modify. It provides a local dashboard, observed training reference data, training calculations, pet example comparisons, and progression reference information.

It does not inject into public games, invoke discovered game remotes, automate transactions or gameplay, modify movement, implement fly/noclip, bypass anti-cheat, or evade bans. A remote's presence in an inspection is not proof of its arguments or permission contract.

## Installation

1. Open Roblox Studio and an experience you own or are authorised to modify.
2. In Explorer, create a `LocalScript` under `StarterPlayer > StarterPlayerScripts`.
3. Create a folder named `modules` as a child of that LocalScript.
4. Add `TrainingData.lua` and `Calculators.lua` as ModuleScripts in that folder, preserving the source contents.
5. Paste `src/main.client.lua` into the LocalScript.
6. Run a Studio play test. The dashboard reads values from `leaderstats` or player attributes with matching names; unavailable values are labelled `Not exposed`.

## Included

- Dark grey UI with light-blue button outlines.
- Draggable main window and compact L restore icon.
- Dashboard for Strength, Durability, Agility, Rebirths, Ascension, Gems and Coins when exposed by the host experience.
- Training equipment reference and target calculator using observed sample values.
- Pet sample reference cards.
- Observed Eternal Gym and Industrial Gym rebirth thresholds.
- Explicitly labelled read-only panels for remaining sections.

## Data provenance and limitations

The supplied inspection is complete (172/172 parts), with 82,617 scanned objects, 39,350 unique objects and 3,934 observed configuration values. It is privacy-filtered and client-visible. It does not provide server source, remote argument schemas, server-side validation, or proof that cutscene/template values are active gameplay rules. Some values in `TrainingData.lua` are sample observations only.

The four pet entries are examples, not a complete pet database. No pet slot capacity, bonus stacking rule, egg probability or full inventory schema is asserted here.

## Verification status

- Source structure: created.
- Data provenance: documented.
- Calculation functions: implemented with input validation and missing-data handling.
- GUI interactions: implemented in source; requires Studio runtime testing.
- Live gameplay: not tested; this environment cannot run Roblox Studio.
- Public-game compatibility: intentionally not supported.

## Repository

Source is maintained in [daverbradley6-beep/MuscleLegends](https://github.com/daverbradley6-beep/MuscleLegends), default branch `main`.
