%% B(eo)W(u)LF Code: By-Word Long-Form Data Integration

% This code combines the BWLF matrix created with the previous
% MATLAB script with LIWC output to create a single file.

% Written by: Alexandra Paxton, University of California, Merced
% Date last modified: August 11, 2013

%%

% preliminaries
clear
cd('/Users/alexandra/Dropbox/paxton/pubs/bwlfTechReport');

% import LIWC data
liwcData = importdata('beowulfLIWC.txt');
disp('LIWC Data Imported.')

% create variables named for each header
headers = liwcData.textdata(1,:);
Filename = liwcData.textdata(2:end,1);
for i = 2:(length(headers))
    eval([headers{i} ' = liwcData.data(:,' int2str(i-1) ');']);
end
disp('LIWC Category Variable Headers Created.')

% import workspace
load beowulfBWLF.mat

% create output file for integrated matrx
matrixFile = ('beowulfBwlfLiwc.csv');
matOut = fopen(matrixFile,'w');

% print headers
fprintf(matOut,'%s,',header_names{:});
fprintf(matOut,'%s,',headers{1:length(headers)-1});
fprintf(matOut,'%s\n',headers{length(headers)});

% print to file
for thisLine = 1:length(beowulfMat)
    fprintf(matOut,'%s,',beowulfMat{thisLine,1:10});
    fprintf(matOut,'%s,',Filename{thisLine});
    fprintf(matOut,'%d,',liwcData.data(thisLine,1:(length(headers)-2)));
    fprintf(matOut,'%d\n',liwcData.data(thisLine,length(headers)-1));
    if mod(thisLine,500)==0;
        disp(['Line ' int2str(thisLine) ' Recorded.'])
    end
end
fclose(matOut);
save beowulfBwlfLiwc.mat
disp('Processing Complete.')