function execute(figind,executeflag)
% run executable file

global message


set(message,'string','Please wait for model to run')

% Random Picture
cd pictures
picnum=fix(rand(1)*10);
filename=['pic' num2str(picnum) '.jpg'];
A = imread(filename,'jpeg');
figure('Position',  [408 28 560 420])
image(A)
axis off
cd ..

% Execute Fortran
cd Fortran_Program
if executeflag == 1
    !nosofsky_prog.exe

end

cd ..

 
 
% Close Program
set(message,'string','Model Done')
close(figind+1)


