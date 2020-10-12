/*data preprocessing-choose the column need*/
libname project "/folders/myfolders/project";

data Jan_host; set project.JAN;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data Feb_host; set project.feb;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data March_host; set project.March;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data April_host; set project.April;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data May_host; set project.May;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;
data June_host; set project.June;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;
data First_half_host;set Jan_host Feb_host March_host April_host May_host June_host;
	revenue= price *availability_30;
run;

data July_host; set project.july;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data August_host; set project.AUGUST;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data September_host; set project.SEPT;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data October_host; set project.Oct;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data November_host; set project.Nov;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;
data December_host; set project.Dec;
keep host_id price neighbourhood zipcode host_name availability_30 calendar_last_scraped host_listings_count latitude longitude;
run;

data Second_half_host;set July_host August_host September_host October_host November_host December_host;
	revenue= price *availability_30;
run;

data Year_host;set First_half_host Second_half_host;
run;


/*choose the top5 host in the first half year, second half and whole year*/
/*first half year*/
%web_drop_table(project.FIrst_top);

PROC SQL; 
CREATE TABLE project.FIrst_top 
AS 
SELECT 
DISTINCT FIRST_HALF_HOST.host_id, COUNT(FIRST_HALF_HOST.host_name) 
AS property, FIRST_HALF_HOST.neighbourhood,FIRST_HALF_HOST.host_listings_count,First_HALF_HOST.latitude,First_HALF_HOST.longitude, FIRST_HALF_HOST.calendar_last_scraped, FIRST_HALF_HOST.zipcode, FIRST_HALF_HOST.price, FIRST_HALF_HOST.availability_30, SUM(FIRST_HALF_HOST.revenue) 
AS revenue 
FROM WORK.FIRST_HALF_HOST FIRST_HALF_HOST 
GROUP BY FIRST_HALF_HOST.host_id 
ORDER BY revenue DESC; 
QUIT;

%web_open_table(project.FIrst_top);

/*second half year*/
%web_drop_table(project.Second_top);

PROC SQL; 
CREATE TABLE project.Second_top 
AS 
SELECT 
DISTINCT Second_HALF_HOST.host_id, COUNT(Second_HALF_HOST.host_name) 
AS property, Second_HALF_HOST.neighbourhood,Second_HALF_HOST.latitude,Second_HALF_HOST.longitude,Second_HALF_HOST.host_listings_count,Second_HALF_HOST.latitude,Second_HALF_HOST.longitude, Second_HALF_HOST.calendar_last_scraped, Second_HALF_HOST.zipcode, Second_HALF_HOST.price, Second_HALF_HOST.availability_30, SUM(Second_HALF_HOST.revenue) 
AS revenue 
FROM WORK.Second_HALF_HOST Second_HALF_HOST 
GROUP BY Second_HALF_HOST.host_id 
ORDER BY revenue DESC; 
QUIT;

%web_open_table(project.Second_top);

/*first half year top5*/
%web_drop_table(WORK.First_Half_5);


PROC SQL; 
CREATE TABLE WORK.First_Half_5 
AS 
SELECT 
DISTINCT FIRST_HALF_HOST.host_id, COUNT(FIRST_HALF_HOST.host_name) 
AS count, FIRST_HALF_HOST.host_listings_count, FIRST_HALF_HOST.neighbourhood,First_HALF_HOST.latitude,First_HALF_HOST.longitude, FIRST_HALF_HOST.zipcode, FIRST_HALF_HOST.price, FIRST_HALF_HOST.calendar_last_scraped, FIRST_HALF_HOST.availability_30, SUM(FIRST_HALF_HOST.revenue) 
AS revenue 
FROM WORK.FIRST_HALF_HOST FIRST_HALF_HOST 
WHERE 
   ( FIRST_HALF_HOST.host_id IN 
      ( 1.04309976E8, 1.18565935E8, 1.57959474E8, 1710302.0, 2.10733801E8 ) 
   ) 
GROUP BY FIRST_HALF_HOST.host_id 
ORDER BY revenue DESC; 
QUIT;

%web_open_table(WORK.First_Half_5);

/*second half year top5*/
PROC SQL; 
CREATE TABLE WORK.Second_Half_5 
AS 
SELECT 
DISTINCT Second_HALF_HOST.host_id, COUNT(Second_HALF_HOST.host_name) 
AS count, Second_HALF_HOST.host_listings_count, Second_HALF_HOST.neighbourhood,Second_HALF_HOST.latitude,Second_HALF_HOST.longitude, Second_HALF_HOST.zipcode, Second_HALF_HOST.price, Second_HALF_HOST.calendar_last_scraped, Second_HALF_HOST.availability_30, SUM(Second_HALF_HOST.revenue) 
AS revenue 
FROM WORK.Second_HALF_HOST Second_HALF_HOST 
WHERE 
   ( Second_HALF_HOST.host_id IN 
      ( 1.04309976E8, 1.18565935E8, 1.57959474E8, 114353388.0, 2.10733801E8 ) 
   ) 
GROUP BY Second_HALF_HOST.host_id 
ORDER BY revenue DESC; 
QUIT;

%web_open_table(WORK.Second_Half_5);

/*whole year top5*/
PROC SQL; 
CREATE TABLE WORK.Year_host_5 
AS 
SELECT 
DISTINCT Year_host.host_id, COUNT(Year_host.host_name) 
AS count, Year_host.host_listings_count, Year_host.neighbourhood,Year_host.latitude,Year_host.longitude, Year_host.zipcode, Year_host.price, Year_host.calendar_last_scraped, Year_host.availability_30, SUM(Year_host.revenue) 
AS revenue 
FROM WORK.Year_host Year_host 
GROUP BY Year_host.host_id 
ORDER BY revenue DESC; 
QUIT;

%web_open_table(WORK.Year_host_5);


/*plot scatter map of first half year*/

ods graphics / reset width=6.4in height=4.8in;

proc sgmap plotdata=WORK.FIRST_HALF_5;
	openstreetmap;
	scatter x=longitude y=latitude/ group=host_id name="scatterPlot" 
		markerattrs=(size=7);
	keylegend "scatterPlot"/ title='host_id';
run;

ods graphics / reset;


/*plot scatter map of second half year*/
ods graphics / reset width=6.4in height=4.8in;

proc sgmap plotdata=WORK.SECOND_HALF_5;
	openstreetmap;
	scatter x=longitude y=latitude/ group=host_id name="scatterPlot" 
		markerattrs=(size=7);
	keylegend "scatterPlot"/ title='host_id';
run;

ods graphics / reset;

%if %sysfunc(exist(WORK.'Rank first'n)) %then %do;

/*select the host rank 1 in the whole year and plot the scatter map */
%if %sysfunc(exist(WORK.'Rank first'n)) %then %do;
proc sql;
    drop table WORK.'Rank first'n;
run;

%end;;


PROC SQL; 
CREATE TABLE WORK.'Rank first'n 
AS 
SELECT YEAR_HOST_5.host_id, YEAR_HOST_5.count, YEAR_HOST_5.host_listings_count, YEAR_HOST_5.neighbourhood, YEAR_HOST_5.latitude, YEAR_HOST_5.longitude, YEAR_HOST_5.zipcode, YEAR_HOST_5.price, YEAR_HOST_5.calendar_last_scraped, YEAR_HOST_5.availability_30, SUM(YEAR_HOST_5.revenue) 
AS revenue 
FROM WORK.YEAR_HOST_5 YEAR_HOST_5 
WHERE 
   ( YEAR_HOST_5.host_id = 104309976 ) ; 
QUIT;

%web_open_table(WORK.'Rank first'n);

/*plot scatter map */

ods graphics / reset width=6.4in height=4.8in;

proc sgmap plotdata=WORK.'RANK FIRST'n;
	openstreetmap;
	scatter x=longitude y=latitude/ markerattrs=(size=7);
run;

ods graphics / reset;