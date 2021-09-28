function saveastiff_wLabels(data, path, options, Title_List)
%   : true or FALSE
%   : If this is true, third dimension should be 3 and the data is saved as a color image.
%
% options.message
%   : true or FALSE.
%     If this is false, all messages are skipped. 
%
% Defalut value of 'options' is
%     options.message = false;
% 
% Examples :
% 
% [X,Y,Z] = peaks(100);
% X = single(X);
% Y = single(Y);
% Z = single(Z);
% Z_index = uint8((Z - min(Z(:))) * (255 / (max(Z(:)) - min(Z(:)))));
% Z_color = uint8(ind2rgb(Z_index, hsv(256)*256));
% Z_color_multiframe = reshape([Z_color(:)*0.2 Z_color(:)*0.6 Z_color(:)], 100, 100, 3, 3);
% Z_color_noisy = uint8(single(Z_color) + rand(100, 100, 3).*50);
%
% % 8-bit, grayscale image
% saveastiff(uint8(Z_index), 'Z_uint8.tif');
% 
% % Allow message printing.
% options.message = true;
% saveastiff(uint8(Z_index), 'Z_uint8_LZW.tif', options);
% options.message = false;
% 
% % 16-bit, grayscale image
% saveastiff(uint16(Z_index), 'Z_uint16.tif');
% 
% % 32-bit single, grayscale image
% saveastiff(Z, 'Z_single.tif');
% 
% % Save each R, G and B chanels of the color image, separately.
% saveastiff(Z_color, 'Z_rgb_channel.tif');
% 
% % 32-bit single, 50x50x50 volume data
% saveastiff(single(rand(50, 50, 50)), 'volume_50x50x50.tif');
% 
% Copyright (c) 2012, YoonOh Tak
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the Gwangju Institute of Science and Technology (GIST), Republic of Korea nor the names 
%       of its contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

if nargin < 4, Title_List = []; end
if isempty(Title_List)
    max_nDigits = numel(num2str(size(data,3)));
    Title_Array(:,1:max_nDigits) = num2str([1:size(data,3)]');
    Title_List  = mat2cell(Title_Array, ones(size(data,3),1), max_nDigits);
end
[Label_List_Indices, Label_List] = Title2Label(Title_List);
errcode = -1;
try
if isreal(data) == false, errcode = 8; assert(0); end
if nargin < 3, options.message = false; end
if isfield(options, 'message') == 0, options.message = false; end
if ndims(data) > 3, errcode = 10; assert(0); end
if isempty(data), errcode = 2; assert(0); end
[height, width, depth] = size(data);

tagstruct.Photometric         = Tiff.Photometric.MinIsBlack;
tagstruct.ImageLength         = height;
tagstruct.ImageWidth          = width;
tagstruct.SamplesPerPixel     = 1;
tagstruct.RowsPerStrip        = height;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Compression         = Tiff.Compression.None;

switch class(data)
    case {'uint8', 'uint16', 'uint32'}, tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
    case {'int8', 'int16', 'int32'},    tagstruct.SampleFormat = Tiff.SampleFormat.Int;
    case {'single', 'double'},          tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
    otherwise,                          errcode = 9; assert(0);
end

switch class(data)
    case {'uint8', 'int8'},   tagstruct.BitsPerSample = 8;
    case {'uint16', 'int16'}, tagstruct.BitsPerSample = 16;
    case {'uint32', 'int32'}, tagstruct.BitsPerSample = 32;
    case {'single'},          tagstruct.BitsPerSample = 32;
    case {'double'},          tagstruct.BitsPerSample = 64;
    otherwise,                errcode = 9; assert(0);
end
tagstruct_wLabels             = tagstruct;
% tagstruct_wLabels.PageName    = [Label_List_Indices 'IJIJlabl' char(0) char(0) char(0) char(0) Label_List];
% tagstruct_wLabels.ImageDescription = ['ImageJ=1.49e' char(10)...
%                                 'images=' num2str(max([length(Title_List), 1])) char(10)...
%                                 'slices=' num2str(max([length(Title_List), 1])) char(10)...
%                                 'loop=false' char(10)...
%                                 'min=' num2str(min(data(:))) char(10) ...
%                                 'max=' num2str(max(data(:))) char(10)];

tStart   = tic;
tempfile = 'temporal.tif';
t        = Tiff(tempfile, 'w');
t.setTag(tagstruct_wLabels);
fileattrib(tempfile, '+h +w', '', 's');
t.setTag(tagstruct_wLabels);
t.write(data(:, :, 1));
New_Tag = struct('Offset', 249, 'Value', [12 4 4]);
New_Tag(2).Offset = 261;
New_Tag(2).Value = ' A A A A B B B B';
t.setTag(50838, New_Tag);
for d = 2:depth
    t.writeDirectory();
    t.setTag(tagstruct);
    t.write(data(:, :, d));
end
t.close();
if ispc, fileattrib(tempfile, '-h +w'); end
movefile(tempfile, path, 'f');

tElapsed = toc(tStart);
if options.message, display(sprintf('File saved successfully. Elapsed time : %.3f s.', tElapsed)); end

catch exception
    if exist('t', 'var')
        t.close();
        delete(tempfile);
    end
    
    if options.message
        switch errcode
            case {0, 1}, error 'Invalide path.';
            case 2, error '''data'' is empty.';
            case 3, error 'Data dimension is too large.';
            case 4, error 'Third dimesion (color depth) should be 3.';
            case 6, error 'RGB color image can not have int8, int16 or int32 format.';
            case 8, error 'It does not support complex numbers.';
            case 9, error 'Unsupported data type.';
            case 10, error 'Dimension of source data is too large.'
            otherwise, rethrow(exception);
        end
    end
end

function [Label_List_Indices, Label_List] = Title2Label(Title_List)
if nargin < 1, Title_List = []; end
if ~isempty(Title_List)
    Label_List_OneCol = [];
    Label_List_Index_32bit= zeros(length(Title_List), 1, 'uint32');
    for ii = 1:length(Title_List)
        currLabel(1,:)             = Title_List{ii};
        Label_List_OneCol          = [Label_List_OneCol, currLabel];
        Label_List_Index_32bit(ii) = length(currLabel)*2;
    end
    
    Label_List         = zeros(2, length(Label_List_OneCol));
    Label_List(2,:)    = uint8(Label_List_OneCol);
    Label_List         = reshape(Label_List, 1, 2*length(Label_List_OneCol));
    Label_List_Indices = typecast(Label_List_Index_32bit, 'uint8');
    Label_List_Indices = reshape(Label_List_Indices, 4, length(Label_List_Indices)/4);
    Label_List_Indices = flipud(Label_List_Indices);
    Label_List_Indices = reshape(Label_List_Indices, 1, size(Label_List_Indices,1)*size(Label_List_Indices,2));
    Label_List_Indices = char([0, 0, 0, 12, Label_List_Indices]);
end