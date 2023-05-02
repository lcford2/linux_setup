
function fast_compress () {
    last=${@:$#}
    other=${*%${!#}}
    tar -c $other | pbzip2 -c > $last
}

function fast_uncompress () {
    pbzip2 -dc $1 | tar x
}
