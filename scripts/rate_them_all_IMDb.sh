#######################################################################
#  Get the IMDb rating for a list of movies on Netflix                #
#######################################################################
#!/usr/bin/env bash

if [ -z $1 ] ; then
 echo "Provide the URL to a Netflix genre          [Berkeley 12-26-25]"
 echo ""
 echo "EXAMPLES"
 echo "Usage: $0  https://www.netflix.com/browse/genre/8711                          # Horror movies "
 echo ""
 echo "Get the Netflix categories with the imdb-rating.sh script:"
 echo "Usage: ./imdb-rating.sh  --getlist  https://www.netflix.com/browse/genre/8711?bc=34399      # get list of horror movies"
 echo "Usage: ./imdb-rating.sh  --categories                                                       # get URLs of Netflix categories"
 exit
fi



all_categories=$(./imdb-rating.sh --categories | head -2 | awk '{print $NF,"\n"}')
one_category="https://www.netflix.com/browse/genre/7627"  # Cult Movies

if [ "$1" != "" ]; then
 one_category="$1"
fi

echo "CATEGORY: $one_category"

for category in $one_category
do
 echo "Generating list of movies in category  $category ..."
 ./imdb-rating.sh --getlist $category > mylist.txt
 cat mylist.txt
 line=$(head -1 mylist.txt)
 genre=$(echo "$line" | sed -n 's/.*genre "\([^"]*\)".*/\1/p')
 simplified=$(echo "$genre" | sed 's/[^a-zA-Z0-9]/_/g; s/_\+/_/g')

 list="list_${simplified}.txt"
 mv mylist.txt "$list" 
 list_rated="list_${simplified}_rating_imdb.txt"

 #Use omdbapi.com to find the IMDb rating of movies on the list
 ./imdb-rating_omdbapi.sh "$list"  > "$list_rated"  &
 
 # Monitor the file as is being written
 pid=$!
 tail -f "$list_rated" &
 tailpid=$!
 wait "$pid"        # wait until imdb-rating_omdbapi.sh finishes
 kill "$tailpid"    # stop tail
 head -2 "$list"  > nn.txt
 sort -g "$list_rated" >> nn.txt
 mv nn.txt "$list_rated"
 cat "$list_rated"


done
