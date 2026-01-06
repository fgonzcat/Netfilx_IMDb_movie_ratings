awk -F '\"' '/genre/{print "\n#=================#\n",$2,$3,FILENAME,"\n#=================#\n"} $1*1>=6.5 {print}' *imdb.txt
