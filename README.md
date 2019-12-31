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
    * :white_check_mark:main driver
    * :wrench: PDE_driver
    * :bulb: Functional driver
    * :wrench: user_info (two types of info)  
      * PDE_info
        * problem
        * Gauss Quadrature & numerical method
        * Post processing & Adaptivity
      * Functional_info
2. mesh
    * :white_check_mark:generate mesh  ;
    * :white_check_mark: mesh properties ;
    * :white_check_mark: refine mesh(uniform and non-uniform)
3. FEM_basics
    * :white_check_mark: basis functions and quadratures
    * :white_check_mark: matrices of basis functions
    * :bulb: Error Calculation
4. HDG_solver
    * :wrench: local solver
    * :wrench: global HDG solver
5. postprocessing
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
