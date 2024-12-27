function [tf,t,f]=perceive_raw_tf(data,fs, stimFreq, timewindow,timestep)

nfft = round(timewindow/fs*1000);
timestep = round(timestep/fs*1000);

% calculate aliasing frequency
nyquistRate = round(fs / 2);
aliasFreq = nyquistRate - (stimFreq - nyquistRate);

% add in anti-aliasing filter if freq greater than 70
if aliasFreq > 70 & aliasFreq < 120
    bsfilter = designfilt('bandstopfir', ...        % Response type
           'FilterOrder',fs * 1, ...            % Filter order
           'CutoffFrequency1',aliasFreq - 3, ...
           'CutoffFrequency2',aliasFreq + 3, ...
           'DesignMethod', 'window', ...
           'SampleRate',fs);               % Sample rate
    dataFiltered = filtfilt(bsfilter, data')';
else
    dataFiltered = data;
end

% then obtain spectrogram
[~,f,t,tf]=spectrogram(dataFiltered,hann(nfft), ...
    nfft-timestep,nfft,fs,'yaxis','power');
