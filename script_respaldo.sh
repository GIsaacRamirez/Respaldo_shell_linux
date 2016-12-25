#!/bin/bash

SAVEIFS=$IFS
IFS=$(ECHO -EN "\n\b")

directorio=$""
dirname=$"RESPALDO"
fecha=$(date +"%d-%m-%Y")

if [ -d Escritorio ];
 then
	directorio=$"./Escritorio/"
else
	directorio=$"./Desktop/"
fi

mkdir $directorio$dirname
# Crear el directorio con el nombre 

nombre_de_script=`basename $0` 

find ~ -regextype posix-egrep -iregex '.*\.(c|c++|cpp|pdf|doc|docx|ppt|pptx|xls|xlsx|sh|)$' -not -name $nombre_de_script -exec cp --backup=numbered {} $directorio$dirname \;
##########################################################################################################

#En el for se renombra los ~numero ~
#usar IFS variables para solucionar lo de los espacios
for i in `find $directorio$dirname -regextype posix-egrep -iregex '.*\.~[0-9]*~$'`;
do
file=$directorio$dirname/`basename $i`
if [ -f $file ] ; then
NombreArchivo=${file##*/}
echo $i
nombresolo=$(echo $NombreArchivo|rev|cut -d"." -f3-|rev)
ext=$(echo $file | rev | cut -d'.' -f2 | rev)
num=$(echo $file | rev | cut -d'.' -f1 | rev)
mv $file $directorio$dirname"/"$nombresolo"bak"$num"."$ext
fi
done
IFS=$SAVEIFS

cd $directorio
#Comprimir
tar -c $dirname | bzip2 > $fecha.tar.bz2

#Eliminar directorio no vacio
rm -dfr $dirname

find ~ -regextype posix-egrep -iregex '.*\.(c|c++|cpp|pdf|doc|docx|ppt|pptx|xls|xlsx|sh|)$' -not -name $nombre_de_script -exec rm -f {} \;

#mv $fecha.tar.bz2 ~/

#Descomprimir tar jvxf 
