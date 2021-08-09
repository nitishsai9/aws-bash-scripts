#!/bin/bash

fileName=""

echo -e "Enter Path"


read pathName


echo -e "Enter Bucket Name"

read bucketName

echo -e "Enter The output name"

read tarzipname


exactfunc (){
   if [[ -d "$pathName" ]] && [[ checkBucketExist -eq 0 ]];
   then
      fileName="$tarzipname.gz.tar"
      tar -zcf $fileName -C $pathName .
      if [ $? != 0 ];
      then
      echo "Tar Zip  Failed Possible"
      else
       aws s3 cp $fileName "s3://$bucketName"

       if [[  $? != 0  ]]; then
       echo "Not Uploaded Sucessfully"
       else
       echo "uploaded sucessfullyy"
       fi
      fi                                                                                                                                                                                                                                                                                                                                                                                                                                                           

   else
     echo "Path Not Found or Bucket Not Found"

   fi


   

}

if [[ $pathName == '' ]]  ||  [[ $bucketName == '' ]] || [[ $tarzipname == '' ]];
then
    echo "Either PathName or Bucket is Not Set or outputname is not set"
else 
   exactfunc
fi



