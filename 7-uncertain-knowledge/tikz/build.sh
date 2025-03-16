for filepath in **/*.pdf; do
    convert -density 300 $filepath -quality 100 "${filepath%.pdf}.png";
    echo "${filepath%.pdf}.png";
done