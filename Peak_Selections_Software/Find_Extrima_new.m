% Find_Extrima is a function that finds the minima and the maxima of the specific 1D data. 
%
% MAX_LOC = Find_Extrima(DATA)
% DATA is a 1D vector contaning the input signal.
% MAX_LOC is the location of the maxima along the data vector.
%
% MAX_LOC = Find_Extrima(DATA,NUM_OF_MAX)
% NUM_OF_MAX is a number specifying how many maxima are required. The default is 5.
%
% [MAX_LOC, MIN_LEFT_LOC] = Find_Extrima(DATA,NUM_OF_MAX,INDSTART)
% STARTING_DATA_POINT is the location in the data vector from which the data is considered.
% MIN_LEFT_LOC is the location of the minima along the data vector left to the maxima.
%
% [MAX_LOC, MIN_LEFT_LOC, MIN_RIGHT_LOC, AMPLITUDE] = Find_Extrima(DATA,...)
% AMPLITUDE is the minimal difference between a maximum and its adjasent minima.
% MIN_RIGHT_LOC is the location of the minima along the data vector right to the maxima.
%
% [MAX_LOC, MIN_LEFT_LOC, MIN_RIGHT_LOC, AMPLITUDE, MAX_VAL] = Find_Extrima(DATA,...)
% MAX_VAL is the data values of the output maximas.
%
% [MAX_LOC, MIN_LEFT_LOC, MIN_RIGHT_LOC, AMPLITUDE, MAX_VAL, LEFT_MIN_VAL, RIGHT_MIN_VAL] = Find_Extrima(DATA,...)
% LEFT_MIN_VAL is the data values of the output minimas left to the maxima.
% RIGHT_MIN_VAL is the data values of the output minimas right to the maxima.
%----------------------------------------------------------------------------------------------------------
% Created by Gabriel Biener, PhD        Date Created:  August 20,2013
%                                       Date Modified: February 3, 2016
% email: gabbiener@gmail.com
%----------------------------------------------------------------------------------------------------------

function [varargout] = Find_Extrima_new(Data, nMaxima, indStart)

% Choice for input variables
if nargin < 2, nMaxima  = 5; end
if nargin < 3, indStart = 1; end

Data = Data(indStart:end);
if size(Data,1) == 1, Data = padarray(Data,[0,1], 0, 'both'); else, Data = padarray(Data,[1,0], 0, 'both'); end
% Aligning the Data vector to the longer dimension
% and generating a 3 by length(Data) matrix containg the data information
% at each row with different shift. Row 1 is left shifted, row 2 is the
% original data and row 3 is right shifted.
[~, Large_Dim]    = max(size(Data));
if Large_Dim == 1
    Broadend_Data_MAT = [circshift(Data',[0 1]); Data'; circshift(Data',[0 -1])];
    Data = Data';
elseif Large_Dim == 2
    Broadend_Data_MAT = [circshift(Data,[0 1]); Data; circshift(Data,[0 -1])];
end

% Generation of the smeared maxima data vector. The smeared maxima vector
% is substructed from the original data and the maxima locations would
% appear where the difference is zero.
Broadend_Data          = max(Broadend_Data_MAT,[],1);                       % Smeared maxima vector
Diff                   = Broadend_Data - Data;                              % Substraction of smeared vector and original data
Maxima_Full            = find(Diff==0);                                     % a vector contaning the maxima locations.

% same smearing procedures only for minima.
Broadend_Data          = min(Broadend_Data_MAT,[],1);                       % Smeared minima vector
Diff                   = Broadend_Data - Data;                              % Substraction of smeared vector and original data
Minima_Full            = find(Diff==0);                                     % a vector contaning the minima locations.

% removing all the locations that appear in maxima vector and minima vector (Plateaus without the edges).
Temp    = Minima_Full;
Minima_Full(ismember(Temp,Maxima_Full)) = [];
Maxima_Full(ismember(Maxima_Full,Temp)) = [];
Minima_Full_Old = Minima_Full;

% finding plateau edges
Plato_Left  = find((Data(2:end-1)-Data(1:end-2)) ~= 0 & (Data(2:end-1)-Data(3:end)) == 0)+1;     % left edge of a plato
Plato_Right = find((Data(2:end-1)-Data(1:end-2)) == 0 & (Data(2:end-1)-Data(3:end)) ~= 0)+1;     % right edge of a plato

if ~isempty(Plato_Left) && ~isempty(Plato_Right)
    
    % Adding edges of Data to the plateaus
    if Plato_Left(1) > Plato_Right(1)
        Plato_Left  = padarray(Plato_Left, [0 1], 1, 'pre');
    end
    if Plato_Left(end) > Plato_Right(end)
        Plato_Right(end+1) = length(Data);
    end
    
    % Distinguishing between platos that are maxima (Convex), platos that
    % are minima(Concave) and the rest are platos with one end towards down and the other
    % towards up (Suddle_Plateau)
    Min_Plato = (Data(Plato_Left)-Data(max([Plato_Left-1;ones(size(Plato_Left))])))<0 & (Data(Plato_Right)-Data(min([Plato_Right+1;length(Data)*ones(size(Plato_Right))])))<0;
    Max_Plato = (Data(Plato_Left)-Data(max([Plato_Left-1;ones(size(Plato_Left))])))>0 & (Data(Plato_Right)-Data(min([Plato_Right+1;length(Data)*ones(size(Plato_Right))])))>0;
    
    % in case of a minima or maxima plateau the program considers minima or
    % maxima in the midle of the plateau
    Minima_Full(ismember(Minima_Full,Plato_Right(find(Min_Plato)))) = round((Plato_Left(find(Min_Plato))+Plato_Right(find(Min_Plato)))/2);
    Maxima_Full(ismember(Maxima_Full,Plato_Right(find(Max_Plato)))) = round((Plato_Left(find(Max_Plato))+Plato_Right(find(Max_Plato)))/2);
    
    % removing points that are existing both in the minima and maxima list
    % as well as in the plateaus list
    Minima_Full(ismember(Minima_Full,Plato_Left))              = [];
    Minima_Full(ismember(Minima_Full,Plato_Right(~Min_Plato))) = [];
    Maxima_Full(ismember(Maxima_Full,Plato_Left))              = [];
    Maxima_Full(ismember(Maxima_Full,Plato_Right(~Max_Plato))) = [];
end

% Checking wheather the minma and maxima vectors have more than 2
% components for ferther validation
if length(Minima_Full) >= 2
    % Making sure that the two vectors (Minima and Maxima) are aligned so
    % we wont have any missing minima or maxima
    if Minima_Full(2) < Maxima_Full(1)
        Minima_Full(1) = [];
    elseif Minima_Full(end-1) > Maxima_Full(end)
        Minima_Full(end) = [];
    end
end

if length(Maxima_Full) >= 2
    if Maxima_Full(2) < Minima_Full(1)
        Maxima_Full(1) = [];
    elseif Maxima_Full(end-1) > Minima_Full(end)
        Maxima_Full(end) = [];
    end
end
    
% Making sure that the minima and maxima vectors are the same size
if numel(Minima_Full) == 0 && numel(Maxima_Full) > 0
    Minima_Full(1) = round((Maxima_Full(end) + 1)/2);
end

% validating the number of maxima required, whether there is enough
% maxima or minima. in the case that there is not enought the program
% will return the maximum number of maxima or minima existing.
nMaxima = min([length(Maxima_Full) nMaxima]);

% This part is where the program is performing the sorting or choosing
% of maxima and minima from the full list of maxima and minima based on
% the criteria asked by the user in the input (The fourth input parameter).
if numel(Maxima_Full) > 0
    if Maxima_Full(1) < Minima_Full(1)
        Minima_Full  = [Minima_Full_Old(1) Minima_Full];
        if length(Maxima_Full) == length(Minima_Full)
            Minima_Full  = [Minima_Full Minima_Full_Old(end)];
        end
    else
        if length(Maxima_Full) == length(Minima_Full)
            Minima_Full  = [Minima_Full Minima_Full_Old(end)];
        end
    end
    Amp_Left     = Data(Maxima_Full)-Data(Minima_Full(1:end-1));
    Amp_Right    = Data(Maxima_Full)-Data(Minima_Full(2:end));
    Amplitude    = min([Amp_Left',Amp_Right'],[],2);
    [Sorted_Amp, Sorted_Amp_Ind] = sort(Amplitude',2,'descend');
    Maxima       = Maxima_Full(Sorted_Amp_Ind(1:nMaxima))+indStart-1;
    Minima_Left  = Minima_Full(Sorted_Amp_Ind(1:nMaxima))+indStart-1;
    Minima_Right = Minima_Full(Sorted_Amp_Ind(1:nMaxima)+1)+indStart-1;
else
    Maxima       = zeros(1,0);
    Minima_Left  = zeros(1,0);
    Minima_Right = zeros(1,0);
    Sorted_Amp   = zeros(1,0);
end

% this part of the program assigns the output parameters based on the user
% chose.
if nargout > 0, varargout{1} = Maxima - 1;            end
if nargout > 1, varargout{2} = max(Minima_Left - 1, ones(size(Minima_Left))); end
if nargout > 2, varargout{3} = min(Minima_Right - 1,(numel(Data)-2)*ones(size(Minima_Right))); end
if nargout > 3, varargout{4} = Sorted_Amp(1:nMaxima); end
if nargout > 4, if ~isempty(Maxima), varargout{5} = Data(Maxima-indStart+1); else varargout{5} = zeros(1,0); end;             end
if nargout > 5, if ~isempty(Minima_Left), varargout{6} = Data(Minima_Left-indStart+1); else varargout{6} = zeros(1,0); end;   end
if nargout > 6, if ~isempty(Minima_Right), varargout{7} = Data(Minima_Right-indStart+1); else varargout{7} = zeros(1,0); end; end