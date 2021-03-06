README

This software links Matlab to GridLAB-D in order to find the optimal locations and sizes for distributed generation in the IEEE37 grid. 

Run through run_dg_optimisation.m

Requirements:
- MATLAB
- GridLAB-D

This simulation code is compatible with MAC and WINDOWS OS. 

Warnings:
- Close all excel sheets linked to gridlabd while running code, otherwise they may not be refreshing

gridlabd files
- Number buses on your grid, and name them accordingly in the gridlabd file as nodes
- The underground/overhead lines should be ordered such that the "to nodes" are order in numerical order (e.g first line should be 
(from node1 to node2, from nodex to node3 and so on). This matters when it comes to establishing phase connections in the matlab code.

To preview the animations go to:
Case Without regulator:
1) http://htmlpreview.github.io/?https://github.com/islaziyat/gridlabd-optimisation/blob/master/Grid_Animation/grid-plot.html
2) http://htmlpreview.github.io/?https://github.com/islaziyat/gridlabd-optimisation/blob/master/Grid_Animation/voltage_graph.html

Case With regulator:
3) http://htmlpreview.github.io/?https://github.com/islaziyat/gridlabd-optimisation/blob/master/Grid_Animation/grid-plot-reg.html
4) http://htmlpreview.github.io/?https://github.com/islaziyat/gridlabd-optimisation/blob/master/Grid_Animation/voltage_graph-reg.html

Or download the code and click the html file from your files

