#!/bin/bash

DIR=$1
NAME_H=$2

prot=$(find $1 -type f -name '*.c' | xargs cat | sed -e '/^[a-z_A-Z].*)$/!d' -e '/^static/d' -e "s/)$/);/g" | LC_ALL=C sort)
TABS=$(echo "${prot}" | awk '{sub("[\t ][\t ]*\\**[a-zA-Z_0-9][a-zA-Z_0-9]*\\(.*", "");print length($0)}' |
		sort -nr | head -n 1 | xargs -I{} expr {} / 4 + 1)
header="$(sed -e '/typedef /! s/^[a-z_A-Z][a-zA-Z_0-9]*.*);$//g' -e '/#endif/d' -e '/^$/d' ${NAME_H})

$(echo "${prot}" |
	awk -v tabs=${TABS} '
	{
		s = $0;
		sub("[\t ][\t ]*\\**[a-zA-Z_0-9][a-zA-Z_0-9]*\\(.*", "");
		t = "";
		l = tabs - int(length($0) / 4);
		for (i = 0; i < l; i++)
			t=t"\t";
		str = substr(s, length($0) + 1, index(s, ";"))
		sub("[\t ][\t ]*", t, str);
		print $0 str
	}')

#endif"

echo "${header}" > ${NAME_H}
