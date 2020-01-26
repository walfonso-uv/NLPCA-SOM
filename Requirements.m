%% Requirements %%
% Requirements.m checks if you have the toolbox to use this code. The
% scripts and functions work is you are using MatLab version 2015b or
% higher.
flag = license('test','neural_network_toolbox');
aux = version('-release');

if flag && str2double(aux(1:end-1))>=2015 && double(aux(end))>=double('a')
    msgbox('Congratulations!!! You can run these files',...
        'Welcome Box');
else
    warndlg('Maybe you need to update your MatLab version',...
        'Warning');
    flag = 0;
end
