#!/bin/bash

screencapture -l$(osascript -e 'tell app "QuickTime Player" to id of window 1') hqQT.png

magick 'hqQT.png' -crop 997x530+120+483 hqQ.png
magick 'hqQT.png' -crop 861x151+200+1020 hqA0.png
magick 'hqQT.png' -crop 861x151+200+1210 hqA1.png
magick 'hqQT.png' -crop 861x151+200+1387 hqA2.png

tesseract hqQ.png hqQ
tesseract hqA0.png hqA0
tesseract hqA1.png hqA1
tesseract hqA2.png hqA2

question=$(<hqQ.txt)
answer0=$(<hqA0.txt)
answer1=$(<hqA1.txt)
answer2=$(<hqA2.txt)

searchQuestion="$(tr " " + <<<$question)"

open "https://www.google.com/search?q=${searchQuestion}"

searchAnswer0="$(tr " " + <<<$answer0)"
hits0=`curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36" -sSL "https://www.google.com/search?q=${searchAnswer0}" |   /usr/bin/sed -nE 's/.*About ([0-9,]+) results.*/\1/p'`
hits0="${hits0//,}"
searchAnswer0=${searchQuestion}+${searchAnswer0}

searchAnswer1="$(tr " " + <<<$answer1)"
hits1=`curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36" -sSL "https://www.google.com/search?q=${searchAnswer1}" |   /usr/bin/sed -nE 's/.*About ([0-9,]+) results.*/\1/p'`
hits1="${hits1//,}"
searchAnswer1=${searchQuestion}+${searchAnswer1}

searchAnswer2="$(tr " " + <<<$answer2)"
hits2=`curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36" -sSL "https://www.google.com/search?q=${searchAnswer2}" |   /usr/bin/sed -nE 's/.*About ([0-9,]+) results.*/\1/p'`
hits2="${hits2//,}"
searchAnswer2=${searchQuestion}+${searchAnswer2}

results0=`curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36" -sSL "https://www.google.com/search?q=${searchAnswer0}" |   /usr/bin/sed -nE 's/.*About ([0-9,]+) results.*/\1/p'`
results0="${results0//,}"
results1=`curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36" -sSL "https://www.google.com/search?q=${searchAnswer1}" |   /usr/bin/sed -nE 's/.*About ([0-9,]+) results.*/\1/p'`
results1="${results1//,}"
results2=`curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36" -sSL "https://www.google.com/search?q=${searchAnswer2}" |   /usr/bin/sed -nE 's/.*About ([0-9,]+) results.*/\1/p'`
results2="${results2//,}"

totalHits=$((hits0+hits1+hits2))

weightedResults0=`echo "scale=1; (1 - ( $hits0 / $totalHits ) ) * $results0" | bc`
weightedResults1=`echo "scale=1; (1 - ( $hits1 / $totalHits ) ) * $results1" | bc`
weightedResults2=`echo "scale=1; (1 - ( $hits2 / $totalHits ) ) * $results2" | bc`

printf "\n${question}\n"
printf "\nAnswer\t\t\tResults\t\t\tResults_Weighted"
printf "\n${answer0}\t\t\t\t${results0}\t\t\t\t${weightedResults0}"
printf "\n${answer1}\t\t\t\t${results1}\t\t\t\t${weightedResults1}"
printf "\n${answer2}\t\t\t\t${results2}\t\t\t\t${weightedResults2}"
printf \n 


