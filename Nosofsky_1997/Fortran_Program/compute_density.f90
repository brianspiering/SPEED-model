program compute_density

! This program reads in a data file and outputs a density function
! according to the method of Parzen (1962).

implicit none

integer :: h, i, t, trial, n

integer, parameter :: start_input = 0, end_input = 3500

double precision :: sum_tot, d_data(20000), density, junk(2), test_sum

 character (len = 10) :: trial_string

open(10, file = 'input\density_info.dat')

read(10,*) h, trial, n

 close(10)

write(trial_string, '(I0)') trial

open(20,file = 'output\rt_corr_trial_'//trim(trial_string)//'.dat')
 
do i = 1,n 

	read(20,*) junk, d_data(i)

end do

 close(20)

open(30, file = 'output\density_output.dat')

test_sum = 0

do t = start_input, end_input

	sum_tot = 0
	
	do i = 1,n
	
		sum_tot = sum_tot + exp(-(t-d_data(i))*(t-d_data(i)*1.0)/(h*h*1.0))
					
	end do
	
	density = 0.56418958355473*sum_tot/(n*h)
	
	test_sum = test_sum + density
	
	write(30,100) density
	
end do

! write(*,*) test_sum

100 format(f32.28)

 close(30)
 
end program compute_density









