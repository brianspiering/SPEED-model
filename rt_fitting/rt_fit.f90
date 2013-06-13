! This program reads in a response time file and fits both power 
! and exponential curves.  

program rtfit

integer :: n
integer :: minrt, maxrt
integer :: hozasympt

real :: expbeta(2), powbeta(2)
real :: BestExpBeta(2), BestPowBeta(2)

real :: RSqExp, RSqPow
real :: BestRSqExp, BestRSqPow
real :: bestpredictexp, bestpredictpow

integer :: BestExpHoz, BestPowHoz

BestRSqExp = 0
BestRSqPow = 0 

open(20, file = 'input\rtparams.dat')

read(20,*) n, minrt, maxrt

close(20)

open(25, file = 'output\fixing.out')

do hozasympt = minrt, maxrt

	call fitting(n,hozasympt,RSqExp,RSqPow,expbeta,powbeta)

	if (RSqExp > BestRSqExp) then
	
		BestRSqExp = RSqExp
		Bestexpbeta = expbeta
		Bestexphoz = hozasympt
		
	end if 
	
	if (RSqPow > BestRSqPow) then
	
		BestRSqPow = RSqPow
		Bestpowbeta = powbeta
		Bestpowhoz = hozasympt	
		
	end if 

end do

close(25)

open(50, file = 'output\predictedvalues.dat')

do i = 1,n

bestpredictexp = bestexphoz + bestexpbeta(1)*exp(bestexpbeta(2)*i)
bestpredictpow = bestpowhoz + bestpowbeta(1)*i**(bestpowbeta(2))

write(50,150) i, bestpredictexp, bestpredictpow

end do 

close(50)

open(30, file ='output\explained.dat')
open(40, file ='output\justparams.dat')

write(30,120) 'Variance explained by exp:', BestRSqExp
write(30,120) 'Variance explained by pow:', BestRSqPow
write(30,130) 'Parameters for exp fit:', bestexphoz, bestexpbeta
write(30,130) 'Parameters for pow fit:', bestpowhoz, bestpowbeta

write(40,110) bestexphoz, bestexpbeta
write(40,110) bestpowhoz, bestpowbeta

close(30)
close(40)

100 format(f12.4)
110 format(i8,x,3(f12.4,x))
120 format(a26,x,f12.4)
130 format(a26,x,i8,x,3(f12.4,x))
150 format(i8,x,2(f12.6,x))

!open(30, file ='output\explained.dat')
!open(40, file ='output\justparams.dat')
!
!write(30,*) 'Variance explained by exp:'
!write(30,*) 'Variance explained by pow:'
!write(30,*) 'Parameters for exp fit:'
!write(30,*) 'Parameters for pow fit:'
!
!write(30,100) BestRSqExp
!write(30,100) BestRSqPow
!write(30,110) bestexphoz, bestexpbeta
!write(30,110) bestpowhoz, bestpowbeta
!
!write(40,110) bestexphoz, bestexpbeta
!write(40,110) bestpowhoz, bestpowbeta
!
!close(30)
!close(40)
!
!100 format(f12.4)
!110 format(i8,x,2(f14.6,x))
!150 format(i8,x,2(f12.6,x))

	
contains

! This subroutine fits the response time data

subroutine fitting(n,hozasympt,RSqExp,RSqPow,expbeta,powbeta)

integer :: n
integer :: hozasympt

real :: y(n), x(n), lnx(n), lny(n)
real :: predictexp(n), predictpow(n)
real :: sumx, sumy, sumlnx, sumlny, sumxlny, sumlnxlny, sumxsq, sumlnxsq
real :: expbeta(2), powbeta(2)


real :: junk1, junk2, junk3

real :: ymean, SSMean, SSExp, SSPow, RSqExp, RSqPow

sumx = 0 
sumy = 0
sumlny = 0
sumlnx = 0
sumxlny = 0
sumlnxlny = 0
sumxsq = 0
sumlnxsq = 0

! We read in the response time data 

open(10, file = 'input\response.dat')

do i = 1, n

	read(10,*) junk1, junk2, junk3, y(i)

	x(i) = i

	! We rescale since the pure exponential and power laws asymptote to zero,
	! and transform to log-log coordinates

	lny(i) = log(y(i) - hozasympt)
	lnx(i) = log(x(i))

! We are now ready to estimate the parameters in the regression 
! equations:
!
! ln y = ln expbeta(1) + expbeta(2) * x and 
! ln y = ln powbeta(1) + powbeta(2) * ln x
!
! corresponding to the models
!
! y = expbeta(1) * exp(expbeta(2) * x)
! y = powbeta(1) * x^(powbeta(2))
!

! We need the following sums

	sumx = sumx + x(i)
	sumy = sumy + y(i)
	sumlny = sumlny + lny(i)
	sumlnx = sumlnx + lnx(i)
	sumxlny = sumxlny + x(i)*lny(i)
	sumlnxlny= sumlnxlny + lnx(i)*lny(i)
	sumxsq = sumxsq + x(i)*x(i)
	sumlnxsq = sumlnxsq + lnx(i)*lnx(i)
	
end do 

close(10)

! We estimate expbeta and powbeta according to the method of
! least squares

expbeta(2) = (n*sumxlny - sumx*sumlny)/(n*sumxsq - sumx*sumx)
expbeta(1) = (sumlny - expbeta(2)*sumx)/n

powbeta(2) = (n*sumlnxlny - sumlnx*sumlny)/(n*sumlnxsq - sumlnx*sumlnx)
powbeta(1) = (sumlny - powbeta(2)*sumlnx)/n

! Finally we estimate the R^2 values for the fits
! This will be the R^2 values in the real data

ymean = sumy/n

SSMean = 0
SSExp = 0
SSPow = 0

expbeta(1) = exp(expbeta(1))
powbeta(1) = exp(powbeta(1))

predictexp = hozasympt + expbeta(1)*exp(expbeta(2)*x)
predictpow = hozasympt + powbeta(1)*x**(powbeta(2))

! Note these are the R^2 values from the actual data

do i = 1, n

	SSMean = SSMean + (y(i) - ymean)*(y(i) - ymean)
	SSExp = SSExp + (y(i) - predictexp(i))*(y(i) - predictexp(i))
	SSPow = SSPow + (y(i) - predictpow(i))*(y(i) - predictpow(i))

end do

write(25,*) hozasympt, SSMean, SSExp, SSPow

RSqExp = (SSMean - SSExp)/SSMean
RSqPow = (SSMean - SSPow)/SSMean

end subroutine fitting

end program rtfit
