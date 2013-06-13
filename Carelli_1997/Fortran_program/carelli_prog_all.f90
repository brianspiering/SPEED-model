
program carelli_prog

! This program instantiates the SPEED model into a format where there is a pretrial 
! waiting period, a period of exposure to a response terminated stimulus, and a 500ms
! period of time during which there is no stimulus and feedback is being processed.

! In particular, this program is set up to model the data found in Carelli, Wolske and West's
! 1997 paper, "Loss of Lever Press-Related Firing of Rat Striatial Forelimb Neurons after
! Repeated Sessions in a Lever Presing Task"

! The response time is measured from the stimulus onset and is forced according 
! to the variable max_resp_time.

! This program uses a basic Euler's method to solve a system of
! differential equations corresponding to expertise learning.  In addition
! the theta parameters of the model change over time.  In this case
! the parameters are chosen to correspond to a subject early in learning.

use rnnof_int
use rnunf_int
use rnset_int

implicit none

integer, parameter :: wait_time = 1000
integer, parameter :: max_response_time = 7000
integer, parameter :: feedback_time = 500
integer, parameter :: three_factor_time_const = 2500

! Over the course of the experiment the rat can only press the lever 1000000 times

integer, parameter :: max_num_presses = 1000000 

integer, parameter :: square_length = 100
integer, parameter :: num_past = 50

integer, parameter :: theta_num = 9, alpha_num = 4, beta_num = 2

integer :: num_trials, three_factor_time, two_factor_time, start_index

real :: pot_thresh
real :: pot_mult
real :: caud_thresh, premot_thresh, response_thresh
real :: drug_theta
real :: dope_lesion

real :: max_res_pot
integer :: max_res_pot_time

integer :: t, trial, i
integer :: iseed
integer :: drug_start, drug_end

real :: reward_expect, decay_factor

integer, dimension(max_num_presses) :: press_count, reward_count
integer :: num_presses, reward_total

integer :: response_time

 character (len = 10) :: trial_string
 
! These variables are the activation levels in the various brain regions

real, dimension(15000) :: ActiveCA

real :: ActiveTA, ActiveGA, ActiveMA

! These variables are the square waves sent from region to region  

integer :: vis_to_caud, vis_to_premot, CAtoGA, GAtoTA, TAtoMA

integer :: CounterCAtoGA, CounterGAtoTA, CounterTAtoMA

! These variables are voltage potentials for the various regions

real :: PotCA, PotGA, PotTA, PotMA
 
! Next we have the parameters of the model

real, dimension(theta_num) :: theta
double precision, dimension(alpha_num) :: alpha
double precision, dimension(beta_num) :: beta
real :: noise, caud_noise_std, premot_noise_std
real ::dope_base, dope_plus, dope_minus, dope_level

! We have the sum activations for the visual cortex, the spines of the caudate, the caudate,
! and the SMA

real :: SumCA, SumMA

! Finally, we have the baseline firing rates of the thalamus and globus pallidus

real :: caud_base, glob_base, thal_base, premot_base

! We time the program as well.

integer :: count_0, count_1, count_rate, count_max
real :: time0, time1, elapsed_time

! Begin timing.

 call system_clock(count_0, count_rate, count_max)

time0 = count_0*1.0/count_rate

open(10,file = 'input\carelli_params.dat')

read(10,*) num_trials

read(10,*) iseed

read(10,*) dope_base

read(10,*) caud_base

read(10,*) glob_base

read(10,*) thal_base

read(10,*) premot_base

read(10,*) pot_mult
 
read(10,*) pot_thresh

read(10,*) response_thresh

read(10,*) caud_thresh

read(10,*) premot_thresh

read(10,*) caud_noise_std ! Noise in caudate areas

read(10,*) premot_noise_std ! Noise in premotor areas

do i = 1,theta_num

	read(10,*) theta(i)
	
end do

do i = 1,alpha_num

	read(10,*) alpha(i)
	alpha(i) = alpha(i)/(1000000*1.0)
	
end do

do i = 1,beta_num

	read(10,*) beta(i)
	beta(i) = beta(i)/(1000000*1.0)
	
end do 

read(10,*) drug_start ! Starting trial of drug

read(10,*) drug_end ! Ending trial of drug

read(10,*) drug_theta ! Drug parameter

read(10,*) dope_lesion

 close(10)

! The rat starts with no expectation of reward associated with the lever push

reward_expect = 0

! For the purposes of computing the expectation of reward in the future
! we have two bookkeeping variables.

press_count = 0 
reward_count = 0

! The rat hasn't put its head in the box at all yet

num_presses = 0 

! We output the intitial random seed this run of the experiment uses

 call rnset(iseed)

 call rnget(iseed)
 
 write(*,*) 'Initial seed =', iseed

! We generate the initial strengths of the synapses between visual cortex and
! caudate and premotor areas

open(30, file = 'output\response.dat')
open(95, file = 'output\expectation.dat')
open(96, file = 'output\dope_levels.dat')
open(97, file = 'output\params.dat')
open(98, file = 'output\max_res_pot.dat')
open(99, file = 'output\sumactive.dat')

! Start of trial

do trial = 1, num_trials
	
		! For starters, we reset the response variables

		PotMA = 0 
		max_res_pot = 0 
		max_res_pot_time = 0 
		response_time = 0 

		! We also reset the sum activation variables for the trial
	
		SumCA = 0
		SumMA = 0

		! We initialize the variables

		ActiveCA = caud_base
		ActiveGA = glob_base
		ActiveTA = thal_base
		ActiveMA = premot_base

		CAtoGA = 0
		GAtoTA = 0
		TAtoMA = 0
		
		PotCA = 0
		PotGA = 0
		PotTA = 0

		vis_to_caud = 0
		vis_to_premot = 0
		
		CounterCAtoGA = square_length
		CounterGAtoTA = square_length
		CounterTAtoMA = square_length

		! Now we prepare the output file
	
		write(trial_string, '(I0)') trial
		 
		open(40, file = 'output\ActivationsT'//trim(trial_string)//'.dat')

		! There is the time before the stimulus onset

		do t = 1, wait_time
			
		! We have activity in the caudate, which includes noise
		
			ActiveCA(t) = new_caud_act(ActiveCA(t-1),vis_to_caud)
			PotCA = pot_mult*PotCA + ActiveCA(t)
		
			if (PotCA >= pot_thresh) then 
		
				counterCAtoGA = 0
				PotCA = 0
				CAtoGA = 1
						
			end if 

		! Next we have activity in the globus palidus
		
			if (counterCAtoGA < square_length) then 

				counterCAtoGA = counterCAtoGA + 1

			else 

				CAtoGA = 0

			end if
	
			ActiveGA = new_glob_act(ActiveGA,CAtoGA)
			PotGA = pot_mult*PotGA + ActiveGA
		
			if (PotGA >= pot_thresh) then 
		
				counterGAtoTA = 0
				PotGA = 0
				GAtoTA = 1
		
			end if 
	
		! The decreased activity in the globus palidus allows the activity in the thalamus to increase
		
			if (counterGAtoTA < square_length) then 
		
				counterGAtoTA = counterGAtoTA + 1
	
			else 
		
				GAtoTA = 0
		
			end if
	
		
			ActiveTA = new_thal_act(ActiveTA,GAtoTA)
			PotTA = pot_mult*PotTA + ActiveTA
				
			if (PotTA >= pot_thresh) then 
		
				counterTAtoMA = 0
				PotTA = 0
				TAtoMA = 1
	
			end if 
	
		! Finally, the activity in the thalamus causes activity in a premotor area
					
			if (counterTAtoMA < square_length) then 
		
				counterTAtoMA = counterTAtoMA + 1
		
			else 
			
				TAtoMA = 0
			
			end if

			ActiveMA = new_premot_act(ActiveMA,vis_to_premot,TAtoMA)
			PotMA = pot_mult*PotMA + ActiveMA
			
		! Now we see if the rat presses the lever

			if (PotMA >= response_thresh) then 
								
				PotMA = 0 				
	
			end if			
											
			write(40,100) ActiveCA(t), ActiveGA, ActiveTA, ActiveMA

		end do 

		! A tone sounds, and we assume that this tone is held in reverberating loops 
		! in auditory cortex until feedback is processed

		vis_to_caud = 1
		vis_to_premot = 1

		! If the rat presses the lever during the next time period it receives a
		! reward.  
	
		do t = wait_time + 1, wait_time + max_response_time

		! We have activity in the caudate, which includes noise
		
			ActiveCA(t) = new_caud_act(ActiveCA(t-1),vis_to_caud)
			PotCA = pot_mult*PotCA + ActiveCA(t)
		
			if (PotCA >= pot_thresh) then 
		
				counterCAtoGA = 0
				PotCA = 0
				CAtoGA = 1
						
			end if 

		! Next we have activity in the globus palidus
		
			if (counterCAtoGA < square_length) then 

				counterCAtoGA = counterCAtoGA + 1

			else 

				CAtoGA = 0

			end if
	
			ActiveGA = new_glob_act(ActiveGA,CAtoGA)
			PotGA = pot_mult*PotGA + ActiveGA
		
			if (PotGA >= pot_thresh) then 
		
				counterGAtoTA = 0
				PotGA = 0
				GAtoTA = 1
		
			end if 
	
		! The decreased activity in the globus palidus allows the activity in the thalamus to increase
		
			if (counterGAtoTA < square_length) then 
		
				counterGAtoTA = counterGAtoTA + 1
	
			else
		
				GAtoTA = 0
		
			end if
	
		
			ActiveTA = new_thal_act(ActiveTA,GAtoTA)
			PotTA = pot_mult*PotTA + ActiveTA
				
			if (PotTA >= pot_thresh) then 
		
				counterTAtoMA = 0
				PotTA = 0
				TAtoMA = 1
	
			end if 
	
		! Finally, the activity in the thalamus causes activity in a premotor area
					
			if (counterTAtoMA < square_length) then 
		
				counterTAtoMA = counterTAtoMA + 1
		
			else 
			
				TAtoMA = 0
			
			end if

			ActiveMA = new_premot_act(ActiveMA,vis_to_premot,TAtoMA)
			PotMA = pot_mult*PotMA + ActiveMA
			SumMA = SumMA + ActiveMA
			
		! We see if we have a maximal PotMA activation, and record it and the
		! time it happens if we do
		
			if (PotMA > max_res_pot) then
			
				max_res_pot = PotMA
				max_res_pot_time = t
				
			end if 
			
		! Now we see if the rat presses the lever.  During this time, if the 
		! rat presses the lever he gets a reward
	
			if (PotMA >= response_thresh) then 

				num_presses = num_presses + 1
				reward_count(num_presses) = 1
								
				PotMA = 0 				

				response_time = t - wait_time

				goto 500

			end if			
									
			write(40,100) ActiveCA(t), ActiveGA, ActiveTA, ActiveMA

		end do 

		! We force a response if max_response_time is reached

		response_time = max_response_time

500 continue

		! There is the final waiting period

		do t = wait_time + response_time + 1, wait_time + response_time + feedback_time

		! We have activity in the caudate, which includes noise
		
			ActiveCA(t) = new_caud_act(ActiveCA(t-1),vis_to_caud)
			PotCA = pot_mult*PotCA + ActiveCA(t)
		
			if (PotCA >= pot_thresh) then 
		
				counterCAtoGA = 0
				PotCA = 0
				CAtoGA = 1
						
			end if 

		! Next we have activity in the globus palidus
		
			if (counterCAtoGA < square_length) then 

				counterCAtoGA = counterCAtoGA + 1

			else 

				CAtoGA = 0

			end if
	
			ActiveGA = new_glob_act(ActiveGA,CAtoGA)
			PotGA = pot_mult*PotGA + ActiveGA
		
			if (PotGA >= pot_thresh) then 
		
				counterGAtoTA = 0
				PotGA = 0
				GAtoTA = 1
		
			end if 
	
		! The decreased activity in the globus palidus allows the activity in the thalamus to increase
		
			if (counterGAtoTA < square_length) then 
		
				counterGAtoTA = counterGAtoTA + 1
	
			else 
		
				GAtoTA = 0
		
			end if
	
			ActiveTA = new_thal_act(ActiveTA,GAtoTA)
			PotTA = pot_mult*PotTA + ActiveTA
				
			if (PotTA >= pot_thresh) then 
		
				counterTAtoMA = 0
				PotTA = 0
				TAtoMA = 1
	
			end if 
	
		! Finally, the activity in the thalamus causes activity in a premotor area
					
			if (counterTAtoMA < square_length) then 
		
				counterTAtoMA = counterTAtoMA + 1
		
			else 
			
				TAtoMA = 0
			
			end if

			ActiveMA = new_premot_act(ActiveMA,vis_to_premot,TAtoMA)
			SumMA = SumMA + ActiveMA
									
			write(40,100) ActiveCA(t), ActiveGA, ActiveTA, ActiveMA
			
		end do ! End of post trial waiting period

	! In the typical experiment there will only be dopamine above baseline
	! as the rat is rewarded on every trial

		dope_minus = 0
		
		if (response_time < max_response_time) then
		
			dope_plus = (1-reward_expect)*(1-dope_base)
		
			! We compute a decay factor that we use to ensure that the caudate
			! goes off line once expectation of a correct response is high
		
			decay_factor = cap(1 - dope_plus/(1-dope_base))
			
		else

			dope_plus = 0

			decay_factor = 0

			
		end if

	! We model the effect of a dopamine antagonist on dopamine levels

		if (trial >= drug_start) then
		
			if (trial <= drug_end) then

				dope_plus = drug_theta*dope_plus
				dope_minus = drug_theta*dope_minus
				
			end if 
			
		end if

	! We adjust the dopamine levels based on whether there is a lesion.
	
		dope_plus = pos(dope_lesion*dope_plus - (1-dope_lesion)*dope_base)
		dope_minus = dope_lesion*dope_minus + (1-dope_lesion)*dope_base

	! We compute a decay factor that we use to ensure that the caudate
	! goes off line once expectation of a correct response is high
	
		decay_factor = 1 - dope_plus/(1-dope_base)

	! We determine the actual dopamine level for the trial

		dope_level = dope_base + dope_plus - dope_minus

		three_factor_time = min(wait_time + response_time + feedback_time,three_factor_time_const)
	
		do i = wait_time + response_time + feedback_time - three_factor_time + 1, & 
			wait_time + response_time + feedback_time
	
			SumCA = SumCA + ActiveCA(i)
				
		end do
	
		two_factor_time = response_time+feedback_time
			
	! Next we have our learning equations

		! 3 factor learning

		theta(1) = cap(threefactor(theta(1),SumCA,three_factor_time))
	
		! 2 factor learning
			
		theta(7) = cap(twofactor(theta(7),SumMA,two_factor_time))
	
	! Finally, we update the expectation of reward

		reward_total = 0
		
		start_index = max(1,num_presses-num_past+1)
		
		do i = start_index, num_presses
			
			reward_total = reward_total + reward_count(i)
			
		end do

		reward_expect = (reward_total*1.0)/(num_past*1.0)

	! We record the caudate activations for our own purposes

	write(96,105) trial, dope_level	
	write(97,140) theta(1), theta(7)
	write(98,150) max_res_pot_time, max_res_pot 
	write(99,160) three_factor_time, SumCA, two_factor_time, SumMA
	write(95,*) trial, reward_expect
	write(30,110) trial, response_time

	close(40)

end do ! End of trial
	
 close(30)
 close(95)
 close(96)
 close(97)
 close(98)
 close(99)

100 format(4(f8.5,x))
105 format(i10,x,f10.7)
110 format(i10,x,i6,x)
140 format(2(x,f9.6))
150 format(i6,x,f9.2)
160 format(2(i10,x,f9.2,x))

! End timing 

 call system_clock(count_1, count_rate, count_max)      

time1 = count_1*1.0/count_rate

! Compute the elapsed time.

elapsed_time = time1-time0

write(*,*) 'Number of Trials =', num_trials
write(*,*) 'Time taken, in seconds =', elapsed_time

 contains

function new_caud_act(old_act,vis_input)

real :: new_caud_act
real :: old_act
integer :: vis_input

noise = rnnof()	
	
new_caud_act = cap(old_act + theta(1)*vis_input*(1-old_act) - theta(2)*(old_act - caud_base) &
		 + noise*caud_noise_std*old_act*(1-old_act))

end function new_caud_act

function new_glob_act(old_act,caud_input)

real :: new_glob_act
real :: old_act
integer :: caud_input

new_glob_act = cap(old_act - theta(3)*caud_input*old_act - theta(4)*(old_act-glob_base))

end function new_glob_act

function new_thal_act(old_act,glob_input)

real :: new_thal_act
real :: old_act
integer :: glob_input

new_thal_act = cap(old_act - theta(5)*glob_input*old_act - theta(6)*(old_act-thal_base))

end function new_thal_act

function new_premot_act(old_act,vis_input,thal_input)

real :: new_premot_act
real :: old_act
integer :: thal_input, vis_input

noise = rnnof()

new_premot_act = cap(old_act + (theta(7)*vis_input+theta(8)*thal_input)*(1-old_act)-theta(9)*(old_act-premot_base) &
			+ noise*premot_noise_std*old_act*(1-old_act))

end function new_premot_act

function twofactor(theta,premot_sum,vis_sum)

real :: twofactor
real :: theta, premot_sum
integer :: vis_sum

twofactor = theta + beta(1)*Pos(premot_sum-premot_thresh)*vis_sum*(1-theta) &
 - beta(2)*Pos(premot_thresh-premot_sum)*vis_sum*theta

end function twofactor

function threefactor(theta,caud_sum,vis_sum)

real :: threefactor
real :: theta, caud_sum
integer :: vis_sum

threefactor = theta + alpha(1)*Pos(caud_sum-caud_thresh)*vis_sum*dope_plus*(1-theta) &
	- alpha(2)*Pos(caud_sum-caud_thresh)*vis_sum*dope_minus*theta - alpha(3)*&
	Pos(caud_thresh-caud_sum)*vis_sum*theta - alpha(4)*theta*decay_factor*vis_sum

end function threefactor

function pos(input)

real :: pos

real :: input

if (input < 0) input = 0

pos = input

end function pos

function cap(input)

real :: cap

real :: input

if (input < 0) input = 0

if (input > 1) input = 1

 cap = input

end function cap

end program carelli_prog
