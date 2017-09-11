Google Annotated map of New York City and SAS Country,State,County and Zip mapping

for high res output from this post
https://www.dropbox.com/s/fjex72th0fv1c70/manhattan.pdf?dl=0

SAS/WPS/R: Google Annotated map of New York City
SAS Forum: GeoMapping 6 Counties

    Problem

        HAVE

           1 Allen St. Manhattan New York City, NY 10002
           1 Wall St Manhattan New York City, NY 10005

        WANT (annotate a map of Manhattan with these points)


    WORKING CODE  (very simple)
    ============
    IML/R WPS/Proc-R

        lonlat <-  geocode(have)    * get latitude and logitude of addresses

        nyc_base <- ggmap::get_map("New York City", zoom = 14);
        ggmap(nyc_base) + geom_point(data=lonlat,
          aes(x=LON, y=LAT), color="red", size=10, alpha=0.5);

If you have IML interface to R you can cut and paste the code
below.

Also see

see
https://goo.gl/VySs1Y
https://communities.sas.com/t5/SAS-GRAPH-and-ODS-Graphics/GeoMapping-6-Counties/m-p/394014

and
https://goo.gl/Ja56My
https://communities.sas.com/t5/Base-SAS-Programming
/Creating-Maps-using-Long-Lat-Codes/m-p/346644/highlight/false#M79964

see for high res map
https://www.dropbox.com/s/ax7i5mvr5ctjgcm/nyc.png?dl=0

For documentaion of SAS SAS country,State,County and Zip mapping with census data see

https://www.dropbox.com/s/pg8ljrm6lhqfbw8/mta_cen.pdf?dl=0
https://www.dropbox.com/s/ir78dgzzaez4xg3/mta_cen.sas?dl=0 (my version of SASweave)
https://www.dropbox.com/s/j5pnfph4cug7c89/mta_mtacen.sas7bdat?dl=0
https://www.dropbox.com/s/2wmx9k08f7lr3w2/mta_mtacen.sas7bndx?dl=0


HAVE
====
   Up to 40 obs SD1.HAVE total obs=2

   Obs                         ADR

    1     1 Allen St. Manhattan New York City, NY 10002
    2     1 Wall St. Manhattan New York City, NY 10005

    * this is the google map of NYC (google allows 25,000 accesses per day to there maps);
    https://goo.gl/xG5Ahn
    http://maps.googleapis.com/maps/api/staticmap?center=New+York+City
       &zoom=14&size=640x640&scale=2&maptype=terrain&language=en-EN&sensor=false

WANT
====

   Geocoded lat and lon for addresses above

   Up to 40 obs from sd1.lonlat total obs=2

   Obs       LON        LAT      ADDRESS

    1     -73.9932    40.7145   1 Allen St. Manhattan New York City, NY 10002
    2     -74.0116    40.7075   1 Wall St Manhattan New York City, NY 10005


             Plot of LAT*LON.  Symbol used is '*'.

   LAT |
       |
40.900 +
       |                                              *
       |                                            /  \
       |                                           *     \
40.875 +                                          /        \
       |                                        /      /*--*
       |                                      /      */
       |                                    /       /
40.850 +                                  *        /
       |                                  |       /
       |                                 /       /
       |                               */       *
40.825 +                              /___      |
       |                            / / _ \     |
       |                          /  | (_) |    *
       |                        /     \___/      *
40.800 +                      /                   *
       |                    /     1 Allen St.   /
       |                  /                 ---*
       |                /                   \
40.775 +              /                   *- *
       |            /                   /
       |          /   Manhattan        /
       |        *                   /
40.750 +       /                  /
       |      /                  *
       |     /  1 Wall St.      /
       |    /   ___             *
40.725 +   /   / _ \           /
       |   *  | (_) |        ___*
       |   /   \___/        /
       |  *\    /- *------/
40.700 +    *-*/
       |
       -+----------+----------+----------+----------+----------+
     -74.03     -74.00     -73.98     -73.95     -73.92   -73.90

                                  LON

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  length adr $60;
  input;
  adr=_infile_;
cards4;
1 Allen St. Manhattan New York City, NY 10002
1 Wall St Manhattan New York City, NY 10005
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

  __ _  ___  ___   ___ ___   __| | ___
 / _` |/ _ \/ _ \ / __/ _ \ / _` |/ _ \
| (_| |  __/ (_) | (_| (_) | (_| |  __/
 \__, |\___|\___/ \___\___/ \__,_|\___|
 |___/
;

%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname sd1 "d:/sd1";
proc r;
submit;
source("c:/Program Files/R/R-3.3.2/etc/Rprofile.site",echo=T);
library(haven);
library("ggmap");
have<-read_sas("d:/sd1/have.sas7bdat");
lonlat_sample <- c(NA,NA);
for ( i in 1:2) {
  lonlat_sample <- rbind(lonlat_sample, as.numeric(geocode(have$ADR[i])));
};
want<-as.data.frame(lonlat_sample)[2:3,];
colnames(want)<-c("lon","lat");
endsubmit;
import r=want data=sd1.lonlat;
run;quit;
');

/*
Up to 40 obs from sd1.lonlat total obs=2

Obs       LON        LAT

 1     -73.9932    40.7145
 2     -74.0116    40.7075
*/

*
 _ __ ___   __ _ _ __
| '_ ` _ \ / _` | '_ \
| | | | | | (_| | |_) |
|_| |_| |_|\__,_| .__/
                |_|
;


%utl_submit_r64('
source("c:/Program Files/R/R-3.3.2/etc/Rprofile.site",echo=T);
library(ggmap);
library(haven);
lonlat=read_sas("d:/sd1/lonlat.sas7bdat");
nyc_base <- ggmap::get_map("New York City", zoom = 14);
ggmap(nyc_base) + geom_point(data=lonlat,
  aes(x=LON, y=LAT), color="red", size=10, alpha=0.5);
ggsave("d:/pdf/manhattan.pdf", width = 20, height = 20, units = "cm")
');



