! This is a test for model IO for WW3. This tests the legacy (binary)
! output of points data, done by function W3IOPO().
!
! Ed Hartnett 10/14/23
program test_io_points_bin
  use w3iopomd
  use w3gdatmd
  use w3wdatmd
  use w3odatmd
  use w3iogrmd
  use w3adatmd  
  implicit none
  
  integer, target :: i
  integer :: ndsop, iotest, ndsbul, ndsm
  integer :: ndstrc, ntrace
  character*7 expected_ptnme
  character*6 my_fmt
  real :: expected_loc_1
  integer :: write_test_file

  print *, 'Testing WW3 binary point file code.'

  ! These are mysterious but have to be called or else the IPASS
  ! variable does not exist and w3iopo() crashes.
  call w3nmod(1, 6, 6)
  call w3setg(1, 6, 6)
  call w3ndat(6, 6)
  call w3setw(1, 6, 6)
  call w3nout(6, 6)
  call w3seto(1, 6, 6)

  ndsm   = 20
  ndsop  = 20
  ndsbul = 0
  ndstrc =  6
  ntrace = 10
  
  ! Create a point output file needed for this test.
  if (write_test_file() .ne. 0) stop 1

  write (ndso,900)
900 FORMAT (/15X,'    *** WAVEWATCH III Point output post.***    '/ &
       15X,'==============================================='/)

  ! 2.  Read model definition file.
  CALL W3IOGR('READ', NDSM)
  WRITE (NDSO,920) GNAME
920 FORMAT ('  Grid name : ',A/)  

  ! This will not work. But cannot be tested because it will change the value of IPASS,
!  call w3iopo('EAD', ndsop, iotest)
!  if (iotest .ne. 1) stop 7

  ! Read the file out_pnt.ww3 from the model/tests/data directory.
  call w3iopo('READ', ndsop, iotest)
  if (iotest .ne. 0) stop 10
  close(ndsop)

  ! Make sure we got the values we expected.
  if (nopts .ne. 11) stop 11
  expected_loc_1 = 0.0
  do i = 1, nopts
     ! Check ptnme and ptloc arrays.
     print *, ptnme(i), ptloc(1, i), ptloc(2, i)
     if (i .lt. 10) then
        my_fmt = '(a,i1)'
     else
        my_fmt = '(a,i2)'
     endif
     write(fmt = my_fmt, unit=expected_ptnme) 'Point', i
     if (ptnme(i) .ne. expected_ptnme) stop 20
     print *, expected_loc_1
     if (ptloc(1, i) .ne. expected_loc_1) stop 21
     expected_loc_1 = expected_loc_1 + 5000.0
     if (ptloc(2, i) .ne. 0) stop 22
  end do
  
  print *, 'OK!'
  print *, 'SUCCESS!'
end program test_io_points_bin
