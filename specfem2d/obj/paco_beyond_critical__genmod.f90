        !COMPILER-GENERATED INTERFACE MODULE: Sat Mar 12 17:15:35 2016
        MODULE PACO_BEYOND_CRITICAL__genmod
          INTERFACE 
            SUBROUTINE PACO_BEYOND_CRITICAL(ANGLESOURCE,F0,QD,          &
     &SOURCE_TYPE,LEFT_BOUND,RIGHT_BOUND,BOT_BOUND,NLEFT,NRIGHT,NBOT,   &
     &X_SOURCE)
              INTEGER(KIND=4) :: NBOT
              INTEGER(KIND=4) :: NRIGHT
              INTEGER(KIND=4) :: NLEFT
              REAL(KIND=8) :: ANGLESOURCE
              REAL(KIND=8) :: F0
              REAL(KIND=8) :: QD
              INTEGER(KIND=4) :: SOURCE_TYPE
              INTEGER(KIND=4) :: LEFT_BOUND(NLEFT)
              INTEGER(KIND=4) :: RIGHT_BOUND(NRIGHT)
              INTEGER(KIND=4) :: BOT_BOUND(NBOT)
              REAL(KIND=8) :: X_SOURCE
            END SUBROUTINE PACO_BEYOND_CRITICAL
          END INTERFACE 
        END MODULE PACO_BEYOND_CRITICAL__genmod
