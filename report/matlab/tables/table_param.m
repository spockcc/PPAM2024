function tp=table_param(func, param)

% Returns parameters for printing tables
% 
% CALL SEQUENCE: tp=table_param(func, param)
% 
% INPUT:
%   func    a string naming the function that generated the data
%   param   a parameter that may or may not be necessary
%
% OUTPUT:
%   tp      parameters suitable for printing the table using
%             print_table
%
% MINIMAL WORKING EXAMPLE: rdif_mwe1
%
% SEE ALSO: print_table, print_rode_table

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-XX Initial programming and testing

% Dummy initialization of all parameters
tp.headers=[];
tp.wids=[];
tp.fms=[];
tp.rowheadings=[];
tp.fid=1;
tp.colsep=[];
tp.rowending=[];

switch lower(func)
    case {'bisection'}
        % Set column headers
        headers = {'iter', 'a','b','approximation','residual'};
        
        % Set column widhs
        wids=[6 22 22 22 22];
        
        % Set column formats
        fms={'d','.15e','.15e','.15e','.15e'};
        
    case {'compute_range'}
        % Define column headers
        headers = {'Elevation (deg)','Range (m)',...
            'Flight time (s)'};
        
        % Set the widths of the columns
        wids=[15 15 15];
        
        % Define the format specification
        fms={'.2f','.2f','.2f'};
        
    case {'compute_elevation'}
        % Define column headers
        headers = {'Distance (m)',...
            'Low (deg) ','Flight time (s)',...
            'High (deg)','Flight time (s)'};
        
        % Set the widths of the columns
        wids=[12 10 15 10 15];
        
        % Define the format specification
        fms={'.2f','.2f','.2f','.2f','.2f'};
        
    case {'dif0'}
        % Set column headers
        headers={'k','h','d=f(x+h)-f(x)','r=d/h'};
        
        % Set column widths
        wids=[6 20 20 20];
        
        % Set column formats
        fms={'d','.12e','.12e','.12e'};
        
    case {'harm_sum'}
        
        switch param
            case 0
                % Set column headings
                headers={'','raw data', 'successive differences'};
                
                % Set column widths
                wids=[4 53 61];
                
                % Set format specifiers
                fms={'d','d','d'};
                
            case 1
                % Set column headings
                headers={'k','ascend','descend','tree','kahan','ascend','descend','tree','kahan'};
                
                % Set column widths
                wids=[4 11 11 11 11 13 13 13 13];
                
                % Set format specifiers
                fms={'d','.7f','.7f','.7f','.7f','.10f','.10f','.10f','.10f'};
        end
        
    case {'rdif'}
        % Determine number of columns
        n=size(param,2);
        
        switch n
            case 4
                % Select headers
                headers={'k','Approximation A_h','Fraction F_h','Error estimate R_h'};
                
                % Select column wids
                wids=[6 20 12 20];
                
                % Select format specifiers
                fms={'d','.12e','.8f','.12e'};
                
            case 6
                % Set column headings
                headers={'k','A_h','F_h','R_h','E_h','(E_h-R_h)/E_h'};
                
                % Set column widths
                wids=[2 18 11 11 11 13];
                
                % Set format specifiers
                fms={'d','.12e','.8f','.4e','.4e','.4e'};
        end
        
    case {'secant'}
        % Set column headers
        headers = {'iter', 'approximation','residual'};
        
        % Set column widths
        wids=[6 22 22];
        
        % Set column formats
        fms={'d','.15e','.15e'};
        
    case {'robust_secant'}
        % Set column headers
        headers = {'iter', 'a', 'b', 'approximation','residual','status'};
        
        % Set column widths
        wids=[6 22 22 22 22 6];
        
        % Set column formats
        fms={'d','.15e','.15e','.15e','.15e','d'};
        
    case {'rode'}

       % Extract the number of fractions
       kmax=param.kmax;
       % Extract the number of columns in the table
       n=param.n;

       % ////////////////////////////////////
       % The first kmax+1 columns are fixed
       % ////////////////////////////////////
       
       % Define column headings
       headers={'time','approx.'};
       for k=kmax-3:-1:0
           % Construct string
           string=strcat('F_(',num2str(2^k,'%d'),'h)');
           headers=[headers, {string}];
       end
       headers=[headers, {'Error est.'}];
       
       % Set column widths
       wids=[6 11 8*ones(1,kmax-2) 11];
       
       % Define column formats
       fms={'.2f','.4e'};
       % Append format specifiers for Richardson's fractions
       for k=1:kmax-2
           fms=[fms, {'.6f'}];
       end
       % Append format specifier for Richardson's error estimate
       fms=[fms, {'.4e'}];

       if kmax+3==n
          
           % More column headers are needed
           headers=[headers, {'Error','Comparison'}];
           % These extra columns need widths ...
           wids=[wids 11 11];
           % ... and format specifiers
           fms=[fms,{'.4e','.4e'}];
       end   
end

tp.headers=headers;
tp.wids=wids;
tp.fms=fms;