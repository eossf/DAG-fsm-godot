# Implementation of DAG for FSM

Finite State Machine allows game dev to manage the state of an object into a game, for example a player state.

This code shows a pseudo-player (no icon, no sprite) and the state associated according to actions (jump, run, ...)

## DAG

### Why DAG and not Code
DAG is implemented in json file, as it's easy to manipulate in Godot (Dictionnary and Array object).

It depicts the relation between states, the code is generic and stricly follow the json file.

It avoids to create boiler-plate code, to test if a player is in a particular state or not before deciding an action.

Below, the root DAG-FSM, it's mandatory in the file to have the "root" with at least "idle" state. 
It's possible to add others DAG in the same file, for instance :
- "tired" DAG with only "idle" and "walk", 
- "boosted" DAG with "speed-run" and "jump", 
...

### DAG Fields

node_name: is the UNIQUE name of the node, it is referenced in the children array. The layer 0 is the default one, one node is expected "idle" with no parent.

layer: is a group of nodes with the same level, an object applying DAG-FSM (a player...) could not have in the same time 2 nodes of the same layer.

parent: is the default node in case of falling back from a node above (from a upper layer).

children: the list of possible path for a node given, for example when you are firing you could not do something else.

### DAG calculated Fields

The code calculates the layer count, it's the different layers count, if you have layer 0, layer 100, layer 200 , the count is 3.


````json
    {"root": [
        {
           "node_name": "idle",
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
           "node_name": "walk",
            "layer": 10,
            "parent": "idle"
            "children": [
                "jump",
                "attack",
            ],
        },
        {
           "node_name": "run",
            "layer": 10,
            "parent": "idle",
            "children": [
                "jump",
                "attack",
            ],
        },
        {
           "node_name": "jump",
            "layer": 20,
            "parent": "idle",
            "children": [
                "attack",
            ],
        },
        {
           "node_name": "attack",
            "layer": 30,
            "parent": "idle",
            "children": [],
        },
        ]
    }
````

## Theory of DAG and FSM

![](schema-DAG.png)

Theory, default rules:

    parallel nodes   : node in the same layer. When going to this node it's NOT POSSIBLE to go to another node in the same layer
    serial nodes     
        when going to a node to another layer, it's a one way path, if you go back you follow the same path in the reverse way
    
    history : for managing the node to node state an Array hold the history, the stack size is the number of layer
        history[].size = layer.count


For example:

    Player walk, jump and attack
    (idle -> walk -> jump -> attack)
    
    Then release attack input
    (idle -> walk -> jump)
    
    Then release jump
    (idle -> walk)

When going from node to node, a stack is managed, tracking state

A node_name is the point where a decision path is expected, there are x cases:

- nothing, it's the final state, there is no more actions possible (children is empty array)
- actions available, children nodes array contains all possibilities
- finished action, at each node by default when finishing (jump, attack, ...) the state returned to the node before (history), but, a default node is mandatory to manage the falling back. When going to idle, the history is cleaned

