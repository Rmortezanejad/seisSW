        !COMPILER-GENERATED INTERFACE MODULE: Sun May  1 23:06:47 2016
        MODULE DEFINE_SHAPE_FUNCTIONS__genmod
          INTERFACE 
            SUBROUTINE DEFINE_SHAPE_FUNCTIONS(SHAPE2D,DERSHAPE2D,XI,    &
     &GAMMA,NGNOD)
              INTEGER(KIND=4) :: NGNOD
              REAL(KIND=8) :: SHAPE2D(NGNOD)
              REAL(KIND=8) :: DERSHAPE2D(2,NGNOD)
              REAL(KIND=8) :: XI
              REAL(KIND=8) :: GAMMA
            END SUBROUTINE DEFINE_SHAPE_FUNCTIONS
          END INTERFACE 
        END MODULE DEFINE_SHAPE_FUNCTIONS__genmod
