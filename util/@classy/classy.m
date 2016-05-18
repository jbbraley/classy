classdef classy < matlab.mixin.SetGet
%% classy is a utility class used for automated generation and 
% documentation of classdefs
%
% author: jdv 
% create date: 04232016

    %% -- properties -- %%
    properties
        path = 'C:\Temp' % root path  
        name = 'defaultclass'
        ext = 'm'
        prop 
        desc 
    end
    
    %% -- dependent properties -- %%
    properties (Dependent)
        fullname
    end
    
    %% -- developer properties -- %%
    properties (Access = private)

    end
    
    %% -- dynamic methods -- %%
    methods
        %% -- constructor -- %%
        function obj = classy()
        end        
        
        function file = gen_doc(obj)
        % fcn 
        end
        
        function gen_depends(obj)
        % generate boiler plate syntax
        end
        
        function get_props(obj)
        % function reads <classname>.m file and grabs property variable
        % names paired with the adjacent comment discription. this is a 
        % helper file to automate documentation files. the fcn uses the 
        % classy.read() function for some automated error screening (this 
        % might be removed in the future).
        %
        % classdef classname
        % properties        <- write flag
        %   var1 % desc1    <- this works
        %   var2 %desc2     <- this also works
        %   var3%desc3      <- this also also works
        % end               <- exitflag
        %
        % output -> var  = {'var1', 'var2'} 
        %           desc = {'desc1','desc2'}
        %
        % BUG: currently captures the enterflag, need to remove
        %
            contents = obj.read(); % read file contents
            % set flags
            enterflag = 'properties'; exitflag = 'end';
            writeflag = 0; 
            cnt = 0; % match counter
            txt=[];  % matched content
            for ii = 1:length(contents) % loop for flags
                % trim leading/trailing whitespace of line ii
                cont = strtrim(contents{ii});                
                % check start flag
                if strcmp(cont,enterflag)
                    writeflag = 1; % flag for write
                end                
                % check exit flag
                if strcmp(cont,exitflag) && writeflag == 1
                    % if previously writing and exitflag caught
                    % then stop writing
                    writeflag = 0; 
                end
                % check for write flag, do not write on first flag
                if writeflag == 1
                    cnt = cnt+1;     % advance matched counter
                    txt{cnt} = cont; % save matched content
                end                  
            end                      
            % remove enter flag from matched text
            txt = txt(2:end);
            % separate variable name and descriptive comment 
            prop = regexp(txt,'\w*(?=(.)?%(.)?)','match');
            desc = regexp(txt,'(?<=%(.)?)\w+.*$','match');
            % save to object
            obj.prop = [prop{:}];
            obj.desc = [desc{:}];
        end
%         
%         function txt = parse_literals(obj,enterflag,exitflag)
%         % function accepts and enterflag and exit flag and returns all
%         % lines of text within the file inbetween
%             fid = obj.open();
%             % setup meta
%             flg = 0; cnt = 0; txt = [];
%             % loop for flags
%             while ~feof(fid) && flg == 0
%                 % read line
%                 tline = fgetl(fid);
%                 % search for literals
%                 ent = strfind(tline, enterflag);
%                 ext = strfind(tline, exitflag); 
%                 % check enter
%                 if ~isempty(ent)
%                     cnt = cnt+1;
%                 end
%                 % check exit
%                 if ~isempty(ext)
%                     flg = 1;
%                 end
%                 % check for save
%                 if cnt >= 1 && flg == 0
%                     % save line
%                     txt{cnt} = sprintf('%s',tline);
%                     % advance counter
%                     cnt = cnt+1
%                 end
%             end
%         end
        
        function contents = read(obj)              
        % read any ascii file line by line
        % each line is saved as a row in cell array
            obj.chk_name();
            fid = obj.open();
            % loop till end of file or flag
            contents = []; cnt = 1;
            while ~feof(fid)
                % read line
                contents{cnt,1} = fgetl(fid);
                cnt = cnt+1;
            end
            % close file & report status
            status = fclose(fid);
            if status == 0; fprintf('Read successful. \n');
            else fprintf('Not successful. Damn. \n');
            end
        end
        
        function create_class(obj)
        % automate standard class generation 
        %   removes some boiler plate code 
        % notes:
        %   object file name used as class name
        %   class folder created in obj.path and obj.ext ignored     
        %   appends to end of file if exists
        
            % add @class folder
            obj.path = fullfile(obj.path,['@' obj.name]); 
            mkdir(obj.path);
            fprintf('Added class folder %s\n',obj.path)
            % create class.m file in @class folder
            fid = fopen(obj.fullname,'a');
            % ---- write contents ----
            % header
            fprintf(fid,'classdef %s\n', obj.name);
            fprintf(fid,'%%%% classdef %s\n', obj.name);
            fprintf(fid,'%% author: \n');
            fprintf(fid,'%% date: %s\n\n', char(datetime));
            % properties
            fprintf(fid,'\t%%%% -- object properties --%%%%\n');
            fprintf(fid,'\tproperties\n\tend\n\n');
            fprintf(fid,'\t%%%% -- dependent properties --%%%%\n');
            fprintf(fid,'\tproperties (Dependent)\n\tend\n\n');            
            fprintf(fid,'\t%%%% -- developer properties --%%%%\n');
            fprintf(fid,'\tproperties (Access = private)\n\tend\n\n');
            % methods
            fprintf(fid,'\t%%%% -- dynamic methods--%%%%\n');
            fprintf(fid,'\tmethods\n');
            fprintf(fid,'\t\t%%%% -- constructor -- %%%%\n');
            fprintf(fid,'\t\tfunction obj = %s()\n\t\tend\n\n',obj.name);
            fprintf(fid,'\t\t%%%% -- dependent methods -- %%\n\n');
            fprintf(fid,'\tend\n\n');
            fprintf(fid,'\t%%%% -- static methods -- %%\n');
            fprintf(fid,'\tmethods (Static)\n\tend\n\n');
            fprintf(fid,'\t%%%% -- internal methods -- %%\n');
            fprintf(fid,'\tmethods (Access = private)\n\tend\n\n');
            % finish
            fprintf(fid,'end\n');
            % close file
            fclose(fid);            
        end       
        
        %% -- dependent methods -- %%
        function fullname = get.fullname(obj)
        % get full file name based on path, name, and ext.
        % error screen '.txt' 'txt' possibility
            if obj.ext(1) == '.'
                fullname = fullfile(obj.path,[obj.name obj.ext]);
            else
                fullname = fullfile(obj.path,[obj.name '.' obj.ext]);
            end
        end
    end
    
    %% -- static methods -- %%
    methods (Static)
 
    end
    
    %% -- internal methods -- %%    
    methods (Access = private)
        
        function chk_name(obj)
        % error screen null name entry
            if isempty(obj.name)
                error('Name that thang.')
            end
        end
        
        function fid = open(obj,perm)
        % open file with error screening capability. 
        % this function is meant to be a catch-all for catching errors (for
        % lack of a better word) and aid in scalability
        % 
        % perm = optional permissions, defaults to read only
        %    
            if nargin < 2 % error screen null perm entry
                perm = 'r'; % default to read only
            end
            % open file with permissions
            [fid, errmsg] = fopen(obj.fullname,perm);
            if ~isempty(errmsg)
                error(errmsg);
            end
        end
        
    end
end
