function [BFI, yearList]=BaseFlowIndex(year,month,day,flow,method)
%% Setting default value for method
if (nargin<5 || isempty(method))
  method='combined';
end

%% Checking inputs
validateattributes(year,{'numeric'},{'vector'});
nElem=numel(year);
if (nElem<=5)
  error('not enough data');
end
validateattributes(month,{'numeric'},{'size',size(year)});
validateattributes(day,{'numeric'},{'size',size(year)});
validateattributes(flow,{'numeric'},{'size',size(year)});
validateattributes(method,{'char'},{'row'});
if (~any(strcmpi({'combined';'separated'},method)))
  error('Method must be set to either "combined" or "separated".');
end

%% Sorting data if needed
dateNumber=datenum(year,month,day);
% dDateNumber=diff(dateNumber);
% if (any(dDateNumber<0))
%   [dateNumber, idx]=sort(dateNumber);
%   dDateNumber=diff(dateNumber);
%   
%   year=year(idx);
%   flow=flow(idx);
% end
% if (any(dDateNumber==0))
%   error('date seems to have duplicate numbers');
% end
% clear dDateNumber;

%%
yearList=unique(year);
nYears=numel(yearList);
BFI=zeros(nYears,1);

switch method
  case 'combined'

    
    n5DayBlock=floor(nElem/5);
    idx=1:5*n5DayBlock;
    [minFlowPer5DayBlock, minIDX]=min(reshape(flow(idx),5,[]));
    mask= [false, ...
           ((0.9*minFlowPer5DayBlock(2:end-1))<minFlowPer5DayBlock(1:end-2)) & ((0.9*minFlowPer5DayBlock(2:end-1))<minFlowPer5DayBlock(3:end)), ...
           false];
    selectedIDX=sub2ind([5,n5DayBlock],minIDX(mask),find(mask));
    
    selectedMins=minFlowPer5DayBlock(mask);
    yearForSelectedMins=year(selectedIDX);
    monthForSelectedMins=month(selectedIDX);
    dayForSelectedMins=day(selectedIDX);
    dateNumberforSelectedMins=datenum(yearForSelectedMins,monthForSelectedMins,dayForSelectedMins);

    for yearID=1:nYears
      mask= (yearForSelectedMins==yearList(yearID));
      firstID=find(mask,1,'first');
      lastID=find(mask,1,'last');
      if ( (firstID~=1) && ...
           (dayForSelectedMins(firstID)~=1) && ...
           (monthForSelectedMins(firstID)==1) )
        firstID=firstID-1;
      end
      if ( (lastID~=numel(selectedMins)) && ...
           (dayForSelectedMins(lastID)~=31) && ...
           (monthForSelectedMins(lastID)==12) )
        lastID=lastID+1;
      end
      
      IDX=firstID:lastID;
      QB=selectedMins(IDX);
      timeSpan=diff(dateNumberforSelectedMins(IDX));
      avgDischarge=0.5*(QB(1:end-1)+QB(2:end));
    
      VB=sum(timeSpan(:).*avgDischarge(:));
      
      mask= (dateNumber>=dateNumberforSelectedMins(firstID)) & ...
            (dateNumber<=dateNumberforSelectedMins(lastID));
      VA=sum(flow(mask));
      
      BFI(yearID)=VB/VA;
    end
  case 'separated'
    error('This method is not yet implemented');
  otherwise
    % This should never be executed.
    error('Method must be set to either "combined" or "separated".');
end

end

































