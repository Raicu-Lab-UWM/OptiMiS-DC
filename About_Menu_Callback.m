function About_Menu_Callback (varargin)
f = figure('Name','About','menu','none','toolbar','none');
fid = fopen('./config/Readme_software_info.txt');
ph = uipanel(f,'Units','normalized','position',[0.050 0.050 0.9 0.9],'title',...
    'Read info');
lbh = uicontrol(ph,'style','listbox','Units','normalized','position',...
    [0 0 1 1],'FontSize',10);
indic = 1;
while 1
     tline = fgetl(fid);
     if ~ischar(tline); 
         break
     end
     strings{indic}=tline; 
     indic = indic + 1;
end
fclose(fid);
set(lbh,'string',strings);
set(lbh,'Value',1);
set(lbh,'Selected','on');

end