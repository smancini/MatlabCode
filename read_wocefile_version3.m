%This program read a text file representing CO2 data collected on a
%specific cruise by the Southern Surveyor and create a NetCDF file.
%
%the User need to change this program for each different text file.
%the different line where changes from one file to an other are the
%following:
%1 - Change the name of the text file in the fopen function
%2 - Change the name of the netcdf file to create
%3 - Change the global attributes "Title"
%4 - Change the global attributes "abstract"
%5 - Change the global attributes "cruise_id"
%6 - change the global attributes "citation"
%
%%
%Open the text file including all the cruise for one year
fid_1 = fopen('liste_cruises_2008.txt','r');
%read the first line of the text file
line1=fgetl(fid_1);
liste{1} = line1 ;
%creation of the variable i
xx=2;
%%
%Read all the data in the text file
while line1~=-1,
  line1=fgetl(fid_1);
  liste{xx} = line1 ;
  xx=xx+1;
end
%File dimension of the list file
dimlist = length(liste);
%
%
for yy = 1:dimlist-1
%    for yy = 1:1
%
%
%Open the text file including all the data for one cruise
fid = fopen(liste{yy}(10:end),'r');
%read the first three lines of the text file
line=fgetl(fid);
line=fgetl(fid);
line=fgetl(fid);
data{1} = line ;
%creation of the variable i
i=2;
%%
%Read all the data in the text file
while line~=-1,
%while i~=1000,
  line=fgetl(fid);
  data{i} = line ;
  i=i+1;
end
%File dimension
dimfile = length(data);
%%
%The following loop read all the variable included in the text file and
%stored the data in a matrix
for i = 1:(dimfile-1)
%for i=1:100
%The data of the corresponding line is stored in the variable temp
    temp = data{i};
%We are looking for the character space in the variable temp
    toto = find(isspace(temp));
%There is a problem in the variable toto because sometimes between two
%variables there are several spaces.
%The following variable "space" will enable us to know exactly the position
%of the character space and also the number of character space between two
%variables.
%the first column represents the indice of the first space character.
%the second column represents the number of space character between two
%variables.
    compt=0;
    space=0;
    space(1,1) = toto(1);
    k=2;
    for j=2:length(toto)
        
        if (toto(j) > toto(j-1)+1)
           space(k,1)   = toto(j);
           space(k-1,2) = compt+1;
           compt =0;
           k=k+1;
        else
            compt=compt+1;
        end
    end
    space(k-1,2)=compt+1;
%a third column is calculated   
    space(:,3) = space(:,1) + space(:,2);
%Dimension of the string       
    dimstr = length(temp);
%
%25 variables are included in the text file
%
%Variable 1: Group/ship
ship(i,:)   = temp(space(1,3):space(2,1)-1);
%Variable 2 : CruiseID
cruise(i,:)   = temp(space(2,3):space(3,1)-1);
%Variable 3 : JD_GMT
JD_GMT(i,:)   = str2num(temp(space(3,3):space(4,1)-1));
%Variable 4 : date
date(i,1)   = str2num(temp(space(4,3):space(4,3)+3));
date(i,2)   = str2num(temp(space(4,3)+4:space(4,3)+5));
date(i,3)   = str2num(temp(space(4,3)+6:space(5,1)-1));
date(i,4)   = str2num(temp(space(5,3):space(5,3)+1));
date(i,5)   = str2num(temp(space(5,3)+3:space(5,3)+4));
date(i,6)   = str2num(temp(space(5,3)+6:space(6,1)-1));
%Variable 6 : latitude
latitude(i,1)   = str2num(temp(space(6,3):space(7,1)-1));
%Variable 7 : longitude
longitude(i,1)   = str2num(temp(space(7,3):space(8,1)-1));
%Variable 8 : xCO2Eq_PPM
xCO2Eq_PPM(i,1)   = str2num(temp(space(8,3):space(9,1)-1));
%Variable 9 : xCO2ATM_PPM
xCO2ATM_PPM(i,1)   = str2num(temp(space(9,3):space(10,1)-1));
%Variable 10 : xCO2ATM_PPM_INTERPOLATED
xCO2ATM_PPM_INTERPOLATED(i,1)   = str2num(temp(space(10,3):space(11,1)-1));
%Variable 11 : press_equil
press_equil(i,1)   = str2num(temp(space(11,3):space(12,1)-1));
%Variable 12 : press_atm
press_atm(i,1)   = str2num(temp(space(12,3):space(13,1)-1));
%Variable 13 : TEQ
TEQ(i,1)   = str2num(temp(space(13,3):space(14,1)-1));
%Variable 14 : SST
SST(i,1)   = str2num(temp(space(14,3):space(15,1)-1));
%Variable 15 : SAL
SAL(i,1)   = str2num(temp(space(15,3):space(16,1)-1));
%Variable 16 : fco2sw_uatm
fco2sw_uatm(i,1)   = str2num(temp(space(16,3):space(17,1)-1));
%Variable 17 : fco2atm_uatm_interpolated
fco2atm_uatm_interpolated(i,1)   = str2num(temp(space(17,3):space(18,1)-1));
%Variable 18 : dfco2_uatm
dfco2_uatm(i,1)   = str2num(temp(space(18,3):space(19,1)-1));
%Variable 19 : licor_flow
licor_flow(i,1)   = str2num(temp(space(19,3):space(20,1)-1));
%Variable 20 : h2o_flow
h2o_flow(i,1)   = str2num(temp(space(20,3):space(21,1)-1));
%Variable 21 : windspeed_true
windspeed_true(i,:)   = str2num(temp(space(21,3):space(22,1)-1));
%Variable 22 : winddirection_true
winddirection_true(i,1)   = str2num(temp(space(22,3):space(23,1)-1));
%Variable 23 : type
type(i,:)   = temp(space(23,3):space(24,1)-1);
%Variable 24 : woce_QC_flag
woce_QC_flag(i,1)   = str2num(temp(space(24,3):space(25,1)-1));
%Variable 25 : supflag
SUBFLAG(i,1)   = str2num(temp(space(25,3):dimstr));
%
end
%
%
I(:,1) = (press_atm(:,1) < 0);
press_atm(I) = -999;
%
%
%%
%Creation of the NetCDF file
namenetcdf = strcat(liste{yy}(10:end-4),'.nc');
nc=netcdf(namenetcdf,'clobber')
%
dimfile = length(date);
%The reference date is the 1st of January 1950
timestart = [1950, 1, 1, 0, 0, 0];
%We are calculating the number of days since the reference date
for i = 1:dimfile
   timenc(i) = (etime(date(i,:),timestart))/(60*60*24);
end
%
%Creation of the GLOBAL ATTRIBUTES
%
%WHAT
nc.project     = 'Integrated Marine Observing System (IMOS)';
nc.conventions = 'IMOS version 1.3';
%
switch liste{yy}(1:8)
    case 'SS012008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS012008 (Hobart-Hobart) ';
        nc.cruise_id = 'SS012008';
        nc.abstract = ['This data was collected in January 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS012008. Departed: '...
        'Hobart, Tasmania, January 11, 2008. Arrived: Hobart, Tasmania February 01, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS012008, [data-access-URL], accessed [date-of-access]');
    case 'SS022008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS022008 (Hobart-Port Adelaide) ';
        nc.cruise_id = 'SS022008';
        nc.abstract = ['This data was collected in February 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS022008. Departed: '...
        'Hobart, Tasmania, February 04, 2008. Arrived: Port Adelaide, South Australia, February 26, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS022008, [data-access-URL], accessed [date-of-access]');
    case 'SS032008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS032008 (Port Adelaide-Hobart) ';
        nc.cruise_id = 'SS032008';
        nc.abstract = ['This data was collected in February and March 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS032008. Departed: '...
        'Port Adelaide, South Australia, February 28, 2008. Arrived: Hobart, Tasmania, March 17, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS032008, [data-access-URL], accessed [date-of-access]');
    case 'SS042008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS042008 (Hobart-Hobart) ';
        nc.cruise_id = 'SS042008';
        nc.abstract = ['This data was collected in March 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS042008. Departed: '...
        'Hobart, Tasmania, March 20, 2008. Arrived: Hobart, Tasmania, March 26, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS042008, [data-access-URL], accessed [date-of-access]');
    case 'SS052008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS052008 (Hobart-Hobart) ';
        nc.cruise_id = 'SS052008';
        nc.abstract = ['This data was collected in January 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS012008. Departed: '...
        'Hobart, Tasmania, January 11, 2008. Arrived: Hobart, Tasmania February 01, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS052008, [data-access-URL], accessed [date-of-access]');
    case 'ST012008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage ST012008 (Tasmania-Sydney) ';
        nc.cruise_id = 'ST012008';
        nc.abstract = ['This data was collected in April 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage ST012008. Departed: '...
        'Hobart, Tasmania, April 10, 2008. Arrived: Sydney, New South Wales, April 14, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage ST012008, [data-access-URL], accessed [date-of-access]');
    case 'SS062008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS062008 (Sydney-Noumea) ';
        nc.cruise_id = 'SS062008';
        nc.abstract = ['This data was collected in April 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS062008. Departed: '...
        'Sydney, New South Wales, April 16, 2008. Arrived: Noumea, New Caledonia, April 29, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS062008, [data-access-URL], accessed [date-of-access]');
    case 'SS072008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS072008 (Noumea-Suva) ';
        nc.cruise_id = 'SS072008';
        nc.abstract = ['This data was collected in May and June 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS072008. Departed: '...
        'Noumea, New Caledonia, April 30, 2008. Arrived: Suva, Fiji, June 06, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS072008, [data-access-URL], accessed [date-of-access]');
    case 'ST022008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage ST022008 (Suva-Cairns) ';
        nc.cruise_id = 'ST022008';
        nc.abstract = ['This data was collected in June 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage ST022008. Departed: '...
        'Suva, Fiji, June 08, 2008. Arrived: Cairns, Queensland, June 18, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage ST022008, [data-access-URL], accessed [date-of-access]');
    case 'SS092008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS092008 (Cairns-Gladstone) ';
        nc.cruise_id = 'SS092008';
        nc.abstract = ['This data was collected in July and August 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS092008. Departed: '...
        'Cairns, Queensland, July 24, 2008. Arrived: Gladstone, Queensland, August 11, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS092008, [data-access-URL], accessed [date-of-access]');
    case 'ST032008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage ST032008 (Gladstone-Sydney) ';
        nc.cruise_id = 'ST032008';
        nc.abstract = ['This data was collected in AUgust 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage ST032008. Departed: '...
        'Gladstone, Queenstows, Qugust 12, 2008. Arrived: Sydney, New South Wales, August 16, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage ST032008, [data-access-URL], accessed [date-of-access]');
    case 'SS102008'
        nc.title       = 'IMOS Underway CO2 dataset measured on the RV Southern Surveyor voyage SS102008 (Sydney-Newcastle) ';
        nc.cruise_id = 'SS102008';
        nc.abstract = ['This data was collected in October 2008 by the IMOS Ship'... 
        ' of Opportunity Underway CO2 Measurement research group on'...
        ' RV Southern Surveyor (IMOS platform code: VLHJ) voyage SS102008. Departed: '...
        'Sydney, New South Wales, October 10, 2008. Arrived: Newcastle, New South Wales, October 20, 2008'];
        nc.citation = strcat(' The citation in a list of references is: IMOS, [year-of-data-download], IMOS - SOOP Ocean Carbon Dioxide Data from RV Southern Surveyor voyage SS102008, [data-access-URL], accessed [date-of-access]');
    otherwise
        hh=1
end
%
nc.institution = 'Enhanced Measurements from Ships of Opportunity (SOOP) - CO2';
%
nc.date_created  = datestr(clock,'yyyy-mm-ddTHH:MM:SSZ');
%
nc.source = 'ship observation';
nc.keywords = ['Oceans>Ocean Temperature>Sea Surface Temperature ;'...
               'Oceans>Salinity/Density>Salinity ;'...
               'Oceans >Ocean Chemistry >Carbon Dioxide ;'...
               'pCO2>Carbon Dioxide>Underway System>Fugacity ;'...
               'Atmosphere >Atmospheric Pressure > Atmospheric Pressure'];
nc.platform_code = 'VLHJ';
nc.netcdf_version = '3.6';
nc.naming_authority = 'IMOS';
nc.quality_control_set = '4'
%WHERE
nc.geospatial_lat_min = min(latitude);
nc.geospatial_lat_max = max(latitude);
nc.geospatial_lon_min = min(longitude);
nc.geospatial_lon_max = max(longitude);
nc.geospatial_vertical_min = 0;
nc.geospatial_vertical_max = 0;
%WHEN
nc.time_coverage_start = datestr(date(1,:),'yyyy-mm-ddTHH:MM:SSZ');
nc.time_coverage_end = datestr(date(end,:),'yyyy-mm-ddTHH:MM:SSZ');
%nc.local_time_zone = localutc;
%WHO
nc.data_centre_email = 'info@emii.org.au';
nc.data_centre = 'eMarine Information Infrastructure (eMII)';
nc.principal_investigator = 'Tilbrook, Bronte CSIRO ; Akl, John CSIRO';
nc.institution_references = 'http://imos.org.au/emii.html';
%HOW
nc.acknowledgment = ['SOOP-CO2 data was sourced as part of the Integrated Marine Observing System '...
    '(IMOS) - IMOS is supported by the Australian Government'...
    ' through the National Collaborative Research Infrastructure'...
    ' Strategy (NCRIS) and the Super Science Initiative (SSI). The science support groups of the Australian Marine National Facility '...
    'and CSIRO, and in particular Matt Sherlock, Lindsay Pender, Steve Thomas and Drew Mills, '...
    'are thanked for their expertise in helping to setup and collect data.'];
nc.distribution_statement = ['Data, products and services'...
    ' from IMOS are provided "as is" without any warranty as to fitness'...
    ' for a particular purpose.'];
%
%Creation of the DIMENSION
%
nc('TIME') = dimfile;
nc('string_3') = 3;
%
%Creation of the VARIABLES
%
nc{'TIME'}            = {'TIME'};
nc{'LATITUDE'}        = {'TIME'};
nc{'LONGITUDE'}       = {'TIME'};
nc{'TEMP'}            = {'TIME'};
nc{'TEMP_2'}          = {'TIME'};
nc{'PSAL'}            = {'TIME'};
nc{'WSPD'}            = {'TIME'};
nc{'WDIR'}            = {'TIME'};
nc{'Press_Equil'}     = {'TIME'};
nc{'Press_ATM'}       = {'TIME'};
nc{'xCO2EQ_PPM'}      = {'TIME'};
nc{'xCO2ATM_PPM'}     = {'TIME'};
nc{'xCO2ATM_PPM_INTERPOLATED'}          = {'TIME'};
nc{'fCO2SW_UATM'}     = {'TIME'};
nc{'fCO2SW_UATM_INTERPOLATED'}          = {'TIME'};
nc{'DfCO2'}           = {'TIME'};
nc{'LICORflow'}       = {'TIME'};
nc{'H2OFLOW'}         = {'TIME'};
%nc{'TYPE'}            = {'TIME'};
nc{'TYPE'}            = ncchar('TIME','string_3');
%
nc{'SUBFLAG'}         = {'TIME'};
nc{'TIME_quality_control'}         = {'TIME'};
nc{'LATITUDE_quality_control'}     = {'TIME'};
nc{'LONGITUDE_quality_control'}    = {'TIME'};
nc{'TEMP_quality_control'}         = {'TIME'};
nc{'TEMP_2_quality_control'}       = {'TIME'};
nc{'PSAL_quality_control'}         = {'TIME'};
nc{'WSPD_quality_control'}         = {'TIME'};
nc{'WDIR_quality_control'}         = {'TIME'};
nc{'Press_Equil_quality_control'}  = {'TIME'};
nc{'Press_ATM_quality_control'}    = {'TIME'};
nc{'xCO2EQ_PPM_quality_control'}   = {'TIME'};
nc{'xCO2ATM_PPM_quality_control'}  = {'TIME'};
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}          = {'TIME'};
nc{'fCO2SW_UATM_quality_control'}  = {'TIME'};
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}          = {'TIME'};
nc{'DfCO2_quality_control'}        = {'TIME'};
nc{'LICORflow_quality_control'}    = {'TIME'};
nc{'H2OFLOW_quality_control'}      = {'TIME'};
%
%Creation of the VARIABLE ATTRIBUTES
%
%Time
nc{'TIME'}.standard_name          = 'time';
nc{'TIME'}.long_name              = 'analysis_time';
nc{'TIME'}.units                  = 'days since 1950-01-01 00:00:00';
nc{'TIME'}.axis                   = 'T';
nc{'TIME'}.valid_min              = 0;
nc{'TIME'}.valid_max              = 999999;
att = ncatt('_FillValue',-999,nc{'TIME'});
%nc{'TIME'}.local_time_zone        = localutc;
nc{'TIME'}.quality_control_set    = 4;
%nc{'TIME'}.quality_control_indicator           = 1;
nc{'TIME'}.ancillary_variables    = 'TIME_quality_control';
%Latitude
nc{'LATITUDE'}.standard_name         ='latitude';
nc{'LATITUDE'}.long_name             ='latitude';
nc{'LATITUDE'}.units                 ='degrees_north';
nc{'LATITUDE'}.axis                  ='Y';
nc{'LATITUDE'}.valid_min             =-90;
nc{'LATITUDE'}.valid_max             =90;
att = ncatt('_FillValue',-999,nc{'LATITUDE'});
nc{'LATITUDE'}.reference_datum       ='geographical coordinates, WGS84 projection';
nc{'LATITUDE'}.quality_control_set   = 4;
nc{'LATITUDE'}.ancillary_variables   = 'LATITUDE_quality_control';
% %Longitude
nc{'LONGITUDE'}.standard_name         ='longitude';
nc{'LONGITUDE'}.long_name             ='longitude';
nc{'LONGITUDE'}.units                 ='degrees_east';
nc{'LONGITUDE'}.axis                  ='X';
nc{'LONGITUDE'}.valid_min             =-180;
nc{'LONGITUDE'}.valid_max             =180;
att = ncatt('_FillValue',-999,nc{'LONGITUDE'});
nc{'LONGITUDE'}.reference_datum       ='geographical coordinates, WGS84 projection';
nc{'LONGITUDE'}.quality_control_set   = 4;
nc{'LONGITUDE'}.ancillary_variables   = 'LONGITUDE_quality_control';
%Temperature
nc{'TEMP'}.standard_name        ='sea_surface_temperature';
nc{'TEMP'}.long_name            ='sea surface temperature';
nc{'TEMP'}.units                ='Celsius';
att = ncatt('_FillValue',-999,nc{'TEMP'});
nc{'TEMP'}.valid_min            =-2;
nc{'TEMP'}.valid_max            =40;
nc{'TEMP'}.quality_control_set  = 4;
nc{'TEMP'}.ancillary_variables  = 'TEMP_quality_control';
%Equilibrator water Temperature
nc{'TEMP_2'}.long_name            ='equilibrator water temperature';
nc{'TEMP_2'}.units                ='Celsius';
att = ncatt('_FillValue',-999,nc{'TEMP_2'});
nc{'TEMP_2'}.valid_min            =-2;
nc{'TEMP_2'}.valid_max            =40;
nc{'TEMP_2'}.quality_control_set  = 4;
nc{'TEMP_2'}.ancillary_variables  = 'TEMP_2_quality_control';
%Salinity
nc{'PSAL'}.standard_name        ='sea_surface_salinity';
nc{'PSAL'}.long_name            ='sea surface salinity';
nc{'PSAL'}.units                ='1e-3';
att = ncatt('_FillValue',-999,nc{'PSAL'});
nc{'PSAL'}.valid_min            =0;
nc{'PSAL'}.valid_max            =42;
nc{'PSAL'}.quality_control_set  = 4;
nc{'PSAL'}.ancillary_variables  = 'PSAL_quality_control';
% %Pressure
nc{'Press_Equil'}.long_name            ='equilibrator head space pressure';
nc{'Press_Equil'}.units                ='hPa';
att = ncatt('_FillValue',-999,nc{'Press_Equil'});
%nc{'Press_Equil'}.valid_min            =-2;
%nc{'Press_Equil'}.valid_max            =40;
nc{'Press_Equil'}.quality_control_set  = 4;
nc{'Press_Equil'}.ancillary_variables  = 'Press_Equil_quality_control';
%Pressure
nc{'Press_ATM'}.long_name            ='barometric pressure';
nc{'Press_ATM'}.units                ='hPa';
att = ncatt('_FillValue',-999,nc{'Press_ATM'});
%nc{'Press_ATM'}.valid_min            =-2;
%nc{'Press_ATM'}.valid_max            =40;
nc{'Press_ATM'}.quality_control_set  = 4;
nc{'Press_ATM'}.ancillary_variables  = 'Press_ATM_quality_control';
%Mole fraction of CO2 in the equilibrator
nc{'xCO2EQ_PPM'}.long_name            ='mole fraction of CO2 in the equilibrator head space (dry)';
nc{'xCO2EQ_PPM'}.units                ='ppm';
att = ncatt('_FillValue',-999,nc{'xCO2EQ_PPM'});
%nc{'xCO2EQ_PPM'}.valid_min            =-2;
%nc{'xCO2EQ_PPM'}.valid_max            =40;
nc{'xCO2EQ_PPM'}.quality_control_set  = 4;
nc{'xCO2EQ_PPM'}.ancillary_variables  = 'xCO2EQ_PPM_quality_control';
%Mole fraction of CO2 in the atmosphere
nc{'xCO2ATM_PPM'}.long_name            ='mole fraction of CO2 in the atmosphere (dry) measured every 4 hours after standard runs';
nc{'xCO2ATM_PPM'}.units                ='ppm';
att = ncatt('_FillValue',-999,nc{'xCO2ATM_PPM'});
%nc{'xCO2ATM_PPM'}.valid_min            =-2;
%nc{'xCO2ATM_PPM'}.valid_max            =40;
nc{'xCO2ATM_PPM'}.quality_control_set  = 4;
nc{'xCO2ATM_PPM'}.ancillary_variables  = 'xCO2ATM_PPM_quality_control';
%Mole fraction of CO2 in the atmosphere
nc{'xCO2ATM_PPM_INTERPOLATED'}.long_name            ='mole fraction of CO2 in the atmosphere (dry) measured every 4 hours after standard runs and values linearly interpolated to the times shown';
nc{'xCO2ATM_PPM_INTERPOLATED'}.units                ='ppm';
att = ncatt('_FillValue',-999,nc{'xCO2ATM_PPM_INTERPOLATED'});
%nc{'xCO2ATM_PPM_INTERPOLATED'}.valid_min            =-2;
%nc{'xCO2ATM_PPM_INTERPOLATED'}.valid_max            =40;
nc{'xCO2ATM_PPM_INTERPOLATED'}.quality_control_set  = 4;
nc{'xCO2ATM_PPM_INTERPOLATED'}.ancillary_variables  = 'xCO2ATM_PPM_INTERPOLATED_quality_control';
%Fugacity of carbon dioxide
nc{'fCO2SW_UATM'}.long_name            ='fugacity of carbon dioxide at surface water salinity and temperature';
nc{'fCO2SW_UATM'}.units                ='µatm';
att = ncatt('_FillValue',-999,nc{'fCO2SW_UATM'});
%nc{'fCO2SW_UATM'}.valid_min            =-2;
%nc{'fCO2SW_UATM'}.valid_max            =40;
nc{'fCO2SW_UATM'}.quality_control_set  = 4;
nc{'fCO2SW_UATM'}.ancillary_variables  = 'fCO2SW_UATM_quality_control';
%fugacity of CO2 in the atmosphere
nc{'fCO2SW_UATM_INTERPOLATED'}.long_name            ='fugacity of CO2 in the atmosphere';
nc{'fCO2SW_UATM_INTERPOLATED'}.units                ='µatm';
att = ncatt('_FillValue',-999,nc{'fCO2SW_UATM_INTERPOLATED'});
%nc{'fCO2SW_UATM_INTERPOLATED'}.valid_min            =-2;
%nc{'fCO2SW_UATM_INTERPOLATED'}.valid_max            =40;
nc{'fCO2SW_UATM_INTERPOLATED'}.quality_control_set  = 4;
nc{'fCO2SW_UATM_INTERPOLATED'}.ancillary_variables  = 'fCO2SW_UATM_INTERPOLATED_quality_control';
%CO2 difference
nc{'DfCO2'}.long_name            ='Difference between fCO2SW and fCO2ATM';
nc{'DfCO2'}.units                ='µatm';
att = ncatt('_FillValue',-999,nc{'DfCO2'});
%nc{'DfCO2'}.valid_min            =-2;
%nc{'DfCO2'}.valid_max            =40;
nc{'DfCO2'}.quality_control_set  = 4;
nc{'DfCO2'}.ancillary_variables  = 'DfCO2_quality_control';
%Gas flow through infrared gas analyser
nc{'LICORflow'}.long_name            ='Gas flow through infrared gas analyser';
nc{'LICORflow'}.units                ='ml/min';
att = ncatt('_FillValue',-999,nc{'LICORflow'});
%nc{'LICORflow'}.valid_min            =-2;
%nc{'LICORflow'}.valid_max            =40;
nc{'LICORflow'}.quality_control_set  = 4;
nc{'LICORflow'}.ancillary_variables  = 'LICORflow_quality_control';
%water flow to equilibrator
nc{'H2OFLOW'}.long_name            ='water flow to equilibrator';
nc{'H2OFLOW'}.units                ='litres per minute';
att = ncatt('_FillValue',-999,nc{'H2OFLOW'});
%nc{'H2OFLOW'}.valid_min            =-2;
%nc{'H2OFLOW'}.valid_max            =40;
nc{'H2OFLOW'}.quality_control_set  = 4;
nc{'H2OFLOW'}.ancillary_variables  = 'H2OFLOW_quality_control';
%Wind speed
nc{'WSPD'}.standard_name        ='wind_speed';
nc{'WSPD'}.long_name            ='wind speed';
nc{'WSPD'}.units                ='m/s';
att = ncatt('_FillValue',-999,nc{'WSPD'});
%nc{'WSPD'}.valid_min            =-2;
%nc{'WSPD'}.valid_max            =40;
nc{'WSPD'}.quality_control_set  = 4;
nc{'WSPD'}.ancillary_variables  = 'WSPD_quality_control';
%Wind direction
%nc{'WDIR'}.standard_name        ='sea_surface_temperature';
nc{'WDIR'}.long_name            ='wind direction';
nc{'WDIR'}.units                ='degrees';
nc{'WDIR'}.comments             ='true wind direction where 0 is North and 90 is East';
att = ncatt('_FillValue',-999,nc{'WDIR'});
%nc{'WDIR'}.valid_min            =-2;
%nc{'WDIR'}.valid_max            =40;
nc{'WDIR'}.quality_control_set  = 4;
nc{'WDIR'}.ancillary_variables  = 'WDIR_quality_control';
%Measurement Type
nc{'TYPE'}.long_name            ='measurement type (equilibrator, standard or atmosphere)';
nc{'TYPE'}.units                = 'categorical';
%att = ncatt('_FillValue',toto,nc{'TYPE'});
%nc{'WDIR'}.valid_min            =-2;
%nc{'WDIR'}.valid_max            =40;
%
%Quality control variables
flagvalues = [2 3 4];
%
nc{'SUBFLAG'}.long_name             ='secondary flags, only for questionable measurements, WOCE flag 3 (Pierrot et Al 2009)';
att = ncatt('_FillValue',-999,nc{'SUBFLAG'});
nc{'SUBFLAG'}.valid_min             =1;
nc{'SUBFLAG'}.valid_max             =10;
nc{'SUBFLAG'}.references            = ['Pierrot,D. et al. 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
nc{'TIME_quality_control'}.long_name             ='Quality Control flag for time';
nc{'TIME_quality_control'}.standard_name         ='time status_flag';
nc{'TIME_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'TIME_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'TIME_quality_control'});
nc{'TIME_quality_control'}.valid_min             =2;
nc{'TIME_quality_control'}.valid_max             =4;
nc{'TIME_quality_control'}.flag_values           = flagvalues;
nc{'TIME_quality_control'}.flag_meanings         ='good questionable bad';
nc{'TIME_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'TIME_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'LATITUDE_quality_control'}.long_name             ='Quality Control flag for latitude';
nc{'LATITUDE_quality_control'}.standard_name         ='latitude status_flag';
nc{'LATITUDE_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'LATITUDE_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'LATITUDE_quality_control'});
nc{'LATITUDE_quality_control'}.valid_min             =2;
nc{'LATITUDE_quality_control'}.valid_max             =4;
nc{'LATITUDE_quality_control'}.flag_values           = flagvalues;
nc{'LATITUDE_quality_control'}.flag_meanings         ='good questionable bad';
nc{'LATITUDE_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'LATITUDE_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'LONGITUDE_quality_control'}.long_name             ='Quality Control flag for longitude';
nc{'LONGITUDE_quality_control'}.standard_name         ='longitude status_flag';
nc{'LONGITUDE_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'LONGITUDE_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'LONGITUDE_quality_control'});
nc{'LONGITUDE_quality_control'}.valid_min             =2;
nc{'LONGITUDE_quality_control'}.valid_max             =4;
nc{'LONGITUDE_quality_control'}.flag_values           = flagvalues;
nc{'LONGITUDE_quality_control'}.flag_meanings         ='good questionable bad';
nc{'LONGITUDE_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'LONGITUDE_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'TEMP_quality_control'}.long_name             ='Quality Control flag for sea_surface_temperature';
nc{'TEMP_quality_control'}.standard_name         ='sea_surface_temperature status_flag';
nc{'TEMP_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'TEMP_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'TEMP_quality_control'});
nc{'TEMP_quality_control'}.valid_min             =2;
nc{'TEMP_quality_control'}.valid_max             =4;
nc{'TEMP_quality_control'}.flag_values           = flagvalues;
nc{'TEMP_quality_control'}.flag_meanings         ='good questionable bad';
nc{'TEMP_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'TEMP_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'TEMP_2_quality_control'}.long_name             ='Quality Control flag for equilibrator water temperature';
nc{'TEMP_2_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'TEMP_2_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'TEMP_2_quality_control'});
nc{'TEMP_2_quality_control'}.valid_min             =2;
nc{'TEMP_2_quality_control'}.valid_max             =4;
nc{'TEMP_2_quality_control'}.flag_values           = flagvalues;
nc{'TEMP_2_quality_control'}.flag_meanings         ='good questionable bad';
nc{'TEMP_2_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'TEMP_2_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'PSAL_quality_control'}.long_name             ='Quality Control flag for sea_surface_salinity';
nc{'PSAL_quality_control'}.standard_name         ='sea_surface_salinity status_flag';
nc{'PSAL_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'PSAL_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'PSAL_quality_control'});
nc{'PSAL_quality_control'}.valid_min             =2;
nc{'PSAL_quality_control'}.valid_max             =4;
nc{'PSAL_quality_control'}.flag_values           = flagvalues;
nc{'PSAL_quality_control'}.flag_meanings         ='good questionable bad';
nc{'PSAL_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'PSAL_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'Press_Equil_quality_control'}.long_name             ='Quality Control flag for equilibrator head space pressure';
nc{'Press_Equil_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'Press_Equil_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'Press_Equil_quality_control'});
nc{'Press_Equil_quality_control'}.valid_min             =2;
nc{'Press_Equil_quality_control'}.valid_max             =4;
nc{'Press_Equil_quality_control'}.flag_values           = flagvalues;
nc{'Press_Equil_quality_control'}.flag_meanings         ='good questionable bad';
nc{'Press_Equil_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'Press_Equil_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'Press_ATM_quality_control'}.long_name             ='Quality Control flag for barometric pressure';
nc{'Press_ATM_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'Press_ATM_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'Press_ATM_quality_control'});
nc{'Press_ATM_quality_control'}.valid_min             =2;
nc{'Press_ATM_quality_control'}.valid_max             =4;
nc{'Press_ATM_quality_control'}.flag_values           = flagvalues;
nc{'Press_ATM_quality_control'}.flag_meanings         ='good questionable bad';
nc{'Press_ATM_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'Press_ATM_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'xCO2EQ_PPM_quality_control'}.long_name             ='Quality Control flag for xCO2EQ_PPM';
nc{'xCO2EQ_PPM_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'xCO2EQ_PPM_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'xCO2EQ_PPM_quality_control'});
nc{'xCO2EQ_PPM_quality_control'}.valid_min             =2;
nc{'xCO2EQ_PPM_quality_control'}.valid_max             =4;
nc{'xCO2EQ_PPM_quality_control'}.flag_values           = flagvalues;
nc{'xCO2EQ_PPM_quality_control'}.flag_meanings         ='good questionable bad';
nc{'xCO2EQ_PPM_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'xCO2EQ_PPM_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'xCO2ATM_PPM_quality_control'}.long_name             ='Quality Control flag for xCO2ATM_PPM';
nc{'xCO2ATM_PPM_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'xCO2ATM_PPM_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'xCO2ATM_PPM_quality_control'});
nc{'xCO2ATM_PPM_quality_control'}.valid_min             =2;
nc{'xCO2ATM_PPM_quality_control'}.valid_max             =4;
nc{'xCO2ATM_PPM_quality_control'}.flag_values           = flagvalues;
nc{'xCO2ATM_PPM_quality_control'}.flag_meanings         ='good questionable bad';
nc{'xCO2ATM_PPM_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'xCO2ATM_PPM_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.long_name             ='Quality Control flag for xCO2ATM_PPM_INTERPOLATED';
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'});
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.valid_min             =2;
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.valid_max             =4;
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.flag_values           = flagvalues;
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.flag_meanings         ='good questionable bad';
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'fCO2SW_UATM_quality_control'}.long_name             ='Quality Control flag for fCO2SW_UATM';
nc{'fCO2SW_UATM_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'fCO2SW_UATM_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'fCO2SW_UATM_quality_control'});
nc{'fCO2SW_UATM_quality_control'}.valid_min             =2;
nc{'fCO2SW_UATM_quality_control'}.valid_max             =4;
nc{'fCO2SW_UATM_quality_control'}.flag_values           = flagvalues;
nc{'fCO2SW_UATM_quality_control'}.flag_meanings         ='good questionable bad';
nc{'fCO2SW_UATM_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'fCO2SW_UATM_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.long_name             ='Quality Control flag for fCO2SW_UATM_INTERPOLATED';
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'fCO2SW_UATM_INTERPOLATED_quality_control'});
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.valid_min             =2;
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.valid_max             =4;
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.flag_values           = flagvalues;
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.flag_meanings         ='good questionable bad';
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'DfCO2_quality_control'}.long_name             ='Quality Control flag for DfCO2';
nc{'DfCO2_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'DfCO2_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'DfCO2_quality_control'});
nc{'DfCO2_quality_control'}.valid_min             =2;
nc{'DfCO2_quality_control'}.valid_max             =4;
nc{'DfCO2_quality_control'}.flag_values           = flagvalues;
nc{'DfCO2_quality_control'}.flag_meanings         ='good questionable bad';
nc{'DfCO2_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'DfCO2_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'LICORflow_quality_control'}.long_name             ='Quality Control flag for LICORflow';
nc{'LICORflow_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'LICORflow_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'LICORflow_quality_control'});
nc{'LICORflow_quality_control'}.valid_min             =2;
nc{'LICORflow_quality_control'}.valid_max             =4;
nc{'LICORflow_quality_control'}.flag_values           = flagvalues;
nc{'LICORflow_quality_control'}.flag_meanings         ='good questionable bad';
nc{'LICORflow_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'LICORflow_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'H2OFLOW_quality_control'}.long_name             ='Quality Control flag for H2OFLOW';
nc{'H2OFLOW_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'H2OFLOW_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'H2OFLOW_quality_control'});
nc{'H2OFLOW_quality_control'}.valid_min             =2;
nc{'H2OFLOW_quality_control'}.valid_max             =4;
nc{'H2OFLOW_quality_control'}.flag_values           = flagvalues;
nc{'H2OFLOW_quality_control'}.flag_meanings         ='good questionable bad';
nc{'H2OFLOW_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'H2OFLOW_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'WSPD_quality_control'}.long_name             ='Quality Control flag for wind speed';
nc{'WSPD_quality_control'}.standard_name         ='wind_speed status_flag';
nc{'WSPD_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'WSPD_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'WSPD_quality_control'});
nc{'WSPD_quality_control'}.valid_min             =2;
nc{'WSPD_quality_control'}.valid_max             =4;
nc{'WSPD_quality_control'}.flag_values           = flagvalues;
nc{'WSPD_quality_control'}.flag_meanings         ='good questionable bad';
nc{'WSPD_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'WSPD_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%
nc{'WDIR_quality_control'}.long_name             ='Quality Control flag for wind direction';
nc{'WDIR_quality_control'}.quality_control_conventions           ='WOCE quality control flag';
nc{'WDIR_quality_control'}.quality_control_set   = 4;
att = ncatt('_FillValue',9999,nc{'WDIR_quality_control'});
nc{'WDIR_quality_control'}.valid_min             =2;
nc{'WDIR_quality_control'}.valid_max             =4;
nc{'WDIR_quality_control'}.flag_values           = flagvalues;
nc{'WDIR_quality_control'}.flag_meanings         ='good questionable bad';
nc{'WDIR_quality_control'}.comments              = 'If data is flagged as questionable, please see the variable SUBFLAG for more information';
nc{'WDIR_quality_control'}.references            = ['Pierrot et Al 2009, Recommendations for Autonomous Underway '...
    'pCO2 Measuring Systems and Data Reduction Routines, Deep-Sea Research II, doi:10.1016/j.dsr2.2008.12.005'];
%
%Data values for each variable
%
nc{'TIME'}(:)           = timenc(:);
nc{'LATITUDE'}(:)       = latitude(:,1);
nc{'LONGITUDE'}(:)      = longitude(:,1);
nc{'TEMP'}(:)           = SST(:,1);
nc{'TEMP_2'}(:)         = TEQ(:,1);
nc{'PSAL'}(:)           = SAL(:,1);
nc{'WSPD'}(:)           = windspeed_true(:,1);
nc{'WDIR'}(:)           = winddirection_true(:,1);
nc{'Press_Equil'}(:)    = press_equil(:,1);
nc{'Press_ATM'}(:)      = press_atm(:,1);
nc{'xCO2EQ_PPM'}(:)     = xCO2Eq_PPM(:,1);
nc{'xCO2ATM_PPM'}(:)    = xCO2ATM_PPM(:,1);
nc{'xCO2ATM_PPM_INTERPOLATED'}(:)          = xCO2ATM_PPM_INTERPOLATED(:,1);
nc{'fCO2SW_UATM'}(:)    = fco2sw_uatm(:,1);
nc{'fCO2SW_UATM_INTERPOLATED'}(:)          = fco2atm_uatm_interpolated(:,1);
nc{'DfCO2'}(:)          = dfco2_uatm(:,1);
nc{'LICORflow'}(:)      = licor_flow(:,1);
nc{'H2OFLOW'}(:)        = h2o_flow(:,1);
nc{'TYPE'}(:,:)         = type(:,:);
%
nc{'TIME_quality_control'}(:)              = woce_QC_flag(:,1);
nc{'SUBFLAG'}(:)                           = SUBFLAG(:,1);
nc{'LATITUDE_quality_control'}(:)          = woce_QC_flag(:,1);
nc{'LONGITUDE_quality_control'}(:)         = woce_QC_flag(:,1);
nc{'TEMP_quality_control'}(:)              = woce_QC_flag(:,1);
nc{'TEMP_2_quality_control'}(:)            = woce_QC_flag(:,1);
nc{'PSAL_quality_control'}(:)              = woce_QC_flag(:,1);
nc{'Press_Equil_quality_control'}(:)       = woce_QC_flag(:,1);
nc{'Press_ATM_quality_control'}(:)         = woce_QC_flag(:,1);
nc{'xCO2EQ_PPM_quality_control'}(:)        = woce_QC_flag(:,1);
nc{'xCO2ATM_PPM_quality_control'}(:)       = woce_QC_flag(:,1);
nc{'xCO2ATM_PPM_INTERPOLATED_quality_control'}(:)       = woce_QC_flag(:,1);
nc{'fCO2SW_UATM_quality_control'}(:)       = woce_QC_flag(:,1);
nc{'fCO2SW_UATM_INTERPOLATED_quality_control'}(:)       = woce_QC_flag(:,1);
nc{'DfCO2_quality_control'}(:)             = woce_QC_flag(:,1);
nc{'LICORflow_quality_control'}(:)         = woce_QC_flag(:,1);
nc{'H2OFLOW_quality_control'}(:)           = woce_QC_flag(:,1);
nc{'WSPD_quality_control'}(:)              = woce_QC_flag(:,1);
nc{'WDIR_quality_control'}(:)              = woce_QC_flag(:,1);
%
%Close the NetCDF file
nc=close(nc);
%Clear the data
clear I data
clear JD_GMT SAL SST SUBFLAG TEQ
clear cruise date dfco2_uatm
clear fco2atm_uatm_interpolated fco2sw_uatm
clear h2o_flow latitude licor_flow longitude
clear press_atm press_equil ship space
clear timenc type winddirection_true
clear windspeed_true
clear woce_QC_flag toto temp namenetcdf
clear xCO2ATM_PPM xCO2ATM_PPM_INTERPOLATED xCO2Eq_PPM
%
end