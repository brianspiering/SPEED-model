program extract_correct

implicit none

integer :: response, stim_type, response_time, trial,i

integer :: num_trials, file_length

 character (len = 10) :: trial_string

open(5,file = 'input\extract_info.dat')

read(5,*) num_trials

do trial = 1, num_trials

	write(*,*) trial

	write(trial_string, '(I0)') trial

	open(10,file = 'output\rt_trial_'//trim(trial_string)//'.dat')
	open(20,file = 'output\rt_corr_trial_'//trim(trial_string)//'.dat')

	read(5,*) file_length
	
	do i = 1, file_length

		read(10,*) response, stim_type, response_time
		if (response == stim_type) write(20,*) response, stim_type, response_time
		
	end do
	
	close(10)
	close(20)
	
end do

close(5)

end program extract_correct
	
	
