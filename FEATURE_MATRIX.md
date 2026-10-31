# Feature compatibility matrix

| Area | Status | Evidence / limitation |
|---|---|---|
| Dashboard | Implemented | Reads matching `leaderstats` or player attributes; missing values are explicit. |
| Training database | Partial | Seven observed equipment entries; sample values only. |
| Training calculator | Implemented | Requirement gate, gain-per-rep, reps and time when rep time is known. |
| Best equipment optimiser | Module function | Compares candidates only where requirement, gain and rep time are known. |
| Pet database | Partial | Four example pets; not a full catalogue. |
| Pet optimiser | Not enabled | Owned inventory, slots and verified stacking rules unavailable. |
| Progression | Partial | Eternal Gym 15 rebirths; Industrial Gym 150 rebirths. |
| Quests | Read-only panel | Catalog and live progress need further extraction. |
| Economy | Read-only panel | Live prices and transaction rules not established. |
| Rewards | Read-only panel | No probabilities inferred without probability fields. |
| Combat | Read-only panel | Live boss health and damage data not established. |
| Travel | Read-only panel | No remote calls or teleportation. |
| Movement | Restricted | No speed manipulation, fly or noclip. |
| Automation | Restricted | No gameplay automation or transaction automation. |
| Risk | Implemented | States allowed read-only scope and blocked behaviours. |
| Settings | Partial | Minimise/restore included; advanced theme and scale controls not yet included. |
| GitHub loader | Not included | No executor `loadstring`; Studio ModuleScript deployment only. |

## Remote handling

The inspection found 111 remote objects (67 RemoteEvents, 41 RemoteFunctions, 3 UnreliableRemoteEvents). Names and categories are heuristic. No remote is called by this project because argument schemas, server validation and authorisation are not established.
