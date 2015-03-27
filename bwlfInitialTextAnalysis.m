%% B(eo)W(u)LF Code: By-Word Long-Form Initial Text Analysis

% This code reads in the cleaned file produced by the Python script,
% computes a series of automatic variables from the texts, then outputs
% two files: a matrix with the automatic variables and a text file
% suitable for other linguistic analyses (e.g., LIWC).

% Written by: Alexandra Paxton, University of California, Merced
% Date last modified: June 17, 2013

%%


% preliminaries
clear
cd('/users/alexandra/dropbox/paxton/pubs/bwlfTechReport');

% read in cleaned text file
bText = fopen('beowulfCleaned.csv');
bRead = textscan(bText,'%s','EndOfLine','\n','delimiter',',');
bRead = bRead{1,1};
disp('Cleaned Text File Loaded.')

% separate and renumber cantos
canto = regexp(bRead,'\[canto\]');
cantoCount = 0;
trashLines = [];
for cantos = 1:length(bRead)
    if cellfun(@isempty,canto(cantos))==0
        cantoCount = cantoCount + 1;
        trashLines = [trashLines cantos];
    else
        cantoTrack(cantos,1) = cantoCount;
    end
end
disp('Cantos Numbered.')

% separate and renumber lines
pLine = regexp(bRead,'\[line\]');
pLineCount = 0;
for pLines = 1:length(bRead)
    if cellfun(@isempty,pLine(pLines))==0
        pLineCount = pLineCount + 1;
        trashLines = [trashLines pLines];
    else
        pLineTrack(pLines,1) = pLineCount;
    end
end
disp('Poem Lines Numbered.')

% remove indicator lines from text and indicator matrices
bRead(trashLines) = [];
cantoTrack(trashLines) = [];
pLineTrack(trashLines) = [];

% find end-of-sentence lines
ends = regexp(bRead,'.*[\.|\?|!]');
endsNone = cellfun(@isempty,ends);
disp('Sentences Isolated.')

% track speech lines
speech = regexp(bRead,'.*\"');
speechTrack = [];
tempStore = [];
speechEvent = 1;
for speaking = 1:length(bRead)
    if cellfun(@isempty,speech(speaking))==0
        tempStore = [tempStore speaking];
        if length(tempStore)==2
            speechTrack(speechEvent,1:2) = tempStore;
            tempStore = [];
            speechEvent = speechEvent + 1;
        end
    end
end
sTrack = 1;
for speechMark = 1:length(bRead)
    if speechTrack(sTrack,1) <= speechMark && speechMark <= speechTrack(sTrack,2)
        speech{speechMark} = 1;
        if speechMark == speechTrack(sTrack,2)
            sTrack = sTrack + 1;
        end
    end
end
speechNone = cellfun(@isempty,speech);
disp('Speech Isolated.')

% create initial by-word long-form matrix
for i = 1:length(bRead)
    % track sentence ends
    if endsNone(i) == 0
        eos = 1; % indicates end of sentence
        charNum = length(char(bRead{i}))-1; % tracks current word length, minus the punctuation
    else
        eos = 0; % indicates not end of sentence
        charNum = length(char(bRead{i})); % tracks current word length, minus the punctuation
    end
    
    % track speech events
    if speechNone(i) == 0
        sp = 1; % indicates speech event
        if regexp(bRead{i},'.*\"')==1
            charNum = charNum - 1; % subtrack quotation mark from character count
        end
    else
        sp = 0; % indicates no speech event
    end
    
    % store everything in matrix
    beowulfMat(i,:) = {int2str(cantoTrack(i)),int2str(pLineTrack(i)),bRead{i},int2str(charNum),int2str(sp),int2str(eos)};
    if mod(i,500)==0;
        disp(['Line ' int2str(i) ' of ' int2str(length(bRead)) ' Recorded.'])
    end
end

% save workspace
save beowulfBWLF.mat
disp('MATLAB Workspace Saved.')

% print transcript for LIWC
textFileName = ('bwlfTextAnalysisPrep.txt');
textLine = beowulfMat(:,3);
textFile = fopen(textFileName,'w');
for word = 1:length(textLine)
    fprintf(textFile,'%s\n',textLine{word});
end

% print matrix
matrixFile = ('beowulfBWLFMatrix.csv');
matOut = fopen(matrixFile,'w');
header_names = {'canto';'line';'word';'charnum';'speech';'eos'};
fprintf(matOut,'%s,%s,%s,%s,%s,%s\n',header_names{:});
for beoLine = 1:size(beowulfMat,1)
    fprintf(matOut,'%s,%s,%s,%s,%s,%s\n',beowulfMat{beoLine,:});
end
disp('Matrix Output Complete.')
save beowulfBWLF.mat

% close file
fclose(matOut);
disp('Processing Complete.')