#!/usr/bin/perl
#**********************************************************************************#
#                                                                                  #
#                                                                                  #
#                                                                                  #
# PROGRAM: remove_dublicate.pl                                                     #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# DESCRIPTION :  This program do following things                                  #
#                1)Remove duplicate email and phone number                         #
#	         2)Sort phone number and email                                     #
#                3)Generate new sorted and unique phone and email file      	   #	  
#                                                                                  #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# INPUT PARMS: None                                                                #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# INPUT FILES: email.txt,phone.txt,lastCountFile.txt                                #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# OUTPUT FILE:  sortedEmail.txt ,sortedPhone.txt ,newNumberInList.txt              #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# EXITS:       0 - success                                                         #
#                                                                                  #
#             -1 - failure                                                         #
#                                                                                  #
#                                                                                  #
#                                                                                  #
#**********************************************************************************#
#                                                                                  #
#                                                                                  #
#                                                                                  #
#                     Modification Log                                             #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# Date        CSR/CO   Author            Description                               #
#                                                                                  #
# ----------  ------   --------------    -----------------                         #
#                                                                                  #
# 08/27/2013   15079   Rakesh malviya      Initial implementation.                 #
#                                                                                  #
# 02/26/2014   15079   hitesh sharma      added new function                       #
#                                                                                  #
#**********************************************************************************#
use File::Copy qw(move); 
use List::MoreUtils qw{ any };
my $index=0;
my $total =0;
my $WrtRec =0;
my $dublicate = 0;
my $emailFile = "email.txt";

# Remove spaces from front and back side

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

# Avoiding dublicate value by comparing current value with previous value
sub findString
{

my $result = 0; 

 my ($currentPattern, @prevArray) = @_;

 foreach my $prevArrayElement (@prevArray)
 {

    $currentPattern = trim($currentPattern);
    $prevArrayElement = trim($prevArrayElement);
    if($currentPattern eq $prevArrayElement)
    {

      $result = 1;
    }

 }

  return $result;
}
####################################################################################
#
#
#
#                                START OF PROGRAM
#
#
#####################################################################################
print("                            Email Report                                  \n");


#-----------------------------------------------
# Logic to Sorting email and remove dublicate value
#----------------------------------------------

#File for current email list
my $filename = "email.txt";

#File for previous run email
my $sortFile = "sortEmail.txt";
my $prevEmailFile = $sortFile;
my @prevArr;

# Checking email.txt file exist or not if does not then control does not go inside if condition 
# Inside this if condition only we remove dublicate email and sort the email 
if(-e $filename)
{
    open FILE, $filename or die "Can't open $filename\n";
    my @lines = <FILE>;
    close FILE;


    if(-e $prevEmailFile)
    {
       open FILE, $prevEmailFile or die "Can't open $prevEmailFile\n";
       @prevArr=<FILE>;
       close FILE;
    }
    my @sortedArray = sort @lines;
    my $prevLine = "rakk";

    open(my $EmailFileHan, '>>', $sortFile) or die "Could not open file $sortFile $!";
# remove dublicate value by coparing current and previous run email
foreach my $nextLine (@sortedArray)
{ 


  my $size = scalar(@prevArr);
  my $result = findString($nextLine , @prevArr);
  
 $total = $total+1;
 $nextLine = trim($nextLine);
 if($nextLine ne  $prevLine && $result != 1)
 {

   $WrtRec = $WrtRec+1;
   print("Writing = $nextLine\n");
   print $EmailFileHan "$nextLine\n";
 }
$prevLine = trim($nextLine);

}

close $EmailFileHan;
$dublicate = $total - $WrtRec;
print("-------------------------------------------------------------------------\n");
print("Total Number of Rec | Total Number of Rc Writen | Total Dublicate Rec\n");
print("$total                   | $WrtRec                         | $dublicate\n");
print("-------------------------------------------------------------------------\n");
}
else
{

 print("Please create $filename  file , it does not exist\n\n");
}

#-----------------------------------------------
# Logic to Sorting Phone Number and remove dublicate value
#----------------------------------------------
$index=0;
$total =0;
$WrtRec =0;
$dublicate = 0;

#phone.txt contain current phone number
my $filename = "phone.txt";
#sortPhone.txt contain previous run phone email
my $sortFile = "sortPhone.txt";
my $prevEmailFile = $sortFile;
# New number will come in below file
my $finalFilePhone = "NameNumber.txt";
# value in this file will be use to looping purpose
my $lstContFile = "lastCountFile.txt";
my @prevArr;
my $appendNum;

# IF phone.txt exist then only then go inside loop

if(-e $filename)
{
    open FILE, $filename or die "Can't open $filename\n";
    my @lines = <FILE>;
    close FILE;

     # opening sortphone.txt file

    if(-e $prevEmailFile)
    {
       open FILE, $prevEmailFile or die "Can't open $prevEmailFile\n";
       @prevArr=<FILE>;
       close FILE;
    }


    # sorting array 
    my @sortedArray = sort @lines;
    my $prevLine = "rakk";

       #open lastcount file to get last count
       open FILE, $lstContFile or die "Can't open $prevEmailFile\n";
       @counter=<FILE>;
       close FILE;

    # opening file in append mode
    open(my $EmailFileHan, '>>', $sortFile) or die "Couldiiiiii not open file $sortFile $!";

    open FinalPhoneHan, "+>$finalFilePhone" or die "Couldn't open file $finalFilePhone, $!";

    #opening file in overwrite mode
    open lastContHan, "+>$lstContFile" or die "Couldn't open file $lstContFile, $!";
    print("last count = $counter[0]\n");
foreach my $nextLine (@sortedArray)
{

  my $result =0;
  my $size = scalar(@prevArr);
  if($size >0)
  {
     $result = findString($nextLine , @prevArr);
  }

 $total = $total+1;
 $nextLine = trim($nextLine);

 # Comparing last run phone number and current list phone number and removing dublicate
 if($nextLine ne  $prevLine && $result != 1)
 {

   $WrtRec = $WrtRec+1;
   $appendNum = $WrtRec + $counter[0]; 
   print $EmailFileHan "$nextLine\n";

   # Genrating Unique name as well for each phone number
   print FinalPhoneHan "Z$appendNum,$nextLine\n";
 }
 else
 {
   print("dublicate value = $nextLine\n");
 }
$prevLine = trim($nextLine);

}

print("last contact = $appendNum\n");
if($WrtRec > 0)
{
   print lastContHan $appendNum;
}
else 
{
   print lastContHan $counter[0];
}
close $EmailFileHan;
close FinalPhoneHan;
close lastCountFile;
$dublicate = $total - $WrtRec;
print("-------------------------------------------------------------------------\n");
print("Total Number of Rec | Total Number of Rc Writen | Total Dublicate Rec\n");
print("$total                   | $WrtRec                         | $dublicate\n");
print("-------------------------------------------------------------------------\n");
}
else
{

 print("Please create $filename  file , it does not exist\n\n");
}


