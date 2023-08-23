# Implementation of DAG for FSM

Finite State Machine allows game dev to manage the state of an object into a game, for example a player state.

This code shows a pseudo-player (no icon, no sprite) and the state associated according to actions (jump, run, ...)

## DAG vs Code

DAG is implemented in json file, as it's easy to manipulate in Godot (Dictionnary and Array object)
It depicts the relation between state, the code is generic and stricly follow the json file

Below, the root DAG-FSM, it's mandatory in the file to have the "root". 
It's possible to add others DAG in the same file, for instance :
- "tired" DAG with only "idle" and "walk", 
- "boosted" DAG with "speed-run" and "jump", 
...

Root DAG for a player:

````json
    {"root": [
        {
            "name": "idle",
            "layer": 0,
            "parent": ""
            "children": [
                "walk",
                "run",
                "jump",
                "attack",
            ],
        },
        {
            "name": "walk",
            "layer": 10,
            "parent": "idle"
            "children": [
                "jump",
                "attack",
            ],
        },
        {
            "name": "run",
            "layer": 10,
            "parent": "idle",
            "children": [
                "jump",
                "attack",
            ],
        },
        {
            "name": "jump",
            "layer": 20,
            "parent": "idle",
            "children": [
                "attack",
            ],
        },
        {
            "name": "attack",
            "layer": 30,
            "parent": "idle",
            "children": [],
        },
        ]
    }
````

