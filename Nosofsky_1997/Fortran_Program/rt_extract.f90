program rt_extract

! This program rearranges the simulation output so we have trial by trial info, 
! instead of simulation by simulation info. In addition, we drop all trials for
! while the response occured at the deadline.

implicit none

integer :: sim_num,trial

integer, parameter :: num_files = 100

integer :: junk, response, stim_type, response_time, i, max_trial, total_sims
real :: more_junk(2), total_pot, two_factor_pot, three_factor_pot, decay_pot, noise_pot, inhibit_pot, prop

integer :: rel_trials(num_files)

 character (len = 10) :: sim_num_string, rel_trial_string

! We read in the number of trials

open(5, file = 'input\nosofsky_params.dat')

read(5,*) max_trial

 close(5)

! Rel_trials.dat contains the relevant trials (this file is created by rt_extract.m)

open(10,file = 'input\rel_trials.dat')

read(10,*) total_sims

! Creates the files corresponding to the relevant trials

do i = 1,num_files

	read(10,*) rel_trials(i)
	write(rel_trial_string, '(I0)') rel_trials(i)
	open(100+i,file = 'output\rt_trial_'//trim(rel_trial_string)//'.dat')
	open(100+num_files+i,file = 'output\activity_trial_'//trim(rel_trial_string)//'.dat')

end do

 close(10)

do sim_num = 1,total_sims
	
	write(sim_num_string, '(I0)') sim_num
	
	open(50, file = 'output\response_'//trim(sim_num_string)//'.dat')
	open(60, file = 'output\prop_'//trim(sim_num_string)//'.dat')
	
	do trial = 1,max_trial
	
		read(50,*) junk, response, stim_type, response_time
		read(60,*) more_junk, total_pot, two_factor_pot, three_factor_pot, decay_pot, noise_pot, inhibit_pot, prop
		
		do i = 1,num_files
			
			if (trial == rel_trials(i)) then
			
				if (response_time < 3500) then 
				
					write (100+i,100) response, stim_type, response_time
					write (100+num_files+i,110) total_pot, two_factor_pot, three_factor_pot, decay_pot, noise_pot, &
						inhibit_pot, prop

				end if
				
			end if
						
		end do
	
	end do

	close(50)
	close(60)

end do

do i = 1,num_files

	close(100+i)
	close(100+num_files+i)

end do

100 format(3(i6,x))
110 format(7(f16.6,x))

end program

	
	
	
	
		
