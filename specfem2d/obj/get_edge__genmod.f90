        !COMPILER-GENERATED INTERFACE MODULE: Wed Oct 21 17:45:53 2015
        MODULE GET_EDGE__genmod
          INTERFACE 
            SUBROUTINE GET_EDGE(NGNOD,N,ITYPE,E1,E2,IXMIN,IXMAX,IZMIN,  &
     &IZMAX,SENS)
              INTEGER(KIND=4), INTENT(IN) :: NGNOD
              INTEGER(KIND=4), INTENT(IN) :: N(NGNOD)
              INTEGER(KIND=4), INTENT(IN) :: ITYPE
              INTEGER(KIND=4), INTENT(IN) :: E1
              INTEGER(KIND=4), INTENT(IN) :: E2
              INTEGER(KIND=4), INTENT(OUT) :: IXMIN
              INTEGER(KIND=4), INTENT(OUT) :: IXMAX
              INTEGER(KIND=4), INTENT(OUT) :: IZMIN
              INTEGER(KIND=4), INTENT(OUT) :: IZMAX
              INTEGER(KIND=4), INTENT(OUT) :: SENS
            END SUBROUTINE GET_EDGE
          END INTERFACE 
        END MODULE GET_EDGE__genmod
