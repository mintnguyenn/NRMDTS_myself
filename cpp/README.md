# Surface coverage path planning with minimum undesirable end-effector lift-offs

# Description
Path planning algorithm for a robotic manipulator to accomplish full surface coverage with minimal lift-off 

A collaborative project between ZU and CAS-UTS
Tong, Jaime, Yue, Rong

## Install

1. MATLAB R2019b (for built-in collision checking function)

2. MATLAB robotics toolbox (for visualization of the manipulator)

3. MATLAB image processing toolbox (for generating merged figure)

# Current Ideas

## Publishing plan

Non-revisiting Coverage Task with Minimal Suspending for_Non-redundant Manipulators

IJRR, 12+ pages, no deadline, asap

## Paper Outline

1. Tmech as preliminary

2. Discuss two different situations:

  2.1 The non-simply-connected cells (RSS contribution)
  
  2.2 The solution when some singularities (i.e., the escapable internal singularity ) can be used to avoid lift-offs.(new contribution, but we won't mention its generalization to higher-DoF case).
  
3. Speed-up methods in solving and tricks in constructing topological graphs (as you've said, they are not much contributions, but Yue thought they can make the whole "non-redundant manipulator task" complete. Do you think so?)

4. Experiments (We try to find one manipulator which can feedback force on joints from other labs. We use force control instead of position control in this paper. UR5 doesn't provide force interface.)

By this we totally solve the problems appeared in non-redundant manipulator case.

### Existing Questions

1. Introducing background about the CPP result applied in real industrial environment, i.e., the connection between the CPP area and the manipulator control area. We should briefly talk how topological solutions can be used in real environment.

2. Introducing the background of the singularity analysis. Most of them are in 80s and 90s and there might not exist a well-accepted universal frame for terminology and methods. 

3. Place to do real-world experiments. We need to find a manipulator with force control (and of course we should have its simulated model)

# Future Ideas

## For 5DoF manipulator: Automatic Optimal Object Pose Identification for Coverage Task

  Assume that the object always has an unpolishable handle (e.g., the handle of the wok, or human holds the object then his arm cannot be polished or crossed, or another manipulator holds the object), we find usable poses for the object (and the handle). It is a direct generalization of the object putting on the assembly line where the bottom of the object is unpolishable. 
  
## For 6DoF manipulator: Solve the NCPP when one joint is redundant 
  
  The problem is of great importance, because when there are 2 or more redundant joints, hardly can the manipulator face with discontinuties. Besides, without the TMECH+RSS, the NCPP must be done using redundant manipulator, so using 6DoF in 5D case and 7DoF in 6D case should be the current standard industrial solution. Hence the algorithm is directly applicable. 
  
  The problem is difficult because the set of all valid configurations cannot be pre-calculated. In other words, the "color" cannot be pre-defined. In my current point o view, the problem should be solved in "probablistic optimality": Given finite number of sampled configurations (at least one for each vertex in the mesh), we can find a solution. When the number of sampling points goes to infinity, the solution is proved to be global optimal. 

## For 5DoF manipulator, multi-robot optimal coverage
  A task assignment problem given many manipulators working on an assembly line. 
  
  In my opinion, with the claim that "different cells are assigned to different manipulators", the task assignment problem is equivalent to the cellular decomposition problem. 
  
  People may also consider the problem that where on the assembly line is the best position for manipulation. Actually, that we can freely choose the position on the assembly line becomes a new DoF. It is equivalent to that we put the manipulator on the assembly line (i.e., a PRRRRR manipulator) and the position of the object is fixed. Hence this problem is almost equivalent to the 6DoF case. 
  
## For mobile manipulator: NCPP
  A generalization of the NCPP of the redundant manipulator. Usually, a mobile manipulator has 3+5 or 3+6 or 3+6*2 which is extremely redundant. I think we should find some awesome cases that the traditional algorithms (e.g. 9D RRT* or task-priority based algorithm) cannot easily find a solution, then the solvability becomes meaningful. 

## 5DoF manipulator with a passive motion of the object
  A new idea. We imagine that the industrial assembly line has already been created before we proposed our RSS+Tmech contribution, then it cannot be changed. In other words, when the object moves along the assembly line, there is a "time window" for the manipulator to do coverage task. The time window of some points on the object may be so narrow that if the manipulator does not catch the oppotunity, then the points are unreachable. 

# Instruction in Simple Example

Set the path of MATLAB at /min_removal_division/matlab_code/ and just run simple_example.m. It will: 

1. First add the path of all subfolders (line 5)

2. There should be a handler of the collision checking function (haven't finish) (line 16)

3. Manually create the mesh of a rectangular mesh (line 19 - line 36)

4. Create the topological graph (line 40). The parameter "reduce_cspace" is used to delete the unnecessary colors. "ytCell" is the array of topological cells.  "our_ver" is another wrapper for each vertex in the original mesh. "topo_edgelist" and "topo_amd" record the connectivity between cells. 

5. Show the possible color of each cell in the original topological graph. If we choose "reduce_cspace = false" in step 4, we can see two cells with 4 and 8 possible colors. 

![Image text](https://github.com/ZJUTongYang/min_removal_division/blob/master/paper/forreadme/no_reduce_initial_graph.PNG)

But if we choose "reduce_cspace = true" in step 4, we can only see one cell with one possible color (color with index 2), because other colors can only polish not more than the area of this color (4, 6, 8 the same as 2 and 1, 3, 5, 7 less than 2). 

![Image text](https://github.com/ZJUTongYang/min_removal_division/blob/master/paper/forreadme/reduce_initial_graph.PNG)


6. (Line 55 - line 99) Interface between the mesh_operation and the division algorithm

7. (Line 105 - line 121) Visualization for manipulators

8. (Line 123 - line 124) Store the mesh data to avoid re-creating the topological graph (which wastes time in debugging)

9. Solve problem (line 129 - line 131)

10. Show problem with text (line 134)

11. Show problem with plot (line 142)

# Some Notes

## About Merging Edges

Note that we never merge any edges even if they have the same function, because we believe that there is a one-to-one correspondance between the topological edges. When we manually create an edge, we should also specify the physical correspondence to this edge. 

## About Merging Cells

We write some notes on the merging cells process for fear of mistakes in code. 

There are some cells that contains edges which is really the boundary of the mesh. We also see these edges as the topological edge, because they connect different topological vertices. 

Therefore, there is only two possible situation for the 'one-edge' cell: (1) There is a part of mesh which is just a whole piece (only an edge of the boundary of the mesh), which is beyond our consideration (2) This cell is surrounded by another cell totally, but if we don't consider "the ring case", the ambient cell must have been colored. 

Similarly, there is only two possible situations for the 'two-edge' cell: (1) An edge is the boundary of the mesh, and the other edge is connecting another cell (2) The two edges connect different adjacent cell. In all, it is impossible that two edges connecting the same adjacent cell. 
