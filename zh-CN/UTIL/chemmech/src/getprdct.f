
C***************************************************************************
C  Significant portions of Models-3/CMAQ software were developed by        *
C  Government employees and under a United States Government contract.     *
C  Portions of the software were also based on information from non-       *
C  Federal sources, including software developed by research institutions  *
C  through jointly funded cooperative agreements. These research institu-  *
C  tions have given the Government permission to use, prepare derivative   *
C  works, and distribute copies of their work to the public within the     *
C  Models-3/CMAQ software release and to permit others to do so. EPA       *
C  therefore grants similar permissions for use of Models-3/CMAQ software, *
C  but users are requested to provide copies of derivative works to the    *
C  Government without re-strictions as to use by others.  Users are        *
C  responsible for acquiring their own copies of commercial software       *
C  associated with the Models-3/CMAQ release and are also responsible      *
C  to those vendors for complying with any of the vendors' copyright and   *
C  license restrictions. In particular users must obtain a Runtime license *
C  for Orbix from IONA Technologies for each CPU used in Models-3/CMAQ     *
C  applications.                                                           *
C                                                                          *
C  Portions of I/O API, PAVE, and the model builder are Copyrighted        *
C  1993-1997 by MCNC--North Carolina Supercomputing Center and are         *
C  used with their permissions subject to the above restrictions.          *
C***************************************************************************

C RCS file, release, date & time of last delta, author, state, [and locker]
C $Header$

C what(1) key, module and SID; SCCS file; date and time of last delta:
C @(#)GETPRDCT.F	1.1 /project/mod3/MECH/src/driver/mech/SCCS/s.GETPRDCT.F 02 Jan 1997 15:26:44

C:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
      SUBROUTINE GETPRDCT ( IMECH, INBUF, LPOINT, IEOL, CHR, WORD,
     &                      NXX, NS, SPCLIS, SPC1RX,
     &                      ICOL, 
     &                      N_DROP_SPC, DROP_SPC ) 
 

C=======================================================================
C sets up all product species and stoichiometric coefficients
C Maintain ITAB, which controls stoic. coeff. table, whereas ICOL
C controls NPRDCTS
C input: IMECH (for RDLINE), NXX, ICOL
C output: IRR, IRXBITS, SC
C updates: NS, SPCLIS
C=======================================================================
      USE MECHANISM_DATA
      
      IMPLICIT NONE


c...arguments

      INTEGER,         INTENT(   IN  ) :: IMECH
      CHARACTER( 81 ), INTENT( INOUT ) :: INBUF
      INTEGER,         INTENT( INOUT ) :: LPOINT
      INTEGER,         INTENT( INOUT ) :: IEOL
      CHARACTER(  1 ), INTENT( INOUT ) :: CHR
      CHARACTER( 16 ), INTENT( INOUT ) :: WORD
      INTEGER,         INTENT(   IN  ) :: NXX
      INTEGER,         INTENT( INOUT ) :: NS
      CHARACTER( 16 ), INTENT( INOUT ) :: SPCLIS( : )
      INTEGER,         INTENT( INOUT ) :: SPC1RX( : )
      INTEGER,         INTENT( INOUT ) :: ICOL
      INTEGER,         INTENT(   IN  ) :: N_DROP_SPC
      CHARACTER( 16 ), INTENT(   IN  ) :: DROP_SPC( : )
!      INTEGER,         INTENT(   IN  ) :: N_SS_SPC
!      CHARACTER( 16 ), INTENT(   IN  ) :: SS_SPC( MAXNLIST )
!      REAL,            INTENT( INOUT ) :: SS_PRD_COEF( MAXNLIST, MAXRXNUM )
!      INTEGER,         INTENT( INOUT ) :: IRR( MAXRXNUM,MAXPRODS+3 )
!      REAL,            INTENT( INOUT ) :: SC ( MAXRXNUM,MAXPRODS )

c... local

      CHARACTER( 16 )         :: SPECIES
      CHARACTER( 16 ),  SAVE :: RXN_PRODUCTS( MAXPRODS ) ! unique list of reaction products
      INTEGER                 :: NSPEC
      INTEGER                 :: ICHR
      INTEGER                 :: PRODUCT_INDEX ! pointer for reaction product
      LOGICAL                 :: LCOEFF
      LOGICAL                 :: LNEG
      LOGICAL                 :: CONSTANT_SPECIES
      INTEGER, SAVE           :: ITAB
      INTEGER, SAVE           :: NUMB_PRODUCTS ! number of unique reaction products
      REAL( 8 )                :: NUMBER

c..ELIMINATE related variables

c..STEADY_STATE related variables
      INTEGER            :: SS_INDEX
      REAL               :: SS_COEF
 
      INTEGER, EXTERNAL :: INDEX1

      INTERFACE 
        SUBROUTINE RDLINE ( IMECH, INBUF, LPOINT, IEOL )
         CHARACTER*( * ), INTENT( INOUT ) :: INBUF
         INTEGER,         INTENT( IN )    :: IMECH
         INTEGER,         INTENT( INOUT ) :: IEOL, LPOINT
        END SUBROUTINE RDLINE
        SUBROUTINE GETCHAR ( IMECH, INBUF, LPOINT, IEOL, CHR )
         INTEGER,         INTENT( IN )    :: IMECH
         CHARACTER*( * ), INTENT( INOUT ) :: INBUF
         INTEGER,         INTENT( INOUT ) :: IEOL, LPOINT
         CHARACTER*( * ), INTENT( INOUT ) :: CHR
        END SUBROUTINE GETCHAR
        SUBROUTINE GETREAL ( IMECH, INBUF, LPOINT, IEOL, CHR, NUMBER )
         INTEGER,         INTENT( IN )    :: IMECH   ! IO unit for mechanism file
         CHARACTER*( * ), INTENT( INOUT ) :: CHR     ! current character from buffer
         CHARACTER*( * ), INTENT( INOUT ) :: INBUF   ! string read from mechanism file
         INTEGER,         INTENT( INOUT ) :: LPOINT  ! character position in INBUF
         INTEGER,         INTENT( INOUT ) :: IEOL    ! end of line position
         REAL( 8 ),       INTENT( OUT )   :: NUMBER  ! number from file
        END SUBROUTINE GETREAL
        SUBROUTINE GETWORD ( IMECH, INBUF, LPOINT, IEOL, CHR, WORD )
         CHARACTER*( * ), INTENT( INOUT ) :: CHR
         CHARACTER*( * ), INTENT( INOUT ) :: INBUF
         INTEGER,         INTENT( IN )    :: IMECH
         INTEGER,         INTENT( INOUT ) :: IEOL, LPOINT
         CHARACTER*( * ), INTENT(  OUT  ) :: WORD
        END SUBROUTINE GETWORD
        SUBROUTINE LKUPSPEC ( NS, SPECIES, SPCLIS, NXX, SPC1RX, NSPEC )
         INTEGER,         INTENT(INOUT) :: NS
         INTEGER,         INTENT( OUT ) :: NSPEC
         INTEGER,         INTENT(INOUT) :: SPC1RX( : )
         INTEGER,         INTENT(  IN ) :: NXX
         CHARACTER*( * ), INTENT(  IN ) :: SPECIES
         CHARACTER*( * ), INTENT(INOUT) :: SPCLIS( : )
        END SUBROUTINE LKUPSPEC
      END INTERFACE

      IF ( ICOL .EQ. 3 )THEN  ! ICOL = 3 initially for each reaction
           NUMB_PRODUCTS = 0  
           RXN_PRODUCTS  = '                '
           ITAB          = 0  
      ENDIF
      ITAB = ITAB + 1
      LCOEFF = .FALSE.
      LNEG = .FALSE.     
      IF ( CHR .EQ. '+' ) THEN
         CALL GETCHAR ( IMECH, INBUF, LPOINT, IEOL, CHR )
      ELSE IF ( CHR .EQ. '-' ) THEN
         LNEG = .TRUE.
         CALL GETCHAR ( IMECH, INBUF, LPOINT, IEOL, CHR )
      END IF
      ICHR = ICHAR ( CHR )
C characters 0,1,2,...,9
      IF ( ICHR .GE. 48 .AND. ICHR .LE. 57 ) LCOEFF = .TRUE.
      IF ( CHR .EQ. '.' ) LCOEFF = .TRUE.
      IF ( LCOEFF ) THEN
         CALL GETREAL ( IMECH, INBUF, LPOINT, IEOL, CHR, NUMBER )
         IF ( CHR .EQ. '*' ) THEN
            CALL GETCHAR ( IMECH, INBUF, LPOINT, IEOL, CHR )
         ELSE
            WRITE( *,2003 ) INBUF
            STOP
         END IF
      END IF
      CALL GETWORD ( IMECH, INBUF, LPOINT, IEOL, CHR, WORD )
      SPECIES = WORD

c..Skip any product that is in the eliminate list
      IF( INDEX1( SPECIES, N_DROP_SPC, DROP_SPC ) .NE. 0 ) THEN
         ITAB = ITAB - 1
         RETURN
      ENDIF

c..Skip any steady-state species, but sum-up its coefficients in each reaction
      SS_INDEX = INDEX1( SPECIES, N_SS_SPC, SS_SPC )
      IF( SS_INDEX .NE. 0 ) THEN
         IF(       LCOEFF .AND.       LNEG )    SS_COEF = -NUMBER
         IF(       LCOEFF .AND. .NOT. LNEG )    SS_COEF = NUMBER
         IF( .NOT. LCOEFF .AND.       LNEG )    SS_COEF = -1.0
         IF( .NOT. LCOEFF .AND. .NOT. LNEG )    SS_COEF = 1.0
         SS_PRD_COEF( SS_INDEX, NXX ) = SS_PRD_COEF( SS_INDEX, NXX ) + SS_COEF
         ITAB = ITAB - 1
         RETURN
      ENDIF

      CONSTANT_SPECIES = .FALSE.

      IF ( SPECIES( 1:4 ) .EQ. 'M   '  .OR.
     &     SPECIES( 1:4 ) .EQ. 'm   ' ) THEN
         IRXBITS( NXX ) = IBSET ( IRXBITS( NXX ), 8)
         CONSTANT_SPECIES = .TRUE.
         NUMB_PRODUCTS  = NUMB_PRODUCTS + 1
         PRODUCT_INDEX  = NUMB_PRODUCTS
         RXN_PRODUCTS( PRODUCT_INDEX ) = SPECIES
      ELSE IF ( SPECIES( 1:4 ) .EQ. 'H2O '  .OR.
     &          SPECIES( 1:4 ) .EQ. 'h2o ' ) THEN
         IRXBITS( NXX ) = IBSET ( IRXBITS( NXX ), 9)
         CONSTANT_SPECIES = .TRUE.
         NUMB_PRODUCTS  = NUMB_PRODUCTS + 1
         PRODUCT_INDEX  = NUMB_PRODUCTS
         RXN_PRODUCTS( PRODUCT_INDEX ) = SPECIES
      ELSE IF ( SPECIES( 1:4 ) .EQ. 'O2  '  .OR.
     &          SPECIES( 1:4 ) .EQ. 'o2  ' ) THEN
         IRXBITS( NXX ) = IBSET ( IRXBITS( NXX ), 10)
         CONSTANT_SPECIES = .TRUE.
         NUMB_PRODUCTS  = NUMB_PRODUCTS + 1
         PRODUCT_INDEX  = NUMB_PRODUCTS
         RXN_PRODUCTS( PRODUCT_INDEX ) = SPECIES
      ELSE IF ( SPECIES( 1:4 ) .EQ. 'N2  '  .OR.
     &          SPECIES( 1:4 ) .EQ. 'n2  ' ) THEN
         IRXBITS( NXX ) = IBSET ( IRXBITS( NXX ), 11)
         CONSTANT_SPECIES = .TRUE.
         NUMB_PRODUCTS  = NUMB_PRODUCTS + 1
         PRODUCT_INDEX  = NUMB_PRODUCTS
         RXN_PRODUCTS( PRODUCT_INDEX ) = SPECIES
      ELSE
c..Check if species is already counted as a reaction product
         IF( NUMB_PRODUCTS .NE. 0 )THEN
             PRODUCT_INDEX = INDEX1( SPECIES, NUMB_PRODUCTS, RXN_PRODUCTS )
         ELSE
             PRODUCT_INDEX = 0
         END IF
         IF( PRODUCT_INDEX .NE. 0 ) THEN
            ITAB = ITAB - 1
            WRITE( 6, 2006 )NXX, TRIM(RXLABEL(NXX)), TRIM( SPECIES )
2006  FORMAT('REACTION# ', I5, ' : ', A,' has a reoccurance for product ', A,
     &       ' adjusting product and coefficient arrays.')
         ELSE
            NUMB_PRODUCTS  = NUMB_PRODUCTS + 1
            PRODUCT_INDEX  = NUMB_PRODUCTS
            RXN_PRODUCTS( PRODUCT_INDEX ) = SPECIES
            ICOL = ICOL + 1
            IF ( ICOL .GT. MAXPRODS+3 ) THEN
                WRITE( *,2005 ) INBUF
               STOP
            END IF
            CALL LKUPSPEC ( NS, SPECIES, SPCLIS, NXX, SPC1RX, NSPEC )
            IRR( NXX,ICOL ) = NSPEC
         ENDIF
      END IF  ! SPECIES .EQ. 'M   '

      IF ( LCOEFF ) THEN
         IF ( LNEG ) THEN
            SC( NXX, PRODUCT_INDEX ) = -NUMBER + SC( NXX, PRODUCT_INDEX )
!            SC( NXX,ITAB ) = -NUMBER
!            WRITE(KPPEQN_UNIT,'(A,F8.5,3A)', ADVANCE = 'NO')
!     &      '- ',SC( NXX,ITAB ),'*',TRIM(SPECIES),' '
         ELSE
            SC( NXX, PRODUCT_INDEX ) = NUMBER  + SC( NXX, PRODUCT_INDEX )
!            SC( NXX,ITAB ) = NUMBER
!            IF( ICOL .EQ. 4 )THEN
!                WRITE(KPPEQN_UNIT,'(F8.5, 3A)', ADVANCE = 'NO')
!     &          SC( NXX,ITAB ),'*',TRIM(SPECIES),' '
!            ELSE
!                WRITE(KPPEQN_UNIT,'(A,F8.5,3A)', ADVANCE = 'NO')
!    &          '+ ',SC( NXX,ITAB ),'*',TRIM(SPECIES),' '
!            END IF
         END IF
      ELSE IF ( LNEG ) THEN
         SC( NXX, PRODUCT_INDEX ) = -1.0D0  + SC( NXX, PRODUCT_INDEX )
!         SC( NXX,ITAB ) = -1.0
!         WRITE(KPPEQN_UNIT,'(3A)', ADVANCE = 'NO')
!    &          '- ',TRIM(SPECIES),' '
      ELSE 
         SC( NXX, PRODUCT_INDEX ) = 1.0D0  + SC( NXX, PRODUCT_INDEX )
!         SC( NXX,ITAB ) = 1.0
!         IF( ICOL .EQ. 4 )THEN
!             WRITE(KPPEQN_UNIT,'(3A)', ADVANCE = 'NO')
!     &       ' ',TRIM(SPECIES),' '
!         ELSE
!            WRITE(KPPEQN_UNIT,'(3A)', ADVANCE = 'NO')
!     &          '+ ',TRIM(SPECIES),' '
!         END IF
      END IF
      
      RETURN
2001  FORMAT( / 5X, '*** ERROR: Equal sign expected after reactants'
     &        / 5X, 'Last line read was:' / A81 )
2003  FORMAT( / 5X, '*** ERROR: An asterisk must follow a coefficient'
     &        / 5X, 'Last line read was:' / A81 )
2005  FORMAT( / 5X, '*** ERROR: Maximum number of products exceeded'
     &        / 5X, 'Last line read was:' / A81 )      
      END
