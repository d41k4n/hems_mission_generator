/*
#
# melbo @ https://x-plane.org
#
*/

#define VERSION "0.1.5"

#ifdef _WIN32
 #include <windows.h>
 #include <process.h>
 #include "dirent.h"
#else
 #include <libgen.h>
 #include <unistd.h>
 #include <dirent.h>
#endif

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#define MAX_TXT 1024
#define MAX_WRD 1024

#define XSCENERYDIR "./Custom Scenery"         /* where to look for orthos */

const char *keywords[] = {
	"spital","clinic","medic","klinik","krankenhaus","christoph"," sar "," lrz ", 
	" khk ", " kh "," hems "," rega ","ospedale","health","rescue","rettung","samu",
	"lifeliner"
};

int debug = 0;
int around = 0;
int latint = 0;
int lonint = 0;
char *words[MAX_WRD];
char lat_filter[MAX_TXT];
char lon_filter[MAX_TXT];

/*-----------------------------------------------------------------*/

int strip(char *s) {           /* remove trailing whitespace */
   int i = strlen(s);
   while (i >= 0 && s[i] <= ' ') {
      s[i--] = '\0';
   }
   return(0);
}

/*-----------------------------------------------------------------*/

int rmZeros(char *s) {           /* remove leading zeros */
   int i = 0;
   int j = 0;
   int l = 0;

   l = strlen(s);
   /* find end of leading zeros */
   while ( (s[i] == '0' && s[i+1] != '.' && i < l) ) i++ ;

   if ( i > 0 ) {     /* if it has more than 0 leading zero */
      while ( i <= l ) {
         s[j++] = s[i++];     /* remove them */
      }
   }
   return(0);
}

/*-----------------------------------------------------------------*/

int split(char *s) {
   int w = 0;
   int i = 0;

   char tmp[MAX_TXT];
   char *k;

   k = tmp;

   strcpy(tmp,s);

   while(tmp[i] > '\0' && w < MAX_WRD ) {
      if (tmp[i] <= ' ' ) {
         tmp[i++] = '\0';

         if ( words[w] == NULL ) words[w] = (char*) malloc(MAX_TXT);
         strcpy(words[w++], k);
         while(tmp[i] > '\0' && tmp[i] <= ' ' )
            i++;
         k = &tmp[i];
      } else {
         i++;
      }
   }
   if ( words[w] == NULL ) words[w] = (char*) malloc(MAX_TXT);
   strcpy(words[w++], k);
   return(w);
}

/*-----------------------------------------------------------------*/

int scanHelis() {
   FILE *in;
   DIR *d;
   struct dirent *dir;

   int match = 0;
   int i = 0;
   int n = 0;

   char buf[MAX_TXT];
   char buf2[MAX_TXT];
   char apt[MAX_TXT];
   char name[MAX_TXT];
   char outfile[MAX_TXT];
   char lon[MAX_TXT];
   char lat[MAX_TXT];

   int mylat = 0;
   int mylon = 0;

   if ( (d = opendir(XSCENERYDIR)) != NULL) {
      while ((dir = readdir(d)) != NULL) {
         strcpy(apt,XSCENERYDIR);
         strcat(apt,"/");
         strcat(apt,dir->d_name);
         strcat(apt,"/Earth nav data/apt.dat");
         if ( (in = fopen(apt,"r")) ) {
            if ( debug ) {
               printf("scanning %s\n",apt);
            }
            match = 0; 
            while ( fgets(buf, MAX_TXT, in) != NULL ) {
               if ( ! strncmp(buf,"17 ",3) ) {    /*  heliport ? */
                  match = 0;
                  for ( n=0;n<strlen(buf);n++) {
                     buf2[n] = tolower(buf[n]);
                  }
                  buf2[n] = '\0';
                  for ( i=0;i<(sizeof(keywords)/sizeof(keywords[0]));i++) {
                     if ( strstr(buf2,keywords[i]) ) {    /* check for keywords */
                        match = 1;
                        break;
                     }
                  }
                  if ( match ) { 
                     strcpy(name,&buf[14]);
                     strip(name);                   /* remember apr name */
                  }
               } else {
                  if ( ! strncmp(buf,"102 ",4) && match ) { /* helipad ? */
                     n = split(buf);
                     if ( n > 3 ) {
                        strcpy(lat,words[2]); 
                        strcpy(lon,words[3]); 
                        if ( lat[0] == '0' ) rmZeros(lat); /* remove leading 0 */
                        if ( lon[0] == '0' ) rmZeros(lon);

                        mylat = atoi(lat);
                        mylon = atoi(lon);

                        if ( ((lat_filter[0] == '\0' || mylat == latint) &&     /* either match tile exactely */
                              (lon_filter[0] == '\0' || mylon == lonint)) || 
 
                              ( (around && lat_filter[0] != '\0' && lon_filter[0] != '\0') && (     /* or also show tiles around it */
                                (mylat == latint-1 && mylon == lonint-1) || (mylat == latint-1 && mylon == lonint  ) ||
                                (mylat == latint-1 && mylon == lonint+1) || (mylat == latint   && mylon == lonint-1) ||
                                (mylat == latint   && mylon == lonint+1) || (mylat == latint+1 && mylon == lonint-1) ||
                                (mylat == latint+1 && mylon == lonint  ) || (mylat == latint+1 && mylon == lonint+1) )
                                ) ) {

                           if ( debug ) {
                              printf("%s %s %s\n",lon,lat,name);
                           } else {
                              printf("<point lat=\"%s\" long=\"%s\" template=\"land\" radius_mt=\"80\" loc_desc=\"%s\"/>\n",lat,lon,name);
                           }
			}
                     }
                  }
               }
            }
            fclose(in);
         }
      }
      closedir(d);
   }
   return(1);
}

/*-----------------------------------------------------------------*/

int main(int argc, char **argv) {

   char tmp[256];

   lat_filter[0] = '\0';
   lon_filter[0] = '\0';

   printf("heliscan - %s\n",VERSION);

   int arg = 1;
   int coords = 0;

   while (arg < argc) {

      if ( ! strcmp(argv[arg],"debug") ) {
         debug = 1;
      } else {
         if ( ! strcmp(argv[arg],"around") ) {
            around = 1;
         } else {
            if ( coords == 0 ) {
               strcpy(lat_filter,argv[arg]);
               printf("using lat_filter %s\n",lat_filter);
               latint = atoi(lat_filter);
               coords++;
            } else {
               if ( coords == 1 ) {
                  strcpy(lon_filter,argv[arg]);
                  printf("using lon_filter %s\n",lon_filter);
                  lonint = atoi(lon_filter);
                  coords++;
               }
            }
         }
      }
      arg++;
   }


   printf ("scanning for heli ports ...\n");

   scanHelis();
}

/*-----------------------------------------------------------------*/

