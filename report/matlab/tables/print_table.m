function print_table(data, param)

% A wrapper for displaytable by Richard Crozier (2012)
% 
% CALL SEQUENCE: print_table(data,param)
%
% INPUT:
%   data    a table generated by one of several programs
%   param   parameters generated by a call to table_param
%
% Several program uses as bisection, secant, richardson, etc., 
% generate numerical tables that can be printed nicely using this
% function. Appropriate parameters for formating the tables can
% be obtained by calling table_param.
%
% MINIMAL WORKING EXAMPLE: rdif_mwe1
%
% SEE ALSO: table_param, displaytable

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen
%   2024-03-06  Initial programming and testing

% Print the table using the formating given by param
displaytable(data,param.headers,param.wids,param.fms,...
    param.rowheadings,param.fid,param.colsep,param.rowending);