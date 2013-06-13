program nosofsky_prog_pro_rt

use rnnof_int
use rnunf_int
use rnset_int

implicit none

! This program instantiates the SPEED model into a format where there is a pretrial 
! waiting period, a period of exposure to a response terminated stimulus, and a 500ms
! period of time during which there is no stimulus and feedback is being processed.

! In particular, this program is set up to model the data found in Nosofsky and Palmeri's 
! 1997 paper, "An exemplar based random walk model of speeded classification"

! The response time is measured from the stimulus onset and is forced according 
! to the variable max_resp_time.

! This program uses a basic Euler's method to solve a system of
! differential equations corresponding to expertise learning.  In addition
! the theta parameters of the model change over time.  In this case
! the parameters are chosen to correspond to a subject early in learning.

integer, parameter :: square_length = 100
integer, parameter :: half_max_window = 50
integer, parameter :: grid_size = 100

integer, parameter :: num_past = 50

! For Nosofsky there is a 2 second feedback period and a 500 ms i.t.i
! We place 1500 of the 2000 ms of feedback period at the beginning of the trial and 500 at the end.

integer, parameter :: wait_time = 2000 

integer, parameter :: max_response_time = 3500 

integer, parameter :: feedback_time = 500
integer, parameter :: three_factor_time_const = 2500

integer, parameter :: theta_num = 9, alpha_num = 4, beta_num = 2

integer :: three_factor_time

real :: caud_base, glob_base, thal_base, premot_base
real :: caud_start, caud_range

real :: pot_thresh, pot_mult, premot_thresh, caud_thresh, response_thresh, diff_pot, diff_pot_mult, &
	diff_pot_two_factor, diff_pot_three_factor, diff_pot_decay, diff_pot_noise, diff_pot_inhibit, &
	prop
	
integer :: t, trial, i,j, num_correct, two_factor_time
integer :: stim_type, response, response_time, num_trials

real :: prob_correct, decay_factor, x, y, x_start, y_start, x_end, y_end, temp

real, dimension(grid_size,grid_size) :: strengthCA, strengthCB, strengthMA, & 
 strengthMB, visAct

real, dimension(-half_max_window:half_max_window,-half_max_window:half_max_window) :: filter 

integer ::  filter_width, t_f_w_squared, twice_filter_width ! The filter smoothing function
! is modeled after a bivariate normal pdf

integer :: x_dist, y_dist, iseed

integer, dimension(num_past) :: results
 
logical :: A_flag, B_flag

! These variables are the activation levels in the various brain regions

real :: ActiveTA, ActiveTB, ActiveGA, ActiveGB
real ::	vis_to_CA, vis_to_CB, vis_to_MA, vis_to_MB

! Some of the activation variables are catelogued throughout the trial for the sake
! of the learning equaitions

real, dimension(0:15000) :: ActiveCA, ActiveCB, ActiveMA, ActiveMB

! These variables are the square waves sent from region to region  

integer :: CAtoGA, CBtoGB, GAtoTA, GBtoTB, TAtoMA, TBtoMB

integer :: CounterCAtoGA, CounterCBtoGB, CounterGAtoTA, CounterGBtoTB, & 
 CounterTAtoMA, CounterTBtoMB, CounterVAtoMA, CounterVBtoMA, CounterVAtoMB, CounterVBtoMB

! These variables are voltage potentials for the various regions

real :: PotCA, PotCB, PotGA, PotGB, PotTA, PotTB

! These variables will measure how much of the activation leading to the response
! is due to the 3-factor system, and how much is due to the 2-factor system.

real :: rescale_const, two_factorA, three_factorA, decayA, & 
 noiseA, inhibitA, pot_two_factorA, pot_three_factorA, pot_decayA, pot_noiseA, pot_inhibitA, &
 two_factorB, three_factorB, decayB, noiseB, inhibitB, pot_two_factorB, pot_three_factorB, & 
 pot_decayB, pot_noiseB, pot_inhibitB, intended_change, actual_change, change_two_factorA, &
 change_three_factorA, change_decayA, change_noiseA, change_inhibitA, change_two_factorB, &
 change_three_factorB, change_decayB, change_noiseB, change_inhibitB
 
! Next we have the parameters of the model

real, dimension(theta_num) :: theta
double precision, dimension(alpha_num) :: alpha
double precision, dimension(beta_num) :: beta
real :: noise, caud_noise_std, premot_noise_std
real ::dope_base, dope_plus, dope_minus, dope_level

! We have the sum activations for the visual cortex, the spines of the caudate, the caudate,
! and the premotor areas

real :: SumVA, SumVB, SumCA, SumCB, SumMA, SumMB
real :: spineA, spineB, preA, preB

! We use the following variables to time the program

integer :: count_0, count_1, count_rate, count_max
real :: time_0, time_1, elapsed_time

! Begin timing.

 call system_clock(count_0, count_rate, count_max)

time_0 = count_0*1.0/count_rate

open(10,file = 'input\nosofsky_params.dat')

read(10,*) num_trials

read(10,*) filter_width ! filter_width is an integer leq 25

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

read(10,*) caud_start

read(10,*) caud_range

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

read(10,*) diff_pot_mult

 close(10)

prob_correct = 0

results = 0

 call rnset(iseed)

 call rnget(iseed)
 
 write(*,*) 'Initial seed =', iseed

! We generate the initial strengths of the synapses between visual cortex and
! caudate and premotor areas.  We also set up the gaussian smoothing filter

 call rnset(iseed)

do i = 1, grid_size

	do j = 1, grid_size

		noise = rnunf()
		strengthCA(i,j) = caud_start + caud_range*noise
		noise = rnunf()
		strengthCB(i,j) = caud_start + caud_range*noise
	
	end do
	
end do 

strengthMA = 0
strengthMB = 0

t_f_w_squared = 2*filter_width*filter_width
twice_filter_width = 2*filter_width

do i = -half_max_window, half_max_window

	do j = -half_max_window, half_max_window
	
		temp = i*i + j*j
		temp = -temp/t_f_w_squared
		Filter(i,j) = exp(temp)

	end do
	
end do

Filter = Filter/filter_width

! We rescale the visual cell 2 factor learning threshold 
! to account for the fact that big filters are flatter.

open(20, file = 'input\nosofsky_stim.dat')
open(30, file = 'output\response.dat')
open(50, file = 'output\prop.dat')

num_correct = 0
	
	do trial = 1, num_trials
	
		! We start a new trial here.  
	
		! For starters, we reset the response variables
	
		diff_pot = 0

		! We initialize the visual activation 
		
		visact = 0

		! We also reset the sum activation variables for the trial
	
		SumVA = 0
		SumVB = 0
		SumCA = 0
		SumCB = 0
		SumMA = 0
		SumMB = 0

		! We initialize the variables

		ActiveCA(0) = caud_base
		ActiveCB(0) = caud_base
		ActiveGA = glob_base
		ActiveGB = glob_base
		ActiveTA = thal_base
		ActiveTB = thal_base
		ActiveMA(0) = premot_base
		ActiveMB(0) = premot_base
		

		VisAct = 0		
		vis_to_CA = 0
		vis_to_CB = 0
		vis_to_MA = 0
		vis_to_MB = 0
		 CAtoGA = 0
		 CBtoGB = 0
		GAtoTA = 0
		GBtoTB = 0
		TAtoMA = 0
		TBtoMB = 0
		
		PotCA = 0
		PotCB = 0
		PotGA = 0
		PotGB = 0
		PotTA = 0
		PotTB = 0 

		two_factorA = 0
		three_factorA = 0
		decayA = 0
		noiseA = 0
		inhibitA = 0
		
		two_factorB = 0
		three_factorB = 0
		decayB = 0
		noiseB = 0
		inhibitB = 0

		pot_two_factorA = 0
		pot_three_factorA = 0
		pot_decayA = 0
		pot_noiseA = 0
		pot_inhibitA = 0

		pot_two_factorB = 0
		pot_three_factorB = 0
		pot_decayB = 0
		pot_noiseB = 0
		pot_inhibitB = 0		 
				
		CounterCAtoGA = square_length
		CounterCBtoGB = square_length
		CounterGAtoTA = square_length
		CounterGBtoTB = square_length
		CounterTAtoMA = square_length
		CounterTBtoMB = square_length 
		CounterVAtoMA = square_length
		CounterVBtoMA = square_length
		CounterVAtoMB = square_length
		CounterVBtoMB = square_length 

		A_flag = .false.
		B_flag = .false.

		! We start off the trial with no visual activation
		
		do t = 1, wait_time
			
		! We start with activity in the caudate, which includes noise
				
			ActiveCA(t) = new_caud_act_ni(ActiveCA(t-1),vis_to_CA)
			PotCA = pot_mult*PotCA + ActiveCA(t)
					
			if (PotCA >= pot_thresh) then 
		
				counterCAtoGA = 0
				PotCA = 0
				CAtoGA = 1
		
			end if 
	
			ActiveCB(t) = new_caud_act_ni(ActiveCB(t-1),vis_to_CB)	
			PotCB = pot_mult*PotCB + ActiveCB(t)
		
			if (PotCB >= pot_thresh) then 
		
				counterCBtoGB = 0
				PotCB = 0
				CBtoGB = 1
		
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
	
			if (counterCBtoGB < square_length) then 

				counterCBtoGB = counterCBtoGB + 1
		
			else 
			
				CBtoGB = 0
			
			end if
	
			ActiveGB = new_glob_act(ActiveGB,CBtoGB)
			PotGB = pot_mult*PotGB + ActiveGB
		
			if (PotGB >= pot_thresh) then 
		
				counterGBtoTB = 0
				PotGB = 0
				GBtoTB = 1
		
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
	
			if (counterGBtoTB < square_length) then 
			
				counterGBtoTB = counterGBtoTB + 1
			
			else 
		
				GBtoTB = 0
		
			end if
	
			ActiveTB = new_thal_act(ActiveTB,GBtoTB)
			PotTB = pot_mult*PotTB + ActiveTB
		
			if (PotTB >= pot_thresh) then 
		
				counterTBtoMB = 0
				PotTB = 0
				TBtoMB = 1
		
			end if 
		
		! Finally, the activity in the thalamus causes activity in a premotor area
					
			if (counterTAtoMA < square_length) then 
			
				counterTAtoMA = counterTAtoMA + 1
			
			else 
				
				TAtoMA = 0

			end if
				
			ActiveMA(t) = new_premot_act_ni(ActiveMA(t-1),vis_to_MA,TAtoMA)
			
			if (counterTBtoMB < square_length) then 
			
				counterTBtoMB = counterTBtoMB + 1
			
			else 
			
				TBtoMB = 0
				
			end if
	
			ActiveMB(t) = new_premot_act_ni(ActiveMB(t-1),vis_to_MB,TBtoMB)
			
		end do ! End of waiting period

		! We figure out what the visual activations will be for the trial
		
		read(20,*) stim_type, x, y

		x_start = x - twice_filter_width
		x_end = x + twice_filter_width
		y_start = y - twice_filter_width
		y_end = y + twice_filter_width

		if (x_start < 1) x_start = 1
		if (x_end > 100) x_end = 100
		if (y_start < 1) y_start = 1
		if (y_end > 100) y_end = 100
				
		do i = x_start, x_end
		
			do j = y_start, y_end
									
		! We compute the activation in each visual cell
						
				x_dist = i-x
				y_dist = j-y
						
				VisAct(i,j) = Filter(x_dist,y_dist)
				
		! Now we determine the effects of the visual cortex on the caudate 
		! cells and the premotor areas.  These values will be constant throughout
		! the trial

				SpineA = strengthCA(i,j)*VisAct(i,j)
				SpineB = strengthCB(i,j)*VisAct(i,j)
				PreA = strengthMA(i,j)*VisAct(i,j)
				PreB = strengthMB(i,j)*VisAct(i,j)
				
				vis_to_CA = vis_to_CA + SpineA
				vis_to_CB = vis_to_CB + SpineB
				vis_to_MA = vis_to_MA + PreA
				vis_to_MB = vis_to_MB + PreB
			
			end do
			
		end do

		! Now we're ready for the portion of the trial where the response terminated
		! stimulus is actually shown to the subject
		
		do t = wait_time + 1, wait_time + max_response_time
	
	! We start with activity in the caudate, which includes noise
			
			ActiveCA(t) = new_caud_act(ActiveCA(t-1),ActiveCB(t-1),vis_to_CA)
			PotCA = pot_mult*PotCA + ActiveCA(t)
					
			if (PotCA >= pot_thresh) then 
		
				counterCAtoGA = 0
				PotCA = 0
				CAtoGA = 1
		
			end if 
	
			ActiveCB(t) = new_caud_act(ActiveCB(t-1),ActiveCA(t-1),vis_to_CB)	
			PotCB = pot_mult*PotCB + ActiveCB(t)
		
			if (PotCB >= pot_thresh) then 
		
				counterCBtoGB = 0
				PotCB = 0
				CBtoGB = 1
		
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
	
			if (counterCBtoGB < square_length) then 

				counterCBtoGB = counterCBtoGB + 1
		
			else 
			
				CBtoGB = 0
			
			end if
	
			ActiveGB = new_glob_act(ActiveGB,CBtoGB)
			PotGB = pot_mult*PotGB + ActiveGB
		
			if (PotGB >= pot_thresh) then 
		
				counterGBtoTB = 0
				PotGB = 0
				GBtoTB = 1
		
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
	
			if (counterGBtoTB < square_length) then 
			
				counterGBtoTB = counterGBtoTB + 1
			
			else 
		
				GBtoTB = 0
		
			end if
	
			ActiveTB = new_thal_act(ActiveTB,GBtoTB)
			PotTB = pot_mult*PotTB + ActiveTB
		
			if (PotTB >= pot_thresh) then 
		
				counterTBtoMB = 0
				PotTB = 0
				TBtoMB = 1
		
			end if 
		
		! Finally, the activity in the thalamus causes activity in a premotor area
					
			if (counterTAtoMA < square_length) then 
			
				counterTAtoMA = counterTAtoMA + 1
			
			else 
				
				TAtoMA = 0

			end if
	
			noise = rnnof()	
			
			change_two_factorA = (vis_to_MA)*(1-ActiveMA(t-1))
			change_three_factorA = theta(7)*(TAtoMA)*(1-ActiveMA(t-1))
			change_decayA = -theta(8)*(ActiveMA(t-1)-premot_base)
			change_noiseA = noise*premot_noise_std*ActiveMA(t-1)*(1-ActiveMA(t-1))
			change_inhibitA = -theta(9)*ActiveMB(t-1)

			ActiveMA(t) = ActiveMA(t-1) + change_two_factorA + change_three_factorA + &
				change_decayA + change_noiseA + change_inhibitA
			
			intended_change = ActiveMA(t) - ActiveMA(t-1)
			ActiveMA(t) = cap(ActiveMA(t))
			actual_change = ActiveMA(t) - ActiveMA(t-1)
			
			if (actual_change == intended_change) then 
	
				rescale_const = 1
				
			else
			
				rescale_const = actual_change/intended_change
				
			end if
			
			two_factorA = two_factorA + rescale_const*change_two_factorA
			three_factorA = three_factorA + rescale_const*change_three_factorA
			decayA = decayA + rescale_const*change_decayA
			noiseA = noiseA + rescale_const*change_noiseA
			inhibitA = inhibitA + rescale_const*change_inhibitA

			pot_two_factorA = diff_pot_mult*pot_two_factorA + two_factorA
			pot_three_factorA = diff_pot_mult*pot_three_factorA + three_factorA
			pot_decayA = diff_pot_mult*pot_decayA + decayA
			pot_noiseA = diff_pot_mult*pot_noiseA + noiseA
			pot_inhibitA = diff_pot_mult*pot_inhibitA + inhibitA
			
			SumMA = SumMA + ActiveMA(t)
			
			if (counterTBtoMB < square_length) then 
			
				counterTBtoMB = counterTBtoMB + 1
			
			else 
			
				TBtoMB = 0
				
			end if
	
			noise = rnnof()	

			change_two_factorB = (vis_to_MB)*(1-ActiveMB(t-1))
			change_three_factorB = theta(7)*(TBtoMB)*(1-ActiveMB(t-1))
			change_decayB = -theta(8)*(ActiveMB(t-1)-premot_base)
			change_noiseB = noise*premot_noise_std*ActiveMB(t-1)*(1-ActiveMB(t-1))
			change_inhibitB = -theta(9)*ActiveMA(t-1)

			ActiveMB(t) = ActiveMB(t-1) + change_two_factorB + change_three_factorB + &
				change_decayB + change_noiseB + change_inhibitB
			
			intended_change = ActiveMB(t) - ActiveMB(t-1)
			ActiveMB(t) = cap(ActiveMB(t))
			actual_change = ActiveMB(t) - ActiveMB(t-1)
			
			if (actual_change == intended_change) then 
	
				rescale_const = 1
				
			else
			
				rescale_const = actual_change/intended_change
				
			end if

			two_factorB = two_factorB + rescale_const*change_two_factorB
			three_factorB = three_factorB + rescale_const*change_three_factorB
			decayB = decayB + rescale_const*change_decayB
			noiseB = noiseB + rescale_const*change_noiseB
			inhibitB = inhibitB + rescale_const*change_inhibitB

			pot_two_factorB = diff_pot_mult*pot_two_factorB + two_factorB
			pot_three_factorB = diff_pot_mult*pot_three_factorB + three_factorB
			pot_decayB = diff_pot_mult*pot_decayB + decayB
			pot_noiseB = diff_pot_mult*pot_noiseB + noiseB
			pot_inhibitB = diff_pot_mult*pot_inhibitB + inhibitB
			
			SumMB = SumMB + ActiveMB(t)
			
			diff_pot = diff_pot_mult*diff_pot + (ActiveMA(t) - ActiveMB(t))
			
	
		! Now we see if we have a response, and which response we have

			if (diff_pot > response_thresh) then 
										
				response_time = t - wait_time

				response = 1
				
				goto 500 ! Now that we have a response, we proceed to feedback processing

			else if (diff_pot < -response_thresh) then
			
				response_time = t - wait_time

				response = 2
				
				goto 500 ! Now that we have a response, we proceed to feedback processing

			end if 
	
		end do 

		! We force a response if max_response_time is reached

		if (diff_pot > 0) then 
			
				response = 1
		
		else 
			
				response = 2
								
		end if
	
		response_time = max_response_time

500 		continue

		! Now we finish the trial
		
		do t = wait_time + response_time + 1, wait_time + response_time + feedback_time
			
	! We start with activity in the caudate, which includes noise
			
			ActiveCA(t) = new_caud_act(ActiveCA(t-1),ActiveCB(t-1),vis_to_CA)
			PotCA = pot_mult*PotCA + ActiveCA(t)
					
			if (PotCA >= pot_thresh) then 
		
				counterCAtoGA = 0
				PotCA = 0
				CAtoGA = 1
		
			end if 
	
			ActiveCB(t) = new_caud_act(ActiveCB(t-1),ActiveCA(t-1),vis_to_CB)	
			PotCB = pot_mult*PotCB + ActiveCB(t)
		
			if (PotCB >= pot_thresh) then 
		
				counterCBtoGB = 0
				PotCB = 0
				CBtoGB = 1
		
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
	
			if (counterCBtoGB < square_length) then 

				counterCBtoGB = counterCBtoGB + 1
		
			else 
			
				CBtoGB = 0
			
			end if
	
			ActiveGB = new_glob_act(ActiveGB,CBtoGB)
			PotGB = pot_mult*PotGB + ActiveGB
		
			if (PotGB >= pot_thresh) then 
		
				counterGBtoTB = 0
				PotGB = 0
				GBtoTB = 1
		
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
	
			if (counterGBtoTB < square_length) then 
			
				counterGBtoTB = counterGBtoTB + 1
			
			else 
		
				GBtoTB = 0
		
			end if
	
			ActiveTB = new_thal_act(ActiveTB,GBtoTB)
			PotTB = pot_mult*PotTB + ActiveTB
		
			if (PotTB >= pot_thresh) then 
		
				counterTBtoMB = 0
				PotTB = 0
				TBtoMB = 1
		
			end if 
		
		! Finally, the activity in the thalamus causes activity in a premotor area
					
			if (counterTAtoMA < square_length) then 
			
				counterTAtoMA = counterTAtoMA + 1
			
			else 
				
				TAtoMA = 0

			end if
				
			ActiveMA(t) = new_premot_act(ActiveMA(t-1),ActiveMB(t-1),vis_to_MA,TAtoMA)
			
			SumMA = SumMA + ActiveMA(t)
			
			if (counterTBtoMB < square_length) then 
			
				counterTBtoMB = counterTBtoMB + 1
			
			else 
			
				TBtoMB = 0
				
			end if
	
			ActiveMB(t) = new_premot_act(ActiveMB(t-1),ActiveMA(t-1),vis_to_MB,TBtoMB)
			
			SumMB = SumMB + ActiveMB(t)
			

		end do ! End of trial
	
	! We'll need the dopamine levels in a moment

		dope_plus = (1-prob_correct)*(1-dope_base)
		dope_minus = (prob_correct)*dope_base
	
	! We find out if our response is correct, adjust the dopamine levels accordingly, 
	! and update the results vector
		
		do i = 2,num_past
	
			results(i-1) = results(i)
		
		end do
	
		if (response == stim_type) then
		
			dope_minus = 0
	
			results(num_past) = 1

			! We compute a decay factor that we use to ensure that the caudate
			! goes off line once prob_correct is high
	
			decay_factor = cap(1 - dope_plus/(1-dope_base))
		
		else 
		
			dope_plus = 0
		
			results(num_past) = 0
			
			decay_factor = 0
		
		end if 		


	! We determine the actual dopamine level for the trial

		dope_level = dope_base + dope_plus - dope_minus
	
	if (response == 1) then
		
		diff_pot_two_factor = pot_two_factorA - pot_two_factorB
		diff_pot_three_factor = pot_three_factorA - pot_three_factorB
		diff_pot_decay = pot_decayA - pot_decayB
		diff_pot_noise = pot_noiseA - pot_noiseB
		diff_pot_inhibit = pot_inhibitA - pot_inhibitB
	
	else 
	
		diff_pot_two_factor = pot_two_factorB - pot_two_factorA
		diff_pot_three_factor = pot_three_factorB - pot_three_factorA
		diff_pot_decay = pot_decayB - pot_decayA
		diff_pot_noise = pot_noiseB - pot_noiseA
		diff_pot_inhibit = pot_inhibitB - pot_inhibitA
		
	end if
	
	if (diff_pot_two_factor > 0) then
	
		if (diff_pot_three_factor > 0) then
		
			prop = diff_pot_three_factor/(diff_pot_two_factor+diff_pot_three_factor)
			
		else
		
			prop = 0
			
		end if
		
	else 
	
		if (diff_pot_three_factor > 0) then
		
			prop = 1
			
		else
		
			prop = 0.5
			
		end if
		
	end if	
		
	write(50,105) trial, response, diff_pot, diff_pot_two_factor, diff_pot_three_factor, &
		diff_pot_decay,	diff_pot_noise,	diff_pot_inhibit, prop
	
	! Now we compute the relevant total activations for the caudate regions

	three_factor_time = min(wait_time + response_time + feedback_time,three_factor_time_const)
	
	do i = wait_time + response_time + feedback_time - three_factor_time + 1, & 
		wait_time + response_time + feedback_time

		SumCA = SumCA + ActiveCA(i)
		SumCB = SumCB + ActiveCB(i)
		
	end do

	! We also figure out how long the stimulus was present as far as two and 
	! three factor learning are concerned
	
	two_factor_time = response_time + feedback_time

	! Next we have our learning equations

		do i = 1, grid_size
				
			do j = 1, grid_size
		
			! 3 factor learning - Caudate sum computed based on three_factor_time

			strengthCA(i,j) = cap(threefactor(strengthCA(i,j),SumCA,VisAct(i,j)*three_factor_time))
			strengthCB(i,j) = cap(threefactor(strengthCB(i,j),SumCB,VisAct(i,j)*three_factor_time))

			! 2 factor learning - Premotor sum computed based on two_factor_time
			
			strengthMA(i,j) = cap(twofactor(strengthMA(i,j),SumMA,VisAct(i,j)*two_factor_time))
			strengthMB(i,j) = cap(twofactor(strengthMB(i,j),SumMB,VisAct(i,j)*two_factor_time))
			
			end do

		end do
		
	! Finally, we update the probablity of correct reponse
	
	prob_correct = sum(results)/(num_past*1.0)

	write(30,110) trial, response, stim_type, response_time

	end do ! End of trial
	

 close(20) 
 close(30)
 close(50)

105 format(2(i10,x),7(f16.4,x))
110 format((i5,x),2(i1,x),i4)
120 format(100(f10.6,x)) ! Note, have to change if grid_size changes!

! End timing 

 call system_clock(count_1, count_rate, count_max)      

time_1 = count_1*1.0/count_rate

! Compute the elapsed time.

elapsed_time = time_1-time_0

write(*,*) 'Time taken, in seconds =', elapsed_time

 contains
 
function new_caud_act_ni(old_act,vis_input)

real :: new_caud_act_ni
real :: old_act, vis_input

noise = rnnof()	
	
new_caud_act_ni = cap(old_act + vis_input*(1-old_act) - theta(1)*(old_act - caud_base) + &
		noise*caud_noise_std*old_act*(1-old_act))

end function new_caud_act_ni

function new_premot_act_ni(old_act,vis_input,thal_input)

real :: new_premot_act_ni
real :: old_act, vis_input
integer :: thal_input

noise = rnnof()

new_premot_act_ni = cap(old_act + (vis_input+theta(7)*thal_input)*(1-old_act)-theta(8)*(old_act-premot_base) + &
			noise*premot_noise_std*old_act*(1-old_act))

end function new_premot_act_ni


function new_caud_act(old_act,old_comp_act,vis_input)

real :: new_caud_act
real :: old_act, old_comp_act, vis_input

noise = rnnof()	
	
new_caud_act = cap(old_act + vis_input*(1-old_act) - theta(1)*(old_act - caud_base) - &
		theta(2)*old_comp_act + noise*caud_noise_std*old_act*(1-old_act))

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

function new_premot_act(old_act,old_comp_act,vis_input,thal_input)

real :: new_premot_act
real :: old_act, old_comp_act, vis_input
integer :: thal_input

noise = rnnof()

new_premot_act = cap(old_act + (vis_input+theta(7)*thal_input)*(1-old_act)-theta(8)*(old_act-premot_base) - &
			theta(9)*old_comp_act + noise*premot_noise_std*old_act*(1-old_act))

end function new_premot_act

function twofactor(theta,premot_sum,vis_sum)

real :: twofactor
real :: theta, premot_sum, vis_sum

twofactor = theta + beta(1)*Pos(premot_sum-premot_thresh)*vis_sum*(1-theta) &
 - beta(2)*Pos(premot_thresh-premot_sum)*vis_sum*theta

end function twofactor

function threefactor(theta,caud_sum,vis_sum)

real :: threefactor
real :: theta, caud_sum, vis_sum

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

end program nosofsky_prog_pro_rt
