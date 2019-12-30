# UltimateHDG_1D

This project is the completion and extension of my previous HDG 1D code. 

Main features of this 1D code

1. FEM foundations (general mesh, basis, quadrature, error-order)
2. HDG method (static condensation)
2. Non-problem specific (it can be easily extended to different 2nd order pdes)
3. Post-processing technique (Convolution filtering & Recovery method)
4. Adaptivity



All the folders and functions

1. problem driver
    * running scripts
2. mesh
    * everything aout the mesh: generate, refine
3. FEM_basics
    * basis functions and quadratures
    * matrices of basis functions
4. HDG_solver
    * local and global HDG solver
5. postprocessing
6. functional
7. adaptivity
8. logs
9. results
10. tests
