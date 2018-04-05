#!/bin/bash
push_option=""
if [ $# -gt 0 ]
then
  push_option=$1
  if [ "$push_option" != "-p" ]
  then
    echo "Usage : ./buildDockerImage.sh [-p] "
    echo "  -p : push the built image to docker hub"
    exit
  fi
fi
api_version=`cat versions.txt | grep transporter`
#echo "$api_version"
version=`echo $api_version | cut -f2 -d"="`
#echo $version
echo "Current Version : $version"
baby_version=`echo $version | cut -f3 -d"."`
minor_version=`echo $version | cut -f2 -d"."`
major_version=`echo $version | cut -f1 -d"."`
#echo $major_version $next_minor_version $baby_version
next_baby_version=`expr $baby_version + 1`
#echo $next_baby_version
next_minor_version=$minor_version
next_major_version=$major_version
if [ $next_baby_version -gt 99 ]
then
  next_baby_version=0
  next_minor_version=`expr $minor_version + 1`
  if [ $next_minor_version -gt 9 ]
  then
    next_minor_version=0
    next_major_version=`expr $major_version + 1`
  fi
fi
#echo $next_major_version $next_minor_version $next_baby_version
new_version="$next_major_version.$next_minor_version.$next_baby_version"
echo "Version to be built : $new_version"
docker build --file TransporterDockerfile -t flavour/transporter:$new_version .
if [ "$push_option" == "-p" ]
then
  echo "Pushing the image to Docker hub.."
  docker push flavour/transporter:$new_version
  echo "Done"
fi
# Now update the versions.txt
line_to_replace=$api_version
new_line="transporter=$new_version"
#echo "Line to Replace :$line_to_replace"
#echo "New line : $new_line"
sed "s/$line_to_replace/$new_line/g" versions.txt > versions2.txt
cat versions2.txt > versions.txt
rm versions2.txt
