% Script to produce rt distribution figures and graphs, starting from
% scratch

% clear all
% 
num_sims = 3000;
rel_trials = 1:1800; % Should be a multiple of 100!

% 
% cd ..
% 
% rt_find
% 
% cd Fortran_Program
% 
% rt_extract
% 
% extract_correct

load_rt_data
 
% compute_means
% 
% plot_rt_accuracy
% 
% plot_rt_density
% 
% cd ..
% 
% gen_paper_plot
% 
% cd Fortran_Program