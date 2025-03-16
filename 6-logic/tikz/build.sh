for filepath in **/*.pdf; do
    convert -density 300 $filepath -quality 100 "${$(basename $filepath)%.*}.png";
    echo "${$(basename $filepath)%.*}.png";
done