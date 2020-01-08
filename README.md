# UltimateHDG_1D

This project is the completion and extension of my previous HDG 1D code.

## Main features of this 1D code

1. FEM foundations (general mesh, basis, quadrature, error-order)
2. HDG method (static condensation)
2. Non-problem specific (it can be easily extended to different 2nd order pdes)
3. Post-processing technique (Convolution filtering & Recovery method)
4. Adaptivity



## All the folders and functions
:white_check_mark: done

:wrench: developing

:bulb: Empty
1. problem driver
    * :white_check_mark: main driver
    * :white_check_mark: PDE_driver
    * :bulb: Functional driver
    * :white_check_mark: user_info (two types of info)  
      * PDE_info
        * problem
        * Gauss Quadrature & numerical method
        * Post processing & Adaptivity
      * :wrench: Functional_info
2. mesh
    * :white_check_mark:generate mesh  ;
    * :white_check_mark: mesh properties ;
    * :white_check_mark: refine mesh(uniform and non-uniform)
3. FEM_basics
    * :white_check_mark: basis functions and quadratures
    * :white_check_mark: matrices of basis functions
    * :white_check_mark: Error Calculation and Error order
4. HDG_solver
    * :white_check_mark: local solver & Local matrix
    * :white_check_mark: global HDG solver
    * :white_check_mark: local recovery
5. postprocessing
    * :white_check_mark: Evaluate at quadrature points
    * :bulb: convoltuion
    * :bulb: Recovery
6. functional
    * :bulb: Volume integral
    * :bulb: boundary integral
7. adaptivity
    * :bulb: adjoint-correction without postprocessing
    * :bulb: postprocessing and adjoint-correction
8. logs
9. results
10. tests


## Potential problems

1. linespace with precision?
2. pass GQ points and weights, instead of computing every time



## To do list

Rewrite local solver and global solver into different routines because we want to do recovery later.
