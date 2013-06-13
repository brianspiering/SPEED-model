program read_write_file

implicit none

integer :: i

character(len = 50), dimension(40) :: label_name

open(10, file = 'choi_params_names.dat')
open(20, file = 'labels.dat')

do i = 1,33 

	read(10,*) label_name(i)
	write(20,100) label_name(i)
	
end do 

close(10)
close(20)

100 format(a50)

end program
