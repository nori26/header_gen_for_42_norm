#!/bin/bash

NAME_H="name.h"

prot=$(find . -type d -name libft -prune -o -type f -name '*.c' | xargs cat | sed -e '/^[a-zA-Z].*)$/!d' -e '/^static/d' -e "s/)$/);/g")
TABS=$(echo "${prot}" | awk '{sub("[\t ].*", "");print length($0)}' | sort -nr | head -n 1 | xargs -I{} expr {} / 4 + 1)

header="$(sed -e "/^[a-zA-Z][a-zA-Z_0-9]*.*);$/d" -e '/#endif/d' -e '/^$/d' ${NAME_H})

$(echo "${prot}" | awk -v tabs=${TABS} '{s=$0; sub("[\t ].*", ""); l=tabs - int(length($0) / 4); t="";for(i=0;i<l;i++){t=t "\t"};sub("[\t ][\t ]*", t, s); print s}')

#endif"

echo "${header}" > ${NAME_H}